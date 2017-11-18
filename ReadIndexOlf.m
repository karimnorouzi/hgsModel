function [index,n]=ReadIndexOlf(filename)
%filename = 'smodel_0o.coordinates_olf';

fid = fopen(filename,'rb');


if fid < 0
    msg = strcat('Could not open file: ',filename);
    error(msg);
end



pad=fread(fid, 4, 'uchar') ;% first header
 n =fread(fid, 1, 'int32');
pad=fread(fid, 4, 'uchar');

pad=fread(fid, 4, 'uchar');
m=fread(fid, 1, 'int32');
pad=fread(fid, 4, 'uchar');

pad=fread(fid, 4, 'uchar');
index = fread(fid, n, 'int32');
pad=fread(fid, 4, 'uchar');


fclose(fid);