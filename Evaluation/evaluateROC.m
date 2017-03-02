clearvars -except result_dir_prefix eval_dir ;
csv_file = fullfile(result_dir_prefix,eval_dir,'slide_eval.csv');

fid = fopen(csv_file);
results = textscan(fid,'%s %f','Delimiter',',');
fclose(fid);

indexes_Tumor = [];
slide_names = results{1,1};
for i = 1:length(slide_names)
    slide_name = slide_names{i,1};
    if strcmp(slide_name(1:5),'Tumor')
        indexes_Tumor = [indexes_Tumor i];
    end
end


indexes_Normal = setdiff(1:length(slide_names),indexes_Tumor);

P = length(indexes_Tumor);
N = length(indexes_Normal);

unlisted_FPs = results{1,2}(indexes_Normal)';
unlisted_TPs = results{1,2}(indexes_Tumor)';

all_probs = unique([unlisted_FPs, unlisted_TPs]);

counter = 1;
for Thresh = all_probs(2:end)
    total_FPs(counter) = sum(unlisted_FPs >= Thresh);
    total_TPs(counter) = sum(unlisted_TPs >= Thresh);
    counter = counter + 1;
end

total_TPR = total_TPs/P;
total_FPR = total_FPs/N;
f_roc = plotROC(total_TPR,total_FPR,fullfile(result_dir_prefix,eval_dir));  

