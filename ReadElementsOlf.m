function [tri] = ReadElementsOlf(filename)
%filename = 'smodel_0o.elements_olf';
fid = fopen(filename,'rb');

if fid < 0
    msg = strcat('Could not open file: ',filename);
    error(msg);
end

pad=fread(fid, 16, 'uchar'); % first header
n=fread(fid, 1, 'int32');  % number of nodes.
pad=fread(fid, 4, 'uchar') ;% first header
m=fread(fid, 1, 'int32'); 
% number of nodes.
tri = fread(fid,n*4,'int32');
tri = reshape(tri,4,n);
tri = tri';
tri = tri(:,[1 2 3]);

% we dont care what is after this thing....
pad = fread(fid,4,'uchar') ;% ending real*8

fclose(fid);