function [ tx,ty ] = interpolateCoordinatesByLevel( x,y, src_level,target_level )
%INTERPOLATE_COORDINATESBYLEVEL Returns the corresponding coordinates in
%the target slide level
%   Detailed explanation goes here


    scale = 2^(src_level - target_level);

    tx = ceil(x * scale);
    ty = ceil(y * scale);

end

