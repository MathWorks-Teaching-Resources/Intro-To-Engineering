function RunAllTests(ShowReport)
arguments
    ShowReport (1,1) logical = false;
end

import matlab.unittest.plugins.TestReportPlugin;

% Install DHT library
installedAddOn = false;
addons = matlab.addons.installedAddons;
addonsID = find(addons.Name == "Arduino Additional Sensors Library (DHT, LPS331)");
if addonsID == []
    installedAddOn = true;
    gitclone("https://github.com/roslovets/Arduino_Additional_Sensors_Simulink_Library_DHT_LPS331.git")
    addpath("Arduino_Additional_Sensors_Simulink_Library_DHT_LPS331");
    addpath(fullfile("Arduino_Additional_Sensors_Simulink_Library_DHT_LPS331","drivers","DHT"));
    addpath(fullfile("Arduino_Additional_Sensors_Simulink_Library_DHT_LPS331","drivers","LPS331"));
    disp("DHT drivers installed.")
else
    if ~addons.Enabled(addonsID)
        matlab.addons.enableAddon("Arduino Additional Sensors Library (DHT, LPS331)");
        disp("DHT drivers enabled")
    end
end

% Create a runner
Runner = matlab.unittest.TestRunner.withTextOutput;
Folder = fullfile(currentProject().RootFolder,"public",version("-release"));
if ~isfolder(Folder)
    mkdir(Folder)
else
    rmdir(Folder,'s')
    mkdir(Folder)
end
Plugin = TestReportPlugin.producingHTML(Folder,...
    "IncludingPassingDiagnostics",true,...
    "IncludingCommandWindowText",true,...
    "LoggingLevel",matlab.automation.Verbosity(1));
Runner.addPlugin(Plugin);


% Create the test suite with SmokeTest and Function test if they exist
Suite = testsuite("SmokeTests");
Suite = [Suite testsuite("FunctionTests")];
Suite = [Suite testsuite("SolnSmokeTests")];

% Run the test suite
Results = Runner.run(Suite);


if installedAddOn
    rmpath("Arduino_Additional_Sensors_Simulink_Library_DHT_LPS331");
    rmpath(fullfile("Arduino_Additional_Sensors_Simulink_Library_DHT_LPS331","drivers","DHT"));
    rmpath(fullfile("Arduino_Additional_Sensors_Simulink_Library_DHT_LPS331","drivers","LPS331"));
    rmdir("Arduino_Additional_Sensors_Simulink_Library_DHT_LPS331",'s')
    disp("DHT drivers uninstalled.")
end

if ShowReport
    web(fullfile(Folder,"index.html"))
end

% Format the results in a table and save them
ResultsTable = table(Results')
writetable(ResultsTable,fullfile(currentProject().RootFolder,...
    "public","TestResults_"+version("-release")+".txt"));

% Assert success of test
assertSuccess(Results);

end
