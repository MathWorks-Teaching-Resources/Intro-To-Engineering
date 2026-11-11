classdef SerialMonitor < matlab.apps.AppBase
    %SerialMonitor - Plot and record line-based serial data
    %   APP = SerialMonitor opens a serial monitor with a live plot and log.
    %
    %   APP = SerialMonitor(Visible="off") creates a hidden window.
    %
    %   APP = SerialMonitor(RecordLimit=N) stops recording after N messages.
    %
    %   APP = SerialMonitor(TimeWindow=T) shows the latest T seconds of data.
    %   The default plot window is 10 seconds.
    %
    %   SerialMonitor functions:
    %       connect          - Open a serial port and prepare a new capture
    %       startAcquisition - Start or resume recording
    %       stopAcquisition  - Stop recording and retain the connection
    %       disconnect       - Release the connection and retain the capture
    %       exportData       - Save numeric samples as a MAT timetable
    %       delete           - Release the connection and close the window
    %
    %   SerialMonitor properties:
    %       UIFigure                      - App window
    %       UIAxes                        - Live numeric plot
    %       TextArea                      - Serial message log
    %       TextAreaLabel                 - Log label
    %       AvailableDeviceDropDown       - Serial port selector
    %       AvailableDeviceDropDownLabel  - Port label
    %       BaudRateDropDown              - Baud rate selector
    %       BaudRateDropDownLabel         - Baud rate label
    %       RefreshButton                 - Refresh available ports
    %       ConnectButton                 - Connect or disconnect
    %       StartStopButton               - Start, stop, or resume recording
    %       ExportDataButton              - Export captured numeric samples
    %       StatusLabel                   - Connection and capture feedback
    %       Connected                     - Whether the port is open
    %       Acquiring                     - Whether messages are recorded
    %       Port                          - Connected port name
    %       Time                          - Host receipt times in seconds
    %       Data                          - Numeric values, with NaN for text
    %       RecordLimit                   - Maximum retained message count
    %       TimeWindow                    - Width of the sliding plot window
    %
    %   See also SERIALPORT, TIMETABLE, UIFIGURE

    properties (Access = public)
        UIFigure                      matlab.ui.Figure % App window
        UIAxes                        matlab.ui.control.UIAxes % Live plot
        TextArea                      matlab.ui.control.TextArea % Message log
        TextAreaLabel                 matlab.ui.control.Label % Log label
        AvailableDeviceDropDown       matlab.ui.control.DropDown % Port
        AvailableDeviceDropDownLabel  matlab.ui.control.Label % Port label
        BaudRateDropDown              matlab.ui.control.DropDown % Baud rate
        BaudRateDropDownLabel         matlab.ui.control.Label % Baud label
        RefreshButton                 matlab.ui.control.Button % Port refresh
        ConnectButton                 matlab.ui.control.StateButton % Connection
        StartStopButton               matlab.ui.control.StateButton % Recording
        ExportDataButton              matlab.ui.control.Button % MAT export
        StatusLabel                   matlab.ui.control.Label % Status
    end

    properties (SetAccess = private)
        Connected = false % Whether the serial connection is open
        Acquiring = false % Whether incoming messages are recorded
        Port = "" % Connected serial port name
        Time = zeros(0,1) % Host receipt times relative to the first Start
        Data = zeros(0,1) % Values; nonnumeric messages are represented by NaN
        RecordLimit = 100000 % Maximum retained message count
        TimeWindow = 10 % Sliding plot window in seconds
    end

    properties (Access = private)
        serial % Owned serialport object
        Clock % Instance-specific capture clock
        PlotLine % Animated line in UIAxes
        LogLines = strings(0,1)
        ExportedCount = 0
        CallbackGeneration = 0
        Closing = false
    end

    methods
        function app = SerialMonitor(options)
            arguments
                options.Visible (1,1) string ...
                    {mustBeMember(options.Visible,["on","off"])} = "on"
                options.RecordLimit (1,1) ...
                    {mustBeNumeric,mustBeReal,mustBeFinite,mustBeInteger, ...
                    mustBePositive,mustBeLessThanOrEqual(options.RecordLimit,1000000)} = 100000
                options.TimeWindow (1,1) ...
                    {mustBeNumeric,mustBeReal,mustBeFinite,mustBePositive} = 10
            end
            app.RecordLimit = double(options.RecordLimit);
            app.TimeWindow = double(options.TimeWindow);
            try
                createComponents(app);
                registerApp(app,app.UIFigure);
                runStartupFcn(app,@refreshPorts);
                app.UIFigure.Visible = options.Visible;
            catch exception
                delete(app);
                rethrow(exception)
            end
            if nargout == 0
                clear app
            end
        end

        function connect(app,port,baud)
            %CONNECT - Open a serial port and prepare a new capture
            %   CONNECT(APP,PORT) opens PORT at 9600 baud using CR/LF lines.
            %
            %   CONNECT(APP,PORT,BAUD) also specifies the baud rate.
            arguments
                app
                port {mustBeTextScalar,mustBeNonempty}
                baud (1,1) {mustBeNumeric,mustBeReal,mustBeFinite, ...
                    mustBeInteger,mustBePositive} = 9600
            end
            if app.Connected
                error("SerialMonitor:AlreadyConnected", ...
                    "Disconnect before choosing another port.");
            end
            try
                app.serial = serialport(port,double(baud),"Timeout",0.5);
                configureTerminator(app.serial,"CR/LF");
                setDTR(app.serial,true);
                if isprop(app.serial,"ErrorOccurredFcn")
                    app.serial.ErrorOccurredFcn = @(~,~) connectionLost(app);
                end
                app.Port = string(port);
                app.Connected = true;
                resetCapture(app);
                if ~ismember(string(port),string(app.AvailableDeviceDropDown.Items))
                    app.AvailableDeviceDropDown.Items = ...
                        [string(app.AvailableDeviceDropDown.Items),string(port)];
                end
                app.AvailableDeviceDropDown.Value = char(port);
                baudText = string(baud);
                if ~ismember(baudText,string(app.BaudRateDropDown.Items))
                    app.BaudRateDropDown.Items = ...
                        [string(app.BaudRateDropDown.Items),baudText];
                end
                app.BaudRateDropDown.Value = char(baudText);
                app.StatusLabel.Text = "Connected to " + app.Port + ". Select Start.";
                updateControls(app);
            catch exception
                releaseConnection(app);
                updateControls(app);
                app.StatusLabel.Text = "Connection failed. Check the port and close other monitors.";
                rethrow(exception)
            end
        end

        function startAcquisition(app)
            %startAcquisition - Start or resume the current capture
            %   startAcquisition(APP) records CR/LF-terminated messages.
            %   Unread bytes accumulated while stopped are discarded.
            if ~app.Connected
                error("SerialMonitor:Disconnected","Connect before recording.");
            end
            if numel(app.Data) >= app.RecordLimit
                error("SerialMonitor:CaptureFull", ...
                    "Export the capture, then reconnect to start another.");
            end
            if app.Acquiring
                return
            end
            flush(app.serial,"input");
            if isempty(app.Clock)
                app.Clock = tic;
            elseif ~isempty(app.Data)
                % Leave a visual gap for the interval that was not recorded.
                addpoints(app.PlotLine,toc(app.Clock),NaN);
            end
            app.CallbackGeneration = app.CallbackGeneration + 1;
            generation = app.CallbackGeneration;
            app.Acquiring = true;
            try
                configureCallback(app.serial,"terminator", ...
                    @(src,~) readData(app,src,generation));
            catch exception
                app.Acquiring = false;
                updateControls(app);
                rethrow(exception)
            end
            app.StatusLabel.Text = "Receiving on " + app.Port + ".";
            updateLog(app);
            updateControls(app);
        end

        function stopAcquisition(app)
            %stopAcquisition - Stop recording without discarding the capture
            %   stopAcquisition(APP) keeps the port open and retains samples.
            app.Acquiring = false;
            app.CallbackGeneration = app.CallbackGeneration + 1;
            if ~isempty(app.serial) && isvalid(app.serial)
                configureCallback(app.serial,"off");
            end
            app.StatusLabel.Text = "Stopped. Captured data is retained.";
            updateLog(app);
            updateControls(app);
        end

        function disconnect(app)
            %DISCONNECT - Release the port without discarding the capture
            %   DISCONNECT(APP) stops reception and releases the serial port.
            releaseConnection(app);
            if ~app.Closing
                app.StatusLabel.Text = "Disconnected. Captured data is retained.";
                updateControls(app);
            end
        end

        function exportData(app,filename)
            %exportData - Save captured numeric samples in a MAT file
            %   exportData(APP,FILENAME) saves a SerialData timetable with
            %   duration row times and a Data variable. Text is excluded.
            arguments
                app
                filename {mustBeTextScalar,mustBeNonempty}
            end
            keep = isfinite(app.Data);
            if ~any(keep)
                error("SerialMonitor:NoData","Record numeric data before exporting.");
            end
            [~,~,extension] = fileparts(filename);
            if strlength(extension) == 0
                filename = string(filename) + ".mat";
            elseif ~strcmpi(extension,".mat")
                error("SerialMonitor:FileType","Choose a .mat file for export.");
            end
            captureValues = app.Data(keep);
            SerialData = timetable(captureValues,RowTimes=seconds(app.Time(keep)), ...
                VariableNames="Data");
            save(char(filename),"SerialData");
            app.ExportedCount = numel(app.Data);
            app.StatusLabel.Text = sprintf("Exported %d numeric samples.",numel(captureValues));
        end

        function delete(app)
            if app.Closing
                return
            end
            app.Closing = true;
            releaseConnection(app);
            if ~isempty(app.UIFigure) && isvalid(app.UIFigure)
                delete(app.UIFigure);
            end
        end
    end

    methods (Access = private)
        function readData(app,src,generation)
            %readData - Record one complete line from the serial callback
            if ~isvalid(app) || app.Closing || ~app.Acquiring || ...
                    generation ~= app.CallbackGeneration
                return
            end
            try
                if src.NumBytesAvailable == 0
                    return
                end
                line = readline(src);
                time = toc(app.Clock);
                value = str2double(line);
                if ~isreal(value) || ~isfinite(value)
                    value = NaN;
                end
                app.Time(end+1,1) = time;
                app.Data(end+1,1) = value;
                if isfinite(value)
                    app.ExportDataButton.Enable = "on";
                end
                addpoints(app.PlotLine,time,value);
                app.UIAxes.XLim = [max(0,time-app.TimeWindow),max(app.TimeWindow,time)];
                app.LogLines(end+1,1) = sprintf("%8.2f  %s",time,line);
                app.LogLines = app.LogLines(max(1,end-999):end);
                updateLog(app);
                app.StatusLabel.Text = sprintf("Receiving on %s | %d messages", ...
                    app.Port,numel(app.Data));
                if numel(app.Data) >= app.RecordLimit
                    stopAcquisition(app);
                    app.StatusLabel.Text = "Capture limit reached. Export, then reconnect.";
                end
                drawnow limitrate nocallbacks
            catch exception
                disconnect(app);
                showError(app,exception,"Serial connection error");
            end
        end

        function resetCapture(app)
            %resetCapture - Prepare storage and views for a new connection
            app.Time = zeros(0,1);
            app.Data = zeros(0,1);
            app.Clock = [];
            app.ExportedCount = 0;
            app.LogLines = strings(0,1);
            app.TextArea.Value = "Time (s)  Value";
            clearpoints(app.PlotLine);
            app.UIAxes.XLim = [0 app.TimeWindow];
        end

        function releaseConnection(app)
            %releaseConnection - Disable callbacks and release the owned port
            app.Acquiring = false;
            app.Connected = false;
            app.Port = "";
            app.CallbackGeneration = app.CallbackGeneration + 1;
            device = app.serial;
            app.serial = [];
            if ~isempty(device) && isvalid(device)
                try
                    configureCallback(device,"off");
                    if isprop(device,"ErrorOccurredFcn")
                        device.ErrorOccurredFcn = [];
                    end
                catch
                    % An unplugged device can reject callback configuration.
                end
                delete(device);
            end
        end

        function refreshPorts(app)
            %refreshPorts - Refresh selectable ports without opening them
            try
                ports = string(serialportlist("available"));
                previous = string(app.AvailableDeviceDropDown.Value);
                if isempty(ports)
                    app.AvailableDeviceDropDown.Items = "No available ports";
                    app.StatusLabel.Text = "Connect a device or close other serial monitors.";
                else
                    app.AvailableDeviceDropDown.Items = cellstr(ports(:)');
                    if ismember(previous,ports)
                        app.AvailableDeviceDropDown.Value = char(previous);
                    end
                    app.StatusLabel.Text = "Select a serial port, then Connect.";
                end
            catch exception
                app.AvailableDeviceDropDown.Items = "No available ports";
                showError(app,exception,"Port discovery error");
            end
            updateControls(app);
        end

        function updateControls(app)
            %updateControls - Reflect connection, recording, and data state
            if app.Closing
                return
            end
            app.AvailableDeviceDropDown.Enable = ~app.Connected;
            app.BaudRateDropDown.Enable = ~app.Connected;
            app.RefreshButton.Enable = ~app.Connected;
            app.ConnectButton.Enable = app.Connected || ...
                ~strcmp(app.AvailableDeviceDropDown.Value,"No available ports");
            app.ConnectButton.Value = app.Connected;
            if app.Connected
                app.ConnectButton.Text = "Disconnect";
            else
                app.ConnectButton.Text = "Connect";
            end
            app.StartStopButton.Enable = app.Connected && numel(app.Data) < app.RecordLimit;
            app.StartStopButton.Value = app.Acquiring;
            if app.Acquiring
                app.StartStopButton.Text = "Stop";
            elseif isempty(app.Clock)
                app.StartStopButton.Text = "Start";
            else
                app.StartStopButton.Text = "Resume";
            end
            app.ExportDataButton.Enable = any(isfinite(app.Data));
        end

        function ConnectButtonValueChanged(app)
            %ConnectButtonValueChanged - Connect, confirm replacement, or disconnect
            try
                if app.Connected
                    disconnect(app);
                else
                    if numel(app.Data) > app.ExportedCount
                        choice = uiconfirm(app.UIFigure, ...
                            "Discard this capture? Export first to keep numeric data.", ...
                            "Serial Monitor — New Capture",Options=["Discard Anyway","Cancel"], ...
                            DefaultOption=2,CancelOption=2,Icon="warning");
                        if strcmp(choice,"Cancel")
                            updateControls(app);
                            return
                        end
                    end
                    connect(app,app.AvailableDeviceDropDown.Value, ...
                        str2double(app.BaudRateDropDown.Value));
                end
            catch exception
                updateControls(app);
                showError(app,exception,"Connection error");
            end
        end

        function StartStopButtonValueChanged(app)
            %StartStopButtonValueChanged - Start, stop, or resume recording
            try
                if app.Acquiring
                    stopAcquisition(app);
                else
                    startAcquisition(app);
                end
            catch exception
                updateControls(app);
                showError(app,exception,"Recording error");
            end
        end

        function ExportDataButtonPushed(app)
            %ExportDataButtonPushed - Choose a MAT file and save the capture
            [filename,folder] = uiputfile("*.mat","Serial Monitor — Export Data","SerialData.mat");
            if ~isequal(filename,0)
                try
                    exportData(app,fullfile(folder,filename));
                catch exception
                    showError(app,exception,"Export error");
                end
            end
        end

        function connectionLost(app)
            %connectionLost - Retain recorded data after a device failure
            if isvalid(app) && ~app.Closing && app.Connected
                disconnect(app);
                app.StatusLabel.Text = "Connection lost. Check the cable, then reconnect.";
            end
        end

        function showError(app,exception,titleText)
            %showError - Report an actionable error without clearing data
            if isvalid(app) && ~app.Closing
                app.StatusLabel.Text = titleText + ". See the serial log for details.";
                app.LogLines(end+1,1) = titleText + ": " + string(exception.message);
                app.LogLines = app.LogLines(max(1,end-999):end);
                app.TextArea.Value = [string(exception.message);app.LogLines];
                scroll(app.TextArea,"top");
            end
        end

        function closeRequest(app)
            %closeRequest - Confirm before closing with unexported data
            if numel(app.Data) > app.ExportedCount
                choice = uiconfirm(app.UIFigure, ...
                    "Discard this capture? Export first to keep numeric data.", ...
                    "Serial Monitor — Close App",Options=["Discard Anyway","Cancel"], ...
                    DefaultOption=2,CancelOption=2,Icon="warning");
                if strcmp(choice,"Cancel")
                    return
                end
            end
            delete(app);
        end

        function updateLog(app)
            %updateLog - Follow recent messages without native scroll races
            lines = app.LogLines;
            if app.Acquiring
                rows = max(1,floor((app.TextArea.Position(4)-10) / ...
                    (1.5*app.TextArea.FontSize))-1);
                lines = lines(max(1,end-rows+1):end);
            end
            app.TextArea.Value = ["Time (s)  Value";lines];
            scroll(app.TextArea,"top");
        end

        function createComponents(app)
            %createComponents - Build the original plot-and-log working area
            app.UIFigure = uifigure(Visible="off",WindowStyle="normal",Name="Serial Monitor", ...
                AutoResizeChildren="off", ...
                Position=[100 100 640 480],CloseRequestFcn=@(~,~) closeRequest(app));
            main = uigridlayout(app.UIFigure,[4 1], ...
                RowHeight={32,"1x",32,22},Padding=[10 10 10 10],RowSpacing=10);
            connection = uigridlayout(main,[1 6], ...
                ColumnWidth={35,"1x",65,35,85,95},Padding=[0 0 0 0],ColumnSpacing=10);
            connection.Layout.Row = 1;
            app.AvailableDeviceDropDownLabel = uilabel(connection,Text="Port");
            app.AvailableDeviceDropDown = uidropdown(connection,Items="No available ports", ...
                Tooltip="Choose the port used by your device");
            app.RefreshButton = uibutton(connection,Text="Refresh", ...
                ButtonPushedFcn=@(~,~) refreshPorts(app), ...
                Tooltip="Look for newly connected serial devices");
            app.BaudRateDropDownLabel = uilabel(connection,Text="Baud");
            app.BaudRateDropDown = uidropdown(connection, ...
                Items=["9600","19200","38400","57600","115200","230400","460800","921600"], ...
                Value="9600",Tooltip="Match the device baud rate");
            app.ConnectButton = uibutton(connection,"state",Text="Connect", ...
                ValueChangedFcn=@(~,~) ConnectButtonValueChanged(app), ...
                Tooltip="Open or release the selected serial port");

            content = uigridlayout(main,[1 2], ...
                ColumnWidth={"2x","1x"},Padding=[0 0 0 0],ColumnSpacing=10);
            content.Layout.Row = 2;
            scope = struct("background",[0 0 0],"text",[0.85 0.85 0.85], ...
                "grid",[0.35 0.35 0.35],"trace",[1 1 0]);
            plotGrid = uigridlayout(content,[1 1], ...
                Padding=[0 0 0 0],BackgroundColor=scope.background);
            app.UIAxes = uiaxes(plotGrid);
            app.UIAxes.Color = scope.background;
            app.UIAxes.BackgroundColor = scope.background;
            app.UIAxes.XColor = scope.text;
            app.UIAxes.YColor = scope.text;
            app.UIAxes.GridColor = scope.grid;
            app.UIAxes.GridAlpha = 1;
            app.UIAxes.GridLineStyle = ":";
            app.UIAxes.Box = "on";
            app.UIAxes.XLim = [0 app.TimeWindow];
            colororder(app.UIAxes,scope.trace);
            title(app.UIAxes,"Live Serial Data");
            app.UIAxes.Title.Color = scope.text;
            xlabel(app.UIAxes,"Time (s)");
            ylabel(app.UIAxes,"Value");
            app.UIAxes.XGrid = "on";
            app.UIAxes.YGrid = "on";
            app.PlotLine = animatedline(app.UIAxes,MaximumNumPoints=2000, ...
                Color=scope.trace,LineWidth=1);
            logGrid = uigridlayout(content,[2 1], ...
                RowHeight={22,"1x"},Padding=[0 0 0 0],RowSpacing=10);
            app.TextAreaLabel = uilabel(logGrid,Text="Serial log");
            app.TextArea = uitextarea(logGrid,Editable="off",WordWrap="off", ...
                FontName=get(groot,"FixedWidthFontName"),FontSize=13, ...
                Value="Time (s)  Value",Tooltip="Host receipt time and device messages");

            actions = uigridlayout(main,[1 3], ...
                ColumnWidth={100,110,"1x"},Padding=[0 0 0 0],ColumnSpacing=10);
            actions.Layout.Row = 3;
            app.StartStopButton = uibutton(actions,"state",Text="Start", ...
                ValueChangedFcn=@(~,~) StartStopButtonValueChanged(app), ...
                Tooltip="Start, stop, or resume the current capture");
            app.ExportDataButton = uibutton(actions,Text="Export Data", ...
                ButtonPushedFcn=@(~,~) ExportDataButtonPushed(app), ...
                Tooltip="Save captured numeric samples to a MAT file");
            app.StatusLabel = uilabel(main,Text="Select a serial port, then Connect.");
            app.StatusLabel.Layout.Row = 4;
            app.UIFigure.SizeChangedFcn = @(~,~) minimumSize(app);
        end

        function minimumSize(app)
            %minimumSize - Keep the original controls usable when resized
            if ~isvalid(app) || app.Closing
                return
            end
            position = app.UIFigure.Position;
            dimensions = max(position(3:4),[500 360]);
            if ~isequal(position(3:4),dimensions)
                position(3:4) = dimensions;
                app.UIFigure.Position = position;
            end
            updateLog(app);
        end
    end
end
