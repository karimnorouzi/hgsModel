function [elements] = Readechosgridbuilder(filename)

%filename = 'grid.echos.overland_flow';

fid = fopen(filename,'rb');

if fid < 0
    error('Could not open file: ',filename);
end

pad=fread(fid, 1, 'int32'); % first header
title=fread(fid, 80, 'uchar');
title = char(title');
pad=fread(fid, 1, 'int32'); 

n = fread(fid,1,'int32'); % starting real*8 ; numer of bytes to come.
elements = fread(fid,n/4,'int32');
n = fread(fid,1,'int32'); % ending real*8
%disp(['size of file is ', ftell(fid)]);
fclose(fid);
% 10700 - 4 - 80 - 4 -4 -4