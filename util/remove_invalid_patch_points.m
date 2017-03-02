function [ points_x,points_y ] = remove_invalid_patch_points(points_x,points_y, ws_img_size, patch_size )
%Removes the indices that are not able to fit the patch size 
               
        height=ws_img_size(2);
        width=ws_img_size(1);
        
        half_patch_size = floor(patch_size/2);
        
        min_x_region = 1+half_patch_size;
        min_y_region = 1+half_patch_size;
                
        max_x_region = width - half_patch_size -1;
        max_y_region = height - half_patch_size -1;

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




