function [p] = pad(j)
if j < 10 % indicate the number of output files. 
            p = '000';
elseif j < 100
    p = '00';
elseif j < 1000
    p = '0';
else
    p = '';
end
return