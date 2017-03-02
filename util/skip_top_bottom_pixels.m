function [points_x,points_y]=skip_top_bottom_pixels(points_x,points_y,ws_img_size)
%Removes a fixed top and bootom pixels from given pixels 
    height = ws_img_size(2);
    width = ws_img_size(1);
        
    pixels_skipped_from_top=ceil(0.09*height);
    pixels_skipped_from_bottom=pixels_skipped_from_top+100;
    pixels_skipped_from_side=ceil(0.052*width);

    
    less_x_idx = find(points_x < pixels_skipped_from_side);
    less_y_idx = find((points_y < pixels_skipped_from_top) |(points_y > (height-pixels_skipped_from_bottom)) );
    invalid_idx = union(less_x_idx,less_y_idx);
    points_y(invalid_idx) =[];
    points_x(invalid_idx) =[];
end 