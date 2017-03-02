clear;
run('../../SetupCamelyon')
LoadDefaults;

for slide_index=all_slide_indexes_normal
    try
    name = get_slide_name(slide_index,false);
    generate_negative_patches(name,slide_index);
    catch ME 
        fprintf('Exception for slide no:%d',slide_index);
        msgString = getReport(ME)
    end
end
