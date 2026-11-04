%[text] # Test if Arduino is connected to computer
%[text] 
%[text] return status
%[text] - true - an Arduino board is connected and ready to use
%[text] - false - no Arduino board ready to use is detected.
%[text] - 0 - Arduino is not detected
%[text] - 1 - Arduino is detected and ready to connect
%[text] - 2 - Arduino is detected but connection already exist
%[text] - 3 - Other unidentified status \
%[text] 
function y = ArduinoStatus(opts)
arguments
    opts.Verbose (1,1) logical = false;
end

    try
        objArduino = arduino;
        if opts.Verbose
            disp(string(objArduino.Board)+" board has been detected on "+...
                string(objArduino.Port))
        end
        clear objArduino
        y = true;
    catch ErrorMessage
        
        y = false;
        switch string(ErrorMessage.identifier)
            case "MATLAB:hwsdk:general:connectionExists"
                warning("The connection to your arduino is already established, "+...
                    "close the arduino explorer app if open or clear your workspace.")
            case "MATLAB:hwsdk:general:boardNotDetected"
                y = false;
                warning("There is no arduino board connected to this computer.")
            otherwise
                y = false;
        end

        if opts.Verbose
            warning(ErrorMessage.message)
        end
    end

end

%[appendix]{"version":"1.0"}
%---
