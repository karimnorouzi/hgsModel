function [elements] = ReadElementsPM(filename)
%filename = '/home/blue/abdul-cp/abdulo.elements_pm';
fid = fopen(filename,'rb');

if fid < 0
    msg = strcat('Could not open file: ',filename);
    error();
end

pad=fread(fid, 16, 'uchar'); % first header
n=fread(fid, 1, 'int32');  % number of nodes.
pad=fread(fid, 4, 'uchar') ;% first header
m=fread(fid, 1, 'int32'); 
% number of nodes.
elements = fread(fid,n*6,'int32');
elements = reshape(elements,6,n);
elements = elements';
%elements= tri(:,[1 2 3]);

% we dont care what is after this thing....
pad = fread(fid,4,'uchar') ;% ending real*8

fclose(fid);

% e = elements;
% 
% hold on;
% x=xyz(:,1);y =xyz(:,2); z = xyz(:,3);
% for ee =1:10000
%     i=e(ee,1); j=e(ee,2); k=e(ee,3); l=e(ee,4); m=e(ee,5); n=e(ee,6);
%     %e(ee,:)
%     plot3([x(i) x(j)],[y(i) y(j)],[z(i) z(j)]); hold on;
%     plot3([x(j) x(k)],[y(j) y(k)],[z(j) z(k)]); hold on;
%     plot3([x(k) x(i)],[y(k) y(i)],[z(k) z(i)]); hold on;
%     plot3([x(i) x(l)],[y(i) y(l)],[z(i) z(l)]); hold on;
%     plot3([x(j) x(m)],[y(j) y(m)],[z(j) z(m)]); hold on;
%     plot3([x(k) x(n)],[y(k) y(n)],[z(k) z(n)]); hold on;
%     plot3([x(l) x(m)],[y(l) y(m)],[z(l) z(m)]); hold on;
%     plot3([x(m) x(n)],[y(m) y(n)],[z(m) z(n)]); hold on;
%     plot3([x(n) x(l)],[y(n) y(l)],[z(n) z(l)]); hold on;
%     if mod(ee,100) == 0
%         disp(['processed elements: ', num2str(ee)]);
%     end
% end
% 
%     
%     