%Script used to train the RF classfier
% Features for this classfier are to be generated using mainRFfeatures


clear;
close all;
run ../SetupCamelyon
LoadDefaults;


result_dir_prefix ='F:\Camelyon\Results\Level_4_Trained_Results_googlenet\';
out_dir1 = 'post_process1LesionFeatures';
out_path_prefix1 = fullfile(result_dir_prefix,out_dir1,'LesionFeatures');

allfeatures=[];
for k=1:2
    if(k == 1)
        type_dir= 'Tumor';
        list =train_slide_indexes_tumor;
        isTumor = true;
        
    else
        type_dir='Normal';
        list =[];%test_slide_indexes_normal;
        isTumor = false;
        
    end
   
     for i=list
        slide_name = get_slide_name(i,isTumor);
        res_name = sprintf('%s.mat',slide_name) ; 
        csv_name = sprintf('%s.csv',res_name(1:end-4));
        csv_file = fullfile(out_path_prefix1,csv_name);
        features = readtable(csv_file,'ReadVariableNames',false);        
        allfeatures=[allfeatures; features];
     end 

   
end 


raw_X = table2array(allfeatures(:,4:end));
raw_Y = table2array(allfeatures(:,3));

rng(1);
pos_sample_indexes = find(raw_Y==1);
neg_sample_indexes=find(raw_Y==0);
n=5*length(pos_sample_indexes);
selected_neg_indexes = neg_sample_indexes(randperm(length(neg_sample_indexes),n));

selected_pos_indexes = datasample(pos_sample_indexes,n,'Weights',table2array(allfeatures(pos_sample_indexes,4)));
selected_indexes = [selected_neg_indexes;selected_pos_indexes];

X = raw_X(selected_indexes,:);
Y = raw_Y(selected_indexes,:);

part = cvpartition(Y,'holdout',0.3);
istrain = training(part); % data for fitting
istest = test(part); % data for quality assessment

t = templateTree('MinLeafSize',5);
tic
rf_tree = fitensemble(X(istrain,:),Y(istrain),'bag',200,'Tree','type','classification');
toc

figure;
tic
plot(loss(rf_tree,X(istest,:),Y(istest),'mode','cumulative'));
toc
grid on;
xlabel('Number of trees');
ylabel('Test classification error');

figure;
tic
plot(loss(rf_tree,X(istrain,:),Y(istrain),'mode','cumulative'));
toc
grid on;
xlabel('Number of trees');
ylabel('Train classification error');

save(fullfile(out_path_prefix1,'RFTree_bag_equal_upsamp5x_test.mat'),'rf_tree')
