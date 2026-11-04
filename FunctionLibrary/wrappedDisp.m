function wrappedDisp(str)
arguments
    str (1,1) string
end
    
    % Get size of the command window
    cws = get(0, 'CommandWindowSize');
    dwidth = cws(1);

    str = strsplit(str);
    
    while ~isempty(str)
        length = cumsum(strlength(str)+1);
        idx = length < dwidth;
        disp(join(str(idx)))
        str(idx) = [];
    end

end

%[appendix]{"version":"1.0"}
%---
