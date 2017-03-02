function [ ] = combine_response_maps_for_levels( )
%This function is used to combine response maps from different levels 


LoadDefaults;
level_upper=4;
level_lower=7 ;

result_dir='F:\Camelyon\Results\Level_7_adaptive_adagradMod_Level_4_adagrad_Combined\ScaleUp\' ;
level_upper_dir='F:\Camelyon\Results\Level_4_Response_Maps_AdaGrad_parallel\';
level_lower_dir='F:\Camelyon\Results\Level_7_Adagrad_AdaptiveMod_Combined\';


 if not (exist(result_dir,'dir') ==7)
     mkdir(result_dir);
 end
  
 

response_map_dir_1=fullfile(level_upper_dir);
response_map_dir_2=fullfile(level_lower_dir);
        
%response_maps_list_1 = dir(fullfile(response_map_dir_1,'Response_map_*.mat'));

    
for k=1:2
    if(k==1)
        is_tumor=true;
         indexes = setdiff(test_slide_indexes_tumor,0:0);
    else
        is_tumor=false;
        indexes = setdiff(test_slide_indexes_normal,0:0);
    end
    
    for i=indexes
 %      
        slide_name= get_slide_name(i,is_tumor);
        res_file_name=sprintf('%s.mat',slide_name);
                                        
        %Load first response map 
        load(fullfile(response_map_dir_1,res_file_name),'RM');             
        response_map_1=full(S);
             
        clear S ;
        
        %scale_down=2^(level_upper -level_lower );
        %response_map_1_scaled_lower=imresize(response_map_1,scale_down);
              
               
             
        %Same file should exits in other response map folder
        response_map_2_file=fullfile(response_map_dir_2,res_file_name);
               
        if exist(response_map_2_file, 'file') ~= 2
            fprintf('Response map %s does exist in directory %s',res_file_name,response_map_dir_2);
            continue ;
        end 
               
      %Load second response map
      load(response_map_2_file),'RM';    
      response_map_2=full(RM);
      clear RM ;
      scale_up=2^(level_lower-level_upper );
            
      response_map_2_scaled_up=imresize(response_map_2,scale_up);
           
               
      response_maps_arr=[];
      response_maps_arr(:,:,1)=response_map_1; 
      response_maps_arr(:,:,2)=response_map_2_scaled_up; 
               
      %Calculate geometric mean of two response maps
      RM = calculate_GM_for_response_maps(response_maps_arr);
                         
      response_map_f=figure ;
               
      subplot(1,4,1);
      imshow(response_map_1);
      title(sprintf('Level %d',level_upper));
             
      subplot(1,4,2);
      imshow(response_map_2);
      title(sprintf('Level %d',level_lower));
               
             
      subplot(1,4,3);
      imshow(RM);
      title('Combined');
               
               
      if(is_tumor == true)        
            tumor_mask = ReadMask(slide_name,level_lower);   
      else
            tumor_mask = zeros(size(response_map_2)); 
      end 
                   
       subplot(1,4,4);
       imshow(tumor_mask);
       title(sprintf('Mask %s',slide_name));
               
        
       filename_mat = fullfile(result_dir,sprintf('%s.mat',slide_name));
             
       save(filename_mat,'RM', '-v7.3');
           
               
       filename_png = fullfile(result_dir,sprintf('%s.png',slide_name));
       saveas(response_map_f,filename_png);  
               
       max_v=max(max(RM)); 
       update_RM_max(max_v, slide_name,result_dir)
               
               
       close(response_map_f);
               
    end 
     
end 
end 
