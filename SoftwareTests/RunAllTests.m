function RunAllTest(Folder)
arguments
    Folder (1,1) string = "public"
end

if isfolder(Folder)
    mkdir(Folder)
end

% Create the test suite with SmokeTest and Function test if they exist
Suite = testsuite("SmokeTests");
Suite = [Suite;testsuite("FunctionTests")];

% Create a runner
Runner = matlab.unittest.TestRunner.withTextOutput;

% Add plugin to generate report
import matlab.unittest.plugins.TestReportPlugin
Plugin = TestReportPlugin.producingHTML(Folder,...
    "IncludingPassingDiagnostics",true,...
    "IncludingCommandWindowText",true,...
    "LoggingLevel",matlab.automation.Verbosity(1));
Runner.addPlugin(Plugin);

% Run the test suite
Results = Runner.run(Suite);

% Format the results in a table and save them
ResultsTable = table(Results')
writetable(ResultsTable,fullfile("SoftwareTests","TestResults_"+release_version+".txt"));

% Assert success of test
assertSuccess(Results);
end
