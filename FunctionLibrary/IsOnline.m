%[text] # Test if script is running on MATLAB Online
%[text] 
%[text] This function test if the script is running on MATLAB Online or on Desktop. 
%[text] It returns **`true`** if the script is running on MATLAB Online, false otherwise.
%[text] 
%[text:table]{"ignoreHeader":true}
%[text] | ![](text:image:5983) | The function itself is based on the MATLAB and MATLAB Drive install root. On MATLAB Online, the MATLAB root install is **`"/MATLAB"`** and the MATLAB Drive install root is **`"/MATLAB Drive"`**. In the unlikely situation where the users uses the same install root for MATLAB and MATLAB Drive than MATLAB Online, this function will wrongfully return that **`true`** |
%[text] | --- | --- |
%[text:table]
%[text] 
function y = IsOnline()

    MLroot = string(matlabroot); % MATLAB install root, should be '/MATLAB' on MATLAB Online
    try
        MLDroot = string(matlabdrive); % MATLAB Drive install root
    catch
        % Error is thrown if MATLAB Connector  is not installed
        MLDroot = "";
    end
    
    if MLroot == "/MATLAB" && MLDroot == "/MATLAB Drive" 
        y = true;
    else
        y = false;
    end
end

%[appendix]{"version":"1.0"}
%---
%[text:image:5983]
%   data: {"align":"baseline","height":67,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAP8AAADjCAYAAABKHMIqAAALDklEQVR42u3dz28cZxkH8B57zA0fOPhoCaVsUsd2+SH5RoVysFQOCA6YG6oUyYcIqZeIY6RQ20lD05a4skCqUnqoRVsJpCBFFKk5IadCkOC2OIU0gZLKKIUkRHSYNx4TJ9jOer27nnmfz0rPP+DxZ2fn\/T7zPI8URfGIyrtu\/Ozze8qaLGu+rHNlFan+Nj9UXJ3bW1w9\/djfr738hXfLOv3x\/NBX\/c1ilD9C3ujHK\/DFRpXg\/\/nF1v\/VlZe++En6Iijrc\/6O8KtmoR8sa2Ez9A\/Dv1Z\/eal186PTj538\/dEvP+rvCr+qP\/ypslYeBr8d\/P\/7EnixdaX8Evi6vy\/8qr7P9QvtoN8u\/rv1QutW+Thw1N8aflU\/+Ivbgb9t\/PfOA854DIBfNRh+p\/hTffjCvnd8AcCvGgp\/J\/hTXX5+\/5u+AOBXu4e\/Y\/g7xX\/3F8CpfSdcB\/hV\/+HP7wR+N\/CnQ8APnht+2vWAX\/UP\/sRO4XcF\/+rz\/8p7syMHXBf4VX8aeFbqgj\/V8o\/2\/6Z8\/t\/j+sCveot\/oRvwu4k\/1fsnhvUAwK\/q\/nO\/F\/jTz\/\/y7j\/mOsGveoN\/ua74U\/3p5ONn\/fyHX3Uf\/g+6Cb8X+NPp\/6Ufjn3b9YJf1fCQr6f4Vw\/\/Fsu7\/6DrBr+qSabfL\/wO\/+BX3R3IUTQJ\/+Xn9y+Xd\/+W6we\/2sUW3t3AX939X9P7D7\/qHP5kr+D3Gn+K\/i49O3rQdYRfdfbG3kpT8af64LnHz4n+4Ffbxz\/bS\/j9wJ+iv6WZkUOuJ\/yqffitXsPvC\/7V6O+i6A9+1T7+c7ngv3v4d\/zAtOsKv+pz\/34d8H94at81ff\/wq4cf8i3nhl\/0B7\/ahf79uuCv+v6fcp3hV33q368NftEf\/Kr3Qzrqij\/V0vToYdcbftWH\/v264a\/6\/kV\/8Kte9+\/XDX+q92ZHTrru8IO\/uliziIS\/Gvk17vrDr38\/GP7q8O8N0R\/8+vcD4jfyC379+1Hxrw78PF\/e\/Qf8P8Cvfz8Y\/urw74j\/B\/j17wfEX0V\/Q\/4v4Ne\/Hwx\/9dbfnMM\/+PXvB8Qv+oM\/Sv9+Ab9tP\/Dr34df9Ae\/\/v3g+G37gT9j\/Mvw2\/YDv\/59+G37gV\/\/PvxGfsGfK\/75OsKvM37bfuDXvx8Uv5Ff8OvfD4zfth\/4mwx\/ss7wa4\/fth\/49e\/HxW\/bD\/z69wPjt+0Hfv37QfGL\/uDXvx8Yv20\/8Ovfj4pf9Ae\/\/v24+G37gd8hX2D8tv3Ar38\/KH7bfuDXvx8YfzXyS\/QHv0O+aPht+4Ff\/35g\/EZ+wa9\/Pyp+237gd8gXF79tP\/CL9gLjt+0Hfv37QfGvbfvxPwm\/Q76A+G37gV+0FxS\/bT\/w698PjF\/0B79Dvqj4bfuBX7QXF79tP\/Dr3w+M37Yf+MPN34ffyC\/4RXvh8dv2A7\/+\/aD4jfyCP9T8ffht+4FftAe\/bT\/wd6l\/fwX+Rvf92\/YDv2gvIv5q24\/oD\/6Y\/fuR8Yv+4O8E\/yL8rZz6\/m37gT92tBcSv+gP\/qj9+\/Db9gO\/aC80ftEf\/NmP5oLfth\/4t49\/Af68y7Yf+MNGe9Hx2\/YDf9hoD37RH\/z3w5+KCD8sftt+4I8Y7cEv+oP\/Hv7ZqPCj47ftJzD+iNEe\/KI\/+DMezZWqF5+Mo79x+EV78AfDv27bz6Pw27oDfzD8kbf9iPbgj43\/3rafAfhFe\/AHw18d\/h2BX7QHf0D8Ebf92LoDP\/z3Bn7ORTr8E+3BD3\/Q6C8K\/IlIzTvw7zj62wO\/aA\/+YPgjRX9Gc8EP\/8bR3yD8oj34g+Gv5v0fhd\/WHfgD4o8Q\/Yn24Id\/05Ffw6\/kHP2J9uCHf4vo79KzowfhF+3BH\/Lun++2n1wP+Zbhh79b0d\/SzMgh+EV78AesXKO\/HEdzrcAPfw\/6\/qfhF+3BH3fgZwt+o7ngj3j3PzH8Wk7Rn2gPfvi30\/efUfSXC\/xJ6OEX\/QXDL9qDv+\/bfjKJ\/kR78MO\/\/ejvYg7Rn2gPfviDbvtpOv4F2OHflb7\/U\/uulXf\/MfhFe\/CL\/uDvI\/5F0OGvwcivp+AX7cEv+oPfaC74Q0V\/06OH4RftwR+3738Q\/t5He4DDL\/oLiF+0B79tP9Hwi\/bgb8Dh3xtNiv5s3YEf\/qDbfpoCfwpq+Buy6+98efcfgF+0B7\/oD\/4d4J8FGv4GRn9D8Iv24I858HMOfqO54Bf9wb9N+BMgw9\/ww7+zde77F+3BD3\/Q6E\/\/PvzwB932I9qDH\/7e9\/0fgd\/WHfht+4F\/E\/gteOHPs+9\/+JW69f2L9uCHv0\/RX922\/RjNBT\/8QUd+2boDP\/x9jP7qtO1HtAc\/\/EG3\/di6Az\/8\/e\/7n4ZftAd\/3G0\/rdD4jeaC37afuPht3YHftp9o+EV78Iv+djf6078PP\/xBR36J9uCHP+i2H6O5Mqybv\/pWW3X9598pPn79u20VqPlt+7F1J3BdndsLX31Gfo1ljV+0B7+qz7Yfo7ngV0FHftm6A78Kuu1HtAe\/Cjryy9Yd+FXQbT+iPfhV0G0\/RnPBr4Ju+7F1B34VdNuPaC9Iffr63uL2O98v7iydKf5z9e37WndvX367+OfvXi0+OftMceXlL8EXJPrTvx8B\/YXp4rPbK2318H92a6X4x\/lZXwIBtv2I9jLv8W8X\/YOfOyvLevrrMfTjaNPwG821y5V+4nfjkx4FIMxz24+tO+D7Agi67Ue0l1n965cHO\/6pv9U5wLVXvwFiZtt+jObKrB48ye\/WJyUCIOY18svWHT\/32\/5cf+sQiBlt+xHtueu3\/bn5x7cgzGjbj607GeX5\/fjI\/\/PZ9iPay6Ru\/fp7fcEv+89n24\/RXLk871+Y7gv+1P0HYR7bfmzdgR\/+oNt+RHvwwx80+tO\/Dz\/8Qbf9iPYc+Mn6g0Z\/RnPlEvW9+ZW+4P\/op18DL5NtP7bu5NTkc\/3dnsL\/918vAJfRth\/RnvZeb\/cF3fZjNFdud\/8byz2Bn4Z7gJbXyC9bdzKc3qOzz7afruIX7cWN\/cR7eUZ\/tu5kWmlKbzc+aaovWHlu+xHtZX4A2OlUnzS9xwFf3tt+jOYKkP9v9z3\/NLVHnp\/\/th9bdwJ9Cdz5w4837QVIGf6N385BH2jbj2jPui4VNPrTvw+\/CrrtR7QHv8q37\/9Ip\/iN5oJfZbztx9Yd+FXQbT+iPfhV0G0\/RnPBr4KO\/BLtwa+CRn\/u+vCrONHfwFb43fXhV0Hu\/tp44VdBn\/3N5YNfxXrp58n78FfdfEDAr7Lv+jvwkwfxO+iDX8U5+Btaj99PfvhVkIO\/Ev\/Eevxe4IFfRZn1NzNy7C5+ffzwq2Cn\/ieGf5FO\/T3vw69ijvkeMrADfhXzVd9xI7nhVzHxP+n1XfhVwCrxT8IPv4Jfwa+i4ffMD7+K98z\/Taf98KvAp\/1e5YVfxXu1t2UJJ\/wq3jz\/M2mqz1pv\/yIM8KsYdfHYE8+sf7FnCgb4VYhXei+uDfSwmgt+Fekn\/8zI\/NooL0s54VexTvknNprht8f0XvhVxu\/xT48e33CAZ\/UFMA4F\/Crbd\/jHrOtS8Meb2zfR7qJOXwDwq4zhb4p\/3ReABAB+1eyJPRObGd8Uf\/UF0NIABL9q3oTeqotvbCvfW+Jf9yUw5VcA\/KoZffuXjj3x9INLOTvGvy4KnBIHwq\/qd6dP6JemRw+vLeRop9rGv8HjwKxHAvjV7u3dS4d5af1Weq5v507fFfwb\/CIYrzoE56vJQOc8JsCvutOVlypBT3f3948fmFuaGTmU3sfvBHxX8avmVvrnKWtQNaIGun39\/wvLIuAruVaaBgAAAABJRU5ErkJggg==","width":75}
%---
