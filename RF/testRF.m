LoadDefaults;
rf_result_dir_prefix ='F:\Camelyon\Results\Level_4_Trained_Results_googlenet\';
rf_out_dir1 = 'post_process1LesionFeatures';
rf_out_path_prefix1 = fullfile(rf_result_dir_prefix,rf_out_dir1,'LesionFeatures');
r=load(fullfile(rf_out_path_prefix1,'RFTree_bag_equal_upsamp5x_test.mat'));

rf_tree=r.rf_tree ;

result_dir_prefix ='F:\Camelyon\Results\Level_4New_google_net\';
leason_features_path = 'post_process1LesionFeatures';

%out_path_prefix2 = fullfile(result_dir_prefix,out_dir2);
out_path_prefix0 = fullfile(result_dir_prefix,leason_features_path);
out_path_prefix1 = fullfile(result_dir_prefix,leason_features_path,'LesionFeatures');

evaluation2_path = fullfile(out_path_prefix0,'EvalBagEqualUpSamp5x_area','Evaluation2');

 mkdir(evaluation2_path);
for k=1:2
    if(k == 1)
        type_dir= 'Tumor';
        list =test_slide_indexes_tumor;
        isTumor = true;
        
    else
        type_dir='Normal';
        list =test_slide_indexes_normal;
        isTumor = false;
        
    end
   
     for i=list
        slide_name = get_slide_name(i,isTumor);
        res_name = sprintf('%s.mat',slide_name) ; 
        csv_name = sprintf('%s.csv',res_name(1:end-4));
        csv_file = fullfile(out_path_prefix1,csv_name);
        features = readtable(csv_file,'ReadVariableNames',false);        
        
        raw_X = table2array(features(:,4:end));
        
%        [y,acores]=rf_tree.Predict(raw_X); 
         [y,acores]=predict(rf_tree,raw_X);
        prob1 = acores(:,2);
        X1 = table2array(features(:,1));
        Y1 = table2array(features(:,2));
        eval_table1 =table(prob1,X1,Y1);
        eval_csv_file = fullfile(evaluation2_path,csv_name);
        writetable(eval_table1, eval_csv_file,'Delimiter',',',...
            'WriteVariableNames',false);
     end 

   
end 
