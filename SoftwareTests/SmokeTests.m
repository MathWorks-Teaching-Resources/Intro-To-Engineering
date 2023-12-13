classdef SmokeTests < matlab.unittest.TestCase
    
    properties (ClassSetupParameter)
        Project = {''};
    end

    properties (TestParameter)
        Scripts;
    end

    methods (TestParameterDefinition,Static)

        function Scripts = GetScriptName(Project)
            RootFolder = currentProject().RootFolder;
            Scripts = dir(fullfile(RootFolder,"Scripts","*.mlx"));
            Scripts = {Scripts.name};
        end

    end

    methods (TestClassSetup)

        function SetUpSmokeTest(testCase,Project)
            try
               currentProject;  
            catch ME
                warning("Project is not loaded.")
            end
        end

    end

    methods(Test)

        function SmokeRun(testCase,Scripts)
            Filename = string(Scripts);
            switch (Filename)
                case "ScriptsNeedingSpecialTesting.mlx"

                otherwise
                    SimpleSmokeTest(testCase,Filename)
            end
        end
            
    end

    methods (Access = private)

        function SimpleSmokeTest(testCase,Filename)
            RootFolder = currentProject().RootFolder;
            cd(RootFolder)
            disp(">> Running " + Filename);
            try
                run(fullfile("Scripts",Filename));
            catch ME
                testCase.verifyTrue(false,ME.message);
            end
            
            
            Figures = findall(groot,'Type','figure');
            Figures = flipud(Figures);
            if length(Figures) ~= 0
                log(testCase,1,"Logging all figures in Diagnostic:")
                for f = 1:size(Figures,1)
                    FigDiag = matlab.unittest.diagnostics.FigureDiagnostic(Figures(f));
                    log(testCase,1,FigDiag);
                end
            end
            close all

        end

    end

    methods (TestClassTeardown)

        function closeAllFigure(testCase)
            close all force  % Close figure windows
            bdclose all      % Close Simulink models
        end

    end

end