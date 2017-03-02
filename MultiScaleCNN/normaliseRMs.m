function [  ] = normaliseRMs()

%maximum of all slides

    LoadDefaults;
    RMs_dir='';
    result_dir=fullfile(RMs_dir,'Normalised');

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

    end 

    max_v=get_max_v(RMs_dir);

     for index=indexes
           slide_name=get_slide_name(index,is_tumor);
           load(sprintf('%s.mat',slide_name),'RM');
           RM = RM ./max_v;
            
           filename_mat = fullfile(result_dir,sprintf('%s_Nor.mat',slide_name));
           save(filename_mat,'RM', '-v7.3');  
       end 

end 



function [ max_v ] = get_max_v(dir)

     filename_max_mat = fullfile(dir,'max.mat');
     load(filename_max_mat,'max_values');
     max_v=max(max_values(:,2));
end 
