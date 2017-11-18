classdef hgsModel < handle

   properties 
       verbos = 0
       RootDir
       BaseName
       tri  % surface triangulation numbering
       x    % surface nodes x
       y 
       z 
       H    % Water Head
       h    % water depth
       Z    
       n % number of nodes
       m % number of Triangles.
       t % current time.
       Hpm % Porous Medium Head
       i
       xyz  % xyz of the porous media
       prisim
       PmSat 
   end
   methods
       function obj =  hgsModel(Grok_File)
           % make an instance of the model
           %
           [filepath, name , ext] = fileparts(Grok_File);
           obj.RootDir = strcat(filepath, filesep);
           obj.BaseName = name;
           if ext ~= '.grok'
               error('Please provide a grok file name');
           end
           prefix = strcat(obj.RootDir,obj.BaseName);
           filename = strcat(prefix,'o.coordinates_pm');
           %disp(['processing ',filename]);
           obj.xyz = ReadCoordinates(filename);
           filename = strcat(prefix,'o.coordinates_olf');
           [index,obj.n]=ReadIndexOlf(filename); % index in to coordines , number of nodes.
           filename = strcat(prefix,'o.elements_olf');
           obj.tri = ReadElementsOlf(filename);
           filename = strcat(prefix,'o.elements_pm');
           obj.prisim = ReadElementsPM(filename);
           
           %%%%%%%%%%%%%%%%%%%%%%%%%%%
           id=1:length(obj.xyz);
           id(index) = 1:length(index);  % map the indexes to id.
           obj.tri = id(obj.tri);
           obj.x = obj.xyz(index,1);  % get the surface coordinates
           obj.y = obj.xyz(index,2);  % get the surface coordinates
           obj.z = obj.xyz(index,3);  % get the surface coordinates
           obj.t = 0;
           
       end
       function [saturation,t] =  ReadPmSat(obj,i)
           filename = strcat(obj.RootDir,obj.BaseName,'o.sat_pm.',pad(i),num2str(i));
           if exist(filename,'file')  % if header file exists
            % if file does not exist, quit quitly.
                if obj.verbos
                    disp(['Reading: ',filename]);
                end
           [saturation,t] = ReadPmVariable(filename,length(obj.xyz));
           obj.i = i;
           else
               disp(['File does not exist:',filename]);
           end
           if length(saturation) ~= length(obj.xyz)
               error('Reading failed, wrong number of reads');
           end
           return
       end
       function [Head_olf,t, depth] =  ReadHeadOlf(obj,i)
           filename = strcat(obj.RootDir,obj.BaseName,'o.head_olf.',pad(i),num2str(i));
           if exist(filename,'file')  % if header file exists
            % if file does not exist, quit quitly.
                if obj.verbos
                    disp(['Reading: ',OlfHead]);
                end
            [Head_olf, t] = ReadHeadOlf(filename,obj.n);
            depth = Head_olf -obj.z;
            obj.i = i;
           else
               msg = strcat('file does not exist:',filename);
               error(msg);
           end
           
       end
       function [Head_pm, t] =  ReadHeadPm(obj,i)
           PmHead = strcat(obj.RootDir,obj.BaseName,'o.head_pm.',pad(i),num2str(i));
           if exist(PmHead,'file')  % if header file exists
            % if file does not exist, quit quitly.
                if obj.verbos
                    disp(['Reading: ',PmHead]);
                end
           [Head_pm, t] = ReadHeadPm(PmHead,length(obj.xyz));
            obj.i = i;
           else
               disp(['File does not exist:',PmHead]);
           end
       end
       function obj =  surfolf(obj, variable)
           trisurf( obj.tri, obj.x, obj.y, obj.z, variable, 'edgecolor','none');
           %colorbar;set(gca,'YDir','reverse'); axis equal;view(0,90)
       end
       function obj =  plotHydrograph(obj,options)
           [t,q]=ReadHydrograph(strcat(obj.RootDir,obj.BaseName,'o.hydrograph.hydrograph_nodes.dat'));
           %% customize the plot for your own needs.
