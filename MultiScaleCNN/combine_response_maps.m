function [ ] = combine_response_maps( )
%Combine response maps of same size from multiple directories 

clear ;
run(['..' filesep 'SetupCamelyon']);

LoadDefaults;
level_lower=7;


result_dir='F:\Camelyon\Results\Level_7_adaptive_adagradMod_Level_4_adagrad_Combined\' ;


dir_paths{1}='F:\Camelyon\Results\Level_7_Adagrad_AdaptiveMod_Combined\';
dir_paths{2}='F:\Camelyon\Results\Level_4_Response_Maps_AdaGrad_parallel\';
%dir_paths{3}= 'F:\Camelyon\Results\Level_7_Adagrad_Response_Maps_Rot_180\';
%dir_paths{4}='F:\Camelyon\Results\Level_7_Adagrad_Response_Maps_Rot_270\';
%dir_paths{5} ='F:\Camelyon\Results\Level_7_Adagrad_Response_Maps_Flip_Rot_90\';
%dir_paths{6}='F:\Camelyon\Results\Level_7_Adagrad_Response_Maps_Flip_Rot_180\';
%dir_paths{7}='F:\Camelyon\Results\Level_7_Adagrad_Response_Maps_Flip_Rot_270\';
%dir_paths{8}= 'F:\Camelyon\Results\Level_7_Adagrad_Response_Maps_Flip\';

count_dir=2;


 if not (exist(result_dir,'dir') ==7)
     mkdir(result_dir);
 end


for k=1:2
    if(k==1)
        is_tumor=true;
         indexes = setdiff(test_slide_indexes_tumor,0:0);
    else
        is_tumor=false;
        indexes = setdiff(test_slide_indexes_normal,0:0);
    end

    for i=indexes
           slide_name= get_slide_name(i,is_tumor);
           res_file_name=sprintf('%s.mat',slide_name);

           response_maps_arr=[];
           
           %load response maps from all directories
           for k=1:count_dir
               res_full_path=fullfile(dir_paths{k},res_file_name);
               if exist(res_full_path, 'file') ~= 2
                    fprintf('Response map %s does exist',res_full_path);
                    continue ;
               end
               load(res_full_path,'RM');
                
               response_map=full(RM);
               response_maps_arr(:,:,k)=response_map;
               clear RM ;

           end

           %Calculate GM of all response maps
            RM = calculate_GM_for_response_maps(response_maps_arr);

            response_map_f=figure ;
            slide=get_slide(i,is_tumor);
            I_disp=get_whole_image_at_level(slide,level_lower);

            if(is_tumor == true)
                 tumor_mask = ReadMask(slide_name,level_lower);

            else
                 tumor_mask = zeros(size(response_maps_arr,1),size(response_maps_arr,2));
            end

            subplot(1,3,1)
            imshow(I_disp);

            subplot(1,3,2);
            imshow(tumor_mask);
            title(sprintf('Mask %s',slide_name));

            subplot(1,3,3);
            imshow(RM);
            title('Combined');


            filename_mat = fullfile(result_dir,sprintf('%s.mat',slide_name));
            save(filename_mat,'RM', '-v7.3');

            max_v=max(max(RM));
            update_RM_max(max_v, slide_name,result_dir)

            filename_png = fullfile(result_dir,sprintf('%s.png',slide_name));
            saveas(response_map_f,filename_png);


            filename_fig = fullfile(result_dir,sprintf('%s.fig',slide_name));
            savefig(response_map_f,filename_fig);

            close(response_map_f);

    end
end 

end 


