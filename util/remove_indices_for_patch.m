function [ points_x,points_y ] = remove_indices_for_patch(points_x,points_y, ws_img_size, patch_size )
%Removes the indices that are not able to fit the patch size 
%Also skips pixels in the  top bottom  area of the slide                                 
        
        %% skip top bottom pixels
       
        rows=ws_img_size(2);
        cols=ws_img_size(1);
        
       [points_x,points_y] = skip_top_bottom_pixels(points_x,points_y, rows, cols);
        
       %Remove patches where patch size does not fit;
       
        half_patch_size = floor(patch_size/2);
        
        min_x_region = 1+half_patch_size;
        min_y_region = 1+half_patch_size;
                
        max_x_region = cols - half_patch_size -1;
        max_y_region = rows - half_patch_size -1;

        less_x_idx = find(points_x < min_x_region);
        less_y_idx = find(points_y < min_y_region);
        less_idx = union(less_x_idx,less_y_idx);

        gt_x_idx = find(points_x > max_x_region);
        gt_y_idx = find(points_y > max_y_region);
        gt_idx = union(gt_x_idx,gt_y_idx);

        invalid_idx = union(less_idx,gt_idx);
        points_y(invalid_idx) =[];
        points_x(invalid_idx) =[];


end


function [points_x,points_y]=skip_top_bottom_pixels(points_x,points_y,rows,cols)
    pixels_skipped_from_top=ceil(0.09*rows);
    pixels_skipped_from_bottom=pixels_skipped_from_top+100;
    pixels_skipped_from_side=ceil(0.052*cols);

   % points_x=find(points_x > pixels_skipped_from_top & points_x < pixels_skipped_from_bottom );
    %points_y=find(points_y > pixels_skipped_from_side );
    
    less_x_idx = find(points_x < pixels_skipped_from_side);
    less_y_idx = find((points_y < pixels_skipped_from_top) |(points_y > (rows-pixels_skipped_from_bottom)) );
    invalid_idx = union(less_x_idx,less_y_idx);
    points_y(invalid_idx) =[];
    points_x(invalid_idx) =[];
end 

