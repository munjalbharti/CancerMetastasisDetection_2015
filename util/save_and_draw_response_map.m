function [  ] = save_and_draw_response_map( RM,slide,name,level,target_dir,is_Tumor )
%SAVE_AND_DRAW_RESPONSE_MAP  Saves and draw the response map 

    if not (exist(target_dir,'dir') ==7)
     mkdir(target_dir);
    end
    
    filename=sprintf('%s.mat',name);
    save(fullfile(target_dir,filename),'RM');

    fprintf('\ndrawing figure for slide %s',name);
    if(nargin == 5)
      response_map_f = draw_figire_for_response_map(slide, name, RM , level); 
    else 
      response_map_f = draw_figire_for_response_map(slide, name, RM , level, is_Tumor);     
    end 
    rsp_file=sprintf('Figure_%s.png',name);    
    rsp_file_name = fullfile(target_dir,rsp_file);
    saveas(response_map_f,rsp_file_name);
    
    close(response_map_f);
    

end