%            plot(t/3600/24,q,options);
%            xlabel('Time[days]');
%            ylabel('Discharge[m^3/s]');
%            title('Hydrograph')
%            xlim([0 max(t)/3600/24]);
       end
       function   WriteVtkOlf(obj, variable, variable_name)
           triangles = obj.tri; %% turn to 0 array indexing....
           iID = triangles(:,1) - 1;
           jID = triangles(:,2) - 1;
           kID = triangles(:,3) - 1;
           OutputFile = strcat(obj.RootDir,obj.BaseName,pad(obj.i),num2str(obj.i),'.',variable_name,'.vtk');
           fid = fopen(OutputFile,'w');
           if fid < 0
               error(' could not open file for vtk output');
           end
           fprintf(fid,'# vtk DataFile Version 2.0\n'); % vtk version.
           fprintf(fid,'Export HGS to vtk by Karim Norouzi. Open Source Rocks ;-) ! \n'); % title
           fprintf(fid,'ASCII\n'); % file type is ascii.
           fprintf(fid,'DATASET POLYDATA\n'); % 
           fprintf(fid,'POINTS %d float \n',length(obj.x));
           for iInd=1:length(obj.x)
                fprintf(fid,' %f   %f   %f  \n',obj.x(iInd), obj.y(iInd), obj.z(iInd));
           end
           fprintf(fid,'POLYGONS %d   %d\n',length(obj.tri), length(obj.tri)*4 );
           for iInd=1:length(iID)
            fprintf(fid,' 3   %d   %d   %d \n',iID(iInd), jID(iInd), kID(iInd) );
           end
           fprintf(fid,'POINT_DATA %d \n',length(obj.x));
           
           fprintf(fid,'SCALARS WaterDepth float 1\nLOOKUP_TABLE default\n');
           fprintf(fid,'%f\n',variable);
           fclose(fid);
           disp([OutputFile,' processed']);
       end
       function   WriteVtkPm(obj, variable, variable_name)
           wedge = obj.prisim-1;
           OutputFile = strcat(obj.RootDir,obj.BaseName,pad(obj.i),num2str(obj.i),'.',variable_name,'.vtk');
           fid = fopen(OutputFile,'w');
           if fid < 0
               error(' could not open file for vtk output');
           end
           fprintf(fid,'# vtk DataFile Version 2.0\n'); % vtk version.
           fprintf(fid,'Export to vtk by Karim Norouzi. Open Source Rocks ;-) ! \n'); % title
           fprintf(fid,'ASCII\n'); % file type is ascii.
           fprintf(fid,'DATASET UNSTRUCTURED_GRID\n'); % 
           fprintf(fid,'POINTS %d float \n',length(obj.xyz));
           for iInd=1:length(obj.xyz)
                fprintf(fid,' %f   %f   %f  \n',obj.xyz(iInd,1), obj.xyz(iInd,2), obj.xyz(iInd,3));
           end
           fprintf(fid,'CELLS %d   %d\n',length(wedge), length(wedge)*7 );
           for iInd=1:length(obj.prisim)
            fprintf(fid,' 6   %d   %d   %d   %d   %d   %d\n',wedge(iInd,1),wedge(iInd,2),wedge(iInd,3),wedge(iInd,4),wedge(iInd,5),wedge(iInd,6) );
           end
           
           fprintf(fid,'CELL_TYPES  %d\n',length(wedge) );
           fprintf(fid,'%d\n',ones(length(wedge),1)*13);
           
           fprintf(fid,'POINT_DATA %d \n',length(obj.xyz));
           fprintf(fid,'SCALARS PMHead float 1\nLOOKUP_TABLE default\n');
           fprintf(fid,'%f\n',variable);
           fclose(fid);
           disp([OutputFile,' processed']);
      
       end
%        function   WriteVtkPmVariable(obj,variable)
%            wedge = obj.prisim-1;
%            OutputFile = strcat(obj.RootDir,obj.BaseName,pad(obj.i),num2str(obj.i),'.pm_sat','.vtk');
%            fid = fopen(OutputFile,'w');
%            if fid < 0
%                error(' could not open file for vtk output');
%            end
%            fprintf(fid,'# vtk DataFile Version 2.0\n'); % vtk version.
%            fprintf(fid,'Export to vtk by Karim Norouzi. Open Source Rocks ;-) ! \n'); % title
%            fprintf(fid,'ASCII\n'); % file type is ascii.
%            fprintf(fid,'DATASET UNSTRUCTURED_GRID\n'); % 
%            fprintf(fid,'POINTS %d float \n',length(obj.xyz));
%            for iInd=1:length(obj.xyz)
%                 fprintf(fid,' %f   %f   %f  \n',obj.xyz(iInd,1), obj.xyz(iInd,2), obj.xyz(iInd,3));
%            end
%            fprintf(fid,'CELLS %d   %d\n',length(wedge), length(wedge)*7 );
%            for iInd=1:length(obj.prisim)
%             fprintf(fid,' 6   %d   %d   %d   %d   %d   %d\n',wedge(iInd,1),wedge(iInd,2),wedge(iInd,3),wedge(iInd,4),wedge(iInd,5),wedge(iInd,6) );
%            end
%            
%            fprintf(fid,'CELL_TYPES  %d\n',length(wedge) );
%            fprintf(fid,'%d\n',ones(length(wedge),1)*13);
%            
%            fprintf(fid,'POINT_DATA %d \n',length(obj.xyz));
%            fprintf(fid,'SCALARS PMHead float 1\nLOOKUP_TABLE default\n');
%            fprintf(fid,'%f\n', variable);
%            fclose(fid);
%            disp([OutputFile,' processed']);
%        end
   end  % end methods.
end
