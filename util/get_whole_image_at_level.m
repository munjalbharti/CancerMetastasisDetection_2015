function [ I ] = get_whole_image_at_level( slide, level )
   %RETURNS the image for a slide at a given level

    ws_img_size = slide.PixelSize(level,:);
    no_of_cols=ws_img_size(1);
    no_of_rows=ws_img_size(2);
    I = slide.getImagePixelData(0, 0,  no_of_cols, no_of_rows,'level',level-1);
end

