function [ patches ] = PreprocessPatches1( patches, train_mean,train_std )
%PREPROCESSPATCHES1 Process patches before passing it to the net
%   Subract mean and divide by stdev

    patches = bsxfun(@rdivide,bsxfun(@minus,single(patches),train_mean),train_std);
end

