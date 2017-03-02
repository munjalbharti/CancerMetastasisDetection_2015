function [ patches ] = PreprocessPatches2( patches, train_mean )
%PREPROCESSPATCHES1 Process patches before passing it to the net
%   Subtract mean

    patches = bsxfun(@minus,single(patches),train_mean);

end

