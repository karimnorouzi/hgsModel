function [t,q]  =  ReadHydrograph(filename)
%% [t ,q ] = ReadHydrograph(filename)
%
% file = fopen(filename);
% if file < 0 
%     error(strcat('could not open file: ', filename))
% end

%data = textscan(file,'%f %f %f %f \n','HeaderLines',3);
data = importdata(filename,' ' , 3);

%data = cell2mat(data);
t = data.data(:,1);  % time
q = data.data(:,2);  % surface flow 

% fclose(file); 
%filename = 'F:\model_2_const17\smodel_10o.hydrograph.hydrographout.dat';
return 
