function [elements] = writechosgridbuilder(filename,elements)
%filename = 'grid.echos.overland_flow';
fid = fopen(filename,'wb');
if fid < 0
    error('Could not open file: ',filename);
end

headerSize = 80;
fwrite(fid, int32(headerSize),'integer*4'); % first header
title= char(69*ones(80,1));
fwrite(fid, title);
fwrite(fid, int32(headerSize),'integer*4');
n = length(elements);
fwrite(fid, int32(n*4),'integer*4'); % starting real*8
elements(elements ~= 0) = -1;
fwrite(fid, int32(elements),'integer*4');
fwrite(fid,int64(n*4),'integer*4'); % ending real*8
%elements = -elements; % -1 is .TRUE. in fortran.
fclose(fid);
