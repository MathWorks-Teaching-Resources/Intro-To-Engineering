classdef SerialMonitorTests < matlab.unittest.TestCase
    %SerialMonitorTests - Check the standalone native serial monitor
    %   RESULTS = RUNTESTS("SoftwareTests/SerialMonitorTests.m") runs
    %   hardware-free UI, prerequisite, cleanup, and dependency checks.
    %
    %   See also SerialMonitor, RUNTESTS

    methods (TestClassSetup)
        function appFolder(testCase)
            root = fileparts(fileparts(mfilename("fullpath")));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture(fullfile(root,"Apps")));
        end
    end

    methods (Test)
        function startsWithVisibleContentAndDisabledRecording(testCase)
            app = createApp(testCase);
            testCase.verifyFalse(app.Connected);
            testCase.verifyFalse(app.Acquiring);
            testCase.verifyEqual(string(app.UIAxes.Visible),"on");
            testCase.verifyEqual(string(app.TextArea.Visible),"on");
            testCase.verifyEqual(string(app.TextAreaLabel.Text),"Serial log");
            testCase.verifyEqual(string(app.StartStopButton.Enable),"off");
            testCase.verifyEqual(string(app.ExportDataButton.Enable),"off");
            testCase.verifyEmpty(app.Time);
            testCase.verifyEmpty(app.Data);
        end

        function recordingRequiresAConnection(testCase)
            app = createApp(testCase);
            testCase.verifyError(@()app.startAcquisition(),"SerialMonitor:Disconnected");
            testCase.verifyFalse(app.Acquiring);
        end

        function emptyExportDoesNotCreateAFile(testCase)
            app = createApp(testCase);
            folder = testCase.applyFixture(matlab.unittest.fixtures.TemporaryFolderFixture);
            filename = fullfile(folder.Folder,"capture.mat");
            testCase.verifyError(@()app.exportData(filename),"SerialMonitor:NoData");
            testCase.verifyFalse(isfile(filename));
        end

        function failedConnectionRestoresControls(testCase)
            app = createApp(testCase);
            exception = SerialMonitorTests.failedConnection(app);
            testCase.verifyClass(exception,"MException");
            testCase.verifyFalse(app.Connected);
            testCase.verifyFalse(app.Acquiring);
            testCase.verifyEqual(string(app.AvailableDeviceDropDown.Enable),"on");
            testCase.verifyEqual(string(app.StartStopButton.Enable),"off");
            testCase.verifyNotEmpty(app.StatusLabel.Text);
        end

        function closingDeletesTheAppAndWindow(testCase)
            app = createApp(testCase);
            figureHandle = app.UIFigure;
            close(figureHandle);
            testCase.verifyFalse(isvalid(app));
            testCase.verifyFalse(isvalid(figureHandle));
        end

        function runtimeNeedsOnlyTheAppSource(testCase)
            root = fileparts(fileparts(mfilename("fullpath")));
            source = fullfile(root,"Apps","SerialMonitor.m");
            files = matlab.codetools.requiredFilesAndProducts(source);
            appFiles = string(files(startsWith(string(files),fullfile(root,"Apps"))));
            testCase.verifyEqual(appFiles,string(source));
        end
    end

    methods (Access = private)
        function app = createApp(testCase)
            %createApp - Create a hidden app with automatic teardown
            app = SerialMonitor(Visible="off");
            testCase.addTeardown(@()delete(app));
        end
    end

    methods (Static, Access = private)
        function exception = failedConnection(app)
            %failedConnection - Capture an invalid-port error for inspection
            exception = [];
            try
                app.connect("INVALID_PORT");
            catch exception
            end
        end
    end
end
