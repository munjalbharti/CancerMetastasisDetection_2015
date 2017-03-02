function [ slide ] = ReadMask2(slide_name)
%ReadMask2 Returns the slide object for the mask

    mask_dir=get_mask_dir();

    full_path = fullfile(mask_dir,sprintf('%s_Mask.tif',slide_name));
    slide = OpenSlide(full_path);

end

