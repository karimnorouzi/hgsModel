function [coord,n] = ReadCoordinates(filename)
%filename = 'smodel_0o.coordinates_pm';

fid = fopen(filename,'rb');


if fid < 0
    msg = strcat('Could not open file: ',filename);
    error(msg);
end


pad=fread(fid, 4, 'uchar'); % first header
n=fread(fid, 1, 'int32');  % number of nodes.
pad=fread(fid, 4, 'uchar') ;% first header
m = fread(fid, 1, 'int32');  % number of nodes.
coord = fread(fid,n*3,'real*8');
coord = reshape(coord,3,n)';
% we dont care what is after this thing....
pad = fread(fid,4,'uchar'); % ending real*8
fclose(fid);