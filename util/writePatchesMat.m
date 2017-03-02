function [  ] = writePatchesMat( slide_patches,path_prefix,slide_name,isPositive )
% Save all patches of a slide in a mat file

  patch_class = 'Negative';   
  if( isPositive)
    patch_class = 'Positive';
  end

  target_folder = [path_prefix filesep patch_class];
  if not (exist(target_folder,'dir') ==7)
     mkdir(target_folder);
  end

  mat_name=sprintf('%s.mat',slide_name);
  target_file= [target_folder filesep mat_name];
 
  Patches=slide_patches;
  save(target_file, 'Patches', '-v7.3');

end

