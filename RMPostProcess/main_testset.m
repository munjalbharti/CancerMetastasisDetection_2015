%% Run post processing on Camelyon train testing data

clear;
close all;
run ../SetupCamelyon
LoadDefaults;
result_dir_prefix ='F:\Camelyon\Results\Testing_Data_Level_7_Adagrad_Level_4_Adagrad_Response_Maps_Cascade\';
out_dir1 = 'post_process7Med0G0D7-regmax-dist13';

level = 4;

out_path_prefix1 = fullfile(result_dir_prefix,out_dir1,'Evaluation2');
dbg_img_dir = fullfile(out_path_prefix1,out_dir1,'dbg_imgs');

mkdir(dbg_img_dir);  
mkdir(fullfile(out_path_prefix1));
    


for i=test_slide_indexes
        slide_name = get_slide_name(i);
        slide = get_slide(i);
        res_name = sprintf('%s.mat',slide_name) ; 
        rm_file = fullfile(result_dir_prefix,res_name);
        csv_name = sprintf('%s.csv',res_name(1:end-4));
        csv_file1 = fullfile(out_path_prefix1,csv_name);

        rm = load(rm_file);
        full_rm = full(rm.RM);
        [X1,Y1,prob1]= RMPostProcess1(full_rm,level);
        [X1,Y1]= interpolateCoordinatesByLevel(X1-1,Y1-1,level,1);
       
        prob1 = round(prob1,4);
        eval_table1 =table(prob1,X1,Y1);
        writetable(eval_table1, csv_file1,'Delimiter',',',...
            'WriteVariableNames',false);

        f=figure;
        hold on;
        slide.show;
        hold on;
        scatter(X1,Y1,(prob1*100 +0.1),[1,1,0]);

        filename_png = sprintf('Inf_%s.png',slide_name);
        saveas(f,fullfile(dbg_img_dir,filename_png));
        close(f);


 end

