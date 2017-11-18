%usage example
 model = hgsModel('hgsModel\abdul\abdul.grok');
 [olfH, t, depth] = model.ReadHeadOlf(1); % read output number 1;
 
 % plot the olf Head and depth
 subplot(1,2,1);
 model.surfolf(olfH); shading interp; view(30,45); axis equal
 subplot(1,2,2);
 model.surfolf(depth); shading interp; view(0,90); axis equal
 
 
 % Read porous media head
 
 [pmH, t] = model.ReadHeadPm(8);
  model.WriteVtkPm(pmH,'head_pm'); % hgsModel\abdul\abdul0008.head_pm.vtk processed
  
  olfH = model.ReadHeadOlf(9);
  model.WriteVtkOlf(olfH, 'head_olf'); %hgsModel\abdul\abdul0009.head_olf.vtk processed
  
 