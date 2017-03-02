function [  ] = update_RM_max(  max_v, slide_name,result_dir )
%UPDATE_RM_MAX Summary of this function goes here
%   Detailed explanation goes here


    filename_max_mat = fullfile(result_dir,'max.mat');
        
    if exist(filename_max_mat, 'file') == 2
        load(filename_max_mat,'max_map');
    else 
        max_map = containers.Map();
    end        
          
    max_map(slide_name)=max_v;
    save(filename_max_mat,'max_map','-v7.3');
    clear max_map;

end 