function [ sx ,sy ] = findTumorIndices( slide_name,level)
%FINDTUMORINDICES Returns the indices of tumor pixels 

mask = ReadMask(slide_name,level);
[sy,sx] = find(mask==255);

end

