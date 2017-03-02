function [ x_stained,y_stained ] = get_stained_region_interpolated( slide, level)
 %RETURNS stained points of slide at a given level by interpolating stained points from a lower level     
        lower_level=7 ;
        ws_img_size_lower = slide.PixelSize(lower_level,:);
        rows_lower=ws_img_size_lower(2);
        cols_lower=ws_img_size_lower(1);

        I_lower = slide.getImagePixelData(0, 0, cols_lower, rows_lower,'level',lower_level-1);
        l = graythresh(I_lower);
        stain_mask_lower_level = im2bw(I_lower,l);

        %Reversing the image..1 replaced by 0..0 replaced by 1 to find connected components
        stain_mask_rev=~stain_mask_lower_level;
        stain_mask_conn= get_connected_components(stain_mask_rev);

        [sy,sx] = find(stain_mask_conn==1);
               
        [x,y] = interpolateCoordinatesByLevel(sx,sy,lower_level,level);
        x_stained=x;
        y_stained=y;
         
        % pixels_per_point = 4^(lower_level - level);
        %[x_stained,y_stained]=get_upper_pixels(x,y, pixels_per_point);
      


end



