function [ testing_dir ] = get_testing_dir(  )
%GET_TESTING_DIR Summary of this function goes here
%   Detailed explanation goes here

if ispc
    testing_dir = fullfile('F:\Camelyon\Data\CAMELYON16\Testset\');
else
    testing_dir = fullfile('~','CamelyonTrainingData');    
end


end

