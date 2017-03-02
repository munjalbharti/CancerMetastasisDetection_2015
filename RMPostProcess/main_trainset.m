clear;
close all;
run ../SetupCamelyon
LoadDefaults;
result_dir_prefix ='F:\Camelyon\Results\Level_4New_google_net\';
out_dir1 = 'post_process1';

level = 7;
out_path_prefix1 = fullfile(result_dir_prefix,out_dir1,'Evaluation2');

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
        
    mkdir(fullfile(out_path_prefix1));

    for i=list
        slide_name = get_slide_name(i,isTumor);
        res_name = sprintf('%s.mat',slide_name) ; 
        rm_file = fullfile(result_dir_prefix,res_name);
        csv_name = sprintf('%s.csv',res_name(1:end-4));
        csv_file1 = fullfile(out_path_prefix1,csv_name);

        rm = load(rm_file);
        full_rm = full(rm.RM);

        [X1,Y1,prob1]= RMPostProcess1(full_rm,level);       
        [X1,Y1]= interpolateCoordinatesByLevel(X1,Y1,level,1);
        
        prob1 = round(prob1,4);
        eval_table1 =table(prob1,X1,Y1);
        writetable(eval_table1, csv_file1,'Delimiter',',',...
            'WriteVariableNames',false);
        if(isTumor)
            mask = ReadMask2(slide_name);
            f=figure;
            hold on;
            mask.show;
            hold on;
            scatter(X1,Y1,(prob1*100),[1,0,0]);
            f2=figure;
            imshow(full_rm);
            filename_png = sprintf('Inf_%s.png',slide_name);
            saveas(f,fullfile(out_path_prefix1,filename_png));
            close(f);
            close(f2);
        else 
            f = figure;
            imshow(full_rm);
            scatter(X1,Y1,(prob1*100 +0.1),[1,0,0]);
            close(f);
        end

    end
end
