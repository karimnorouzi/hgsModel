function [data]= ReadWaterBalance( filename )
% [t,precip,infilt , exfilt ,et]= ReadWaterBalance( filename )
%
data = importdata(filename,' ',3);
data = data.data';
return ;

