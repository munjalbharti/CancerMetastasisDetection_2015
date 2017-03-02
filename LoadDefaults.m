global test_slide_indexes_tumor
global test_slide_indexes_normal

test_slide_indexes_tumor = [1:10,101:110];
test_slide_indexes_normal =[31:45, 146:160];

global all_slide_indexes_tumor
global all_slide_indexes_normal

all_slide_indexes_tumor = 1:110;
all_slide_indexes_normal = 1:160;

global dataset1_indexes_tumor
global dataset2_indexes_tumor

dataset1_indexes_tumor = 1:70;
dataset2_indexes_tumor = 71:110;

global dataset1_indexes_normal
global dataset2_indexes_normal

 dataset1_indexes_normal = 1:100;
 dataset2_indexes_normal = 101:160;

global train_slide_indexes_normal
global train_slide_indexes_tumor

train_slide_indexes_normal = setdiff(all_slide_indexes_normal,test_slide_indexes_normal);
train_slide_indexes_tumor = setdiff(all_slide_indexes_tumor,test_slide_indexes_tumor);

global train_tumor_indexes_dataset1
global train_normal_indexes_dataset1

train_tumor_indexes_dataset1 = intersect(train_slide_indexes_tumor,dataset1_indexes_tumor);
train_normal_indexes_dataset1 = intersect(train_slide_indexes_normal,dataset1_indexes_normal);

global train_tumor_indexes_dataset2
global train_normal_indexes_dataset2

train_tumor_indexes_dataset2 = intersect(train_slide_indexes_tumor,dataset2_indexes_tumor);
train_normal_indexes_dataset2 = intersect(train_slide_indexes_normal,dataset2_indexes_normal);

global training_dir
global mask_dir

if ispc
    training_dir = fullfile('F:\Camelyon\Data\TrainingData');
else
    training_dir = fullfile('~','CamelyonTrainingData');    
end
mask_dir = fullfile(training_dir,'Ground_Truth','Mask');

global normal_csv_path
global tumor_csv_path

normal_csv_path = fullfile(training_dir,'tEPIS_CaseIDs','CaseIDs_Normal.csv');
tumor_csv_path = fullfile(training_dir,'tEPIS_CaseIDs','CaseID_Tumor.csv');

global tumor_slide_list
global normal_slide_list

tumor_slide_list = readtable(tumor_csv_path,'ReadVariableNames',false);
normal_slide_list = readtable(normal_csv_path,'ReadVariableNames',false);


global test_slide_indexes;
test_slide_indexes=1:130;


