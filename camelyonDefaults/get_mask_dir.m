function [ mask_dir ] = get_mask_dir(  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
  
training_dir=get_training_dir();
mask_dir = fullfile(training_dir,'Ground_Truth','Mask');


end

