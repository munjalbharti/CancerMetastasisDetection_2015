function [ mask ] = ReadMask(slide_name,level)
%ReadMask Returns the mask image at the required level

    mask_dir=get_mask_dir();

    full_path = fullfile(mask_dir,sprintf('%s_Mask.tif',slide_name));
    mask = imread(full_path,level);
end

