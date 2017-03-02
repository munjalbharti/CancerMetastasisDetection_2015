function [ x_p,y_p ] = get_high_prob_points( response_map, level_lower,level_target,thresh )
%GET_HIGH_PROB_POINTS Summary of this function goes here
%   Detailed explanation goes here
    [sy,sx]=find(response_map >=thresh);
    [x,y] = interpolateCoordinatesByLevel(sx,sy,level_lower,level_target);
               
    pixels_per_point = 4^(level_lower - level_target);
    [x_p,y_p]=get_upper_pixels(x,y, pixels_per_point);

end

