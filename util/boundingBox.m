function [ bounding_box_x, bounding_box_y] = boundingBox( center_x,center_y,size )
%BOUNDINGBOX - Returns the indices of a bounding box of given size around
%the center pixel passed
        half_patch_size = floor(size/2);
        top_left_x = center_x - half_patch_size;
        top_left_y = center_y - half_patch_size;
        
        top_right_x = center_x + half_patch_size;
        top_right_y = center_y - half_patch_size;
        
        bottom_left_x = center_x - half_patch_size;
        bottom_left_y = center_y + half_patch_size;
        
        bottom_right_x = center_x + half_patch_size;
        bottom_right_y = center_y + half_patch_size;
        
        bounding_box_x = [top_left_x top_right_x bottom_right_x bottom_left_x top_left_x];
        bounding_box_y = [top_left_y top_right_y bottom_right_y bottom_left_y top_left_y];
end

