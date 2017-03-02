function [ list ] = get_normal_slide_list(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    training_dir=get_training_dir();

    normal_csv_path = fullfile(training_dir,'tEPIS_CaseIDs','CaseIDs_Normal.csv');
    list = readtable(normal_csv_path,'ReadVariableNames',false);

end

