function [ response_map_lower ] = scale_down_response_map( response_map, current_level, to_level)  
%Scales down the response map from current_level to lower_level
%Places maximm value of each block from upper level to lower level
     values_count= 4^(to_level-current_level);
     
     fun = @(block_struct) max(max(block_struct.data)) ;
     response_map_max_block = blockproc(response_map,[sqrt(values_count) sqrt(values_count)],fun);
    
     response_map_lower=response_map_max_block;   
end
