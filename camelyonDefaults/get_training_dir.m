function [ training_dir ] = get_training_dir(  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if ispc
    training_dir = fullfile('F:\Camelyon\Data\TrainingData');
else
    training_dir = fullfile('~','CamelyonTrainingData');    
end


end

