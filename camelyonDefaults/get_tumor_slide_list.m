function [ list ] = get_tumor_slide_list(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

training_dir=get_training_dir();
tumor_csv_path = fullfile(training_dir,'tEPIS_CaseIDs','CaseID_Tumor.csv');

list = readtable(tumor_csv_path,'ReadVariableNames',false);

end

