function [ slide_path ] = get_slide_path( slide_index,isTumor)
%GET_SLIDE_PATH - Returns path to the target slide.

if(nargin == 1)   
    testing_dir=get_testing_dir();
    slide_name=get_slide_name(slide_index);
    file_name=sprintf('%s.tif',slide_name);
    slide_path = fullfile(testing_dir,file_name);
    return 
else 
    training_dir=get_training_dir();

    if(isTumor)
         tumor_slide_list=get_tumor_slide_list();
         slide_name = tumor_slide_list.Var1{slide_index};
         folder_name = 'Train_Tumor';
    else
        normal_slide_list=get_normal_slide_list();
        slide_name = normal_slide_list.Var1{slide_index};
        folder_name = 'Train_Normal';
    end
    file_name = sprintf('%s.tif',slide_name);

    slide_path = fullfile(training_dir,folder_name,file_name);

end 

end

