function [ sx ,sy ] = findBoundaryNonTumorIndices( slide_name,level)
%FINDTUMORINDICES Returns the indices of non-tumor pixels at boundary of
%the mask

    %take pixels that are dist_thresh away from boundary
    dist_min_thresh=8;
    dist_max_thresh=12;

    mask = ReadMask(slide_name,level);
    %white foreground ..find distance of background black pixels from white foreground 
    D = bwdist(mask,'chessboard');
    [sy,sx]=find(D > dist_min_thresh & D < dist_max_thresh);
end

