function [ response_map_lower ] = scale_down_response_map_sparse( sparse_response_map, current_level, to_level )
%Scales down a sparse response map from current_level to target_level

   [r_y , r_x, val] = find(sparse_response_map);
   [r_x_lower,r_y_lower]= interpolateCoordinatesByLevel(r_x , r_y, current_level, to_level);
    
   height=size(sparse_response_map,1);
   width=size(sparse_response_map,2);
    
   scale = 2^(current_level - to_level);
   height_lower=height * scale;
   width_lower=width * scale ;
   
   response_map_lower=zeros(height_lower,width_lower); 
  for i=1:size(r_y)
        response_map_lower(r_y_lower(i,1),r_x_lower(i,1))=val(i,1);
   end 
end

