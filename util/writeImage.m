function [ ] = writeImage( path_prefix,isPositive,slide_name,I,center_x,center_y)
%WRITEIMAGE Save image to disk

    patch_class = 'Negative';
    if( isPositive)
        patch_class = 'Positive';
    end
    target_folder = [path_prefix filesep patch_class filesep slide_name];
    if not (exist(target_folder,'dir') ==7)
        mkdir(target_folder);
    end
    image_name = sprintf('%s_%s_%06d_%6d.tiff',patch_class(1:3),slide_name,center_x,center_y);
    imwrite(I,[target_folder filesep image_name]);

end

