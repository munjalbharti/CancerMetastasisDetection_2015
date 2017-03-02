function [ sx ,sy ] = findTumorIndicesInterpolated( slide_name,level,from_level)
%FINDTUMORINDICES Returns the indices of tumor pixels 

mask = ReadMask(slide_name,from_level);
[ty,tx] = find(mask==255);

[sx,sy]=interpolateCoordinatesByLevel(tx,ty,from_level,level );
end

