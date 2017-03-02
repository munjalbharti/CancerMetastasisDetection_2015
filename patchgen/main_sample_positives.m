clear;
run('../../SetupCamelyon')
LoadDefaults;

for slide_index=all_slide_indexes_tumor
    try
        name = get_slide_name(slide_index,true);
        
        generate_positive_patches(name,slide_index);
        %generate_boundary_negative_patches(name,slide_index);
       
     catch ME

        fprintf('Exception for slide index:%d',slide_index);
	    msgString = getReport(ME)
    end
end
