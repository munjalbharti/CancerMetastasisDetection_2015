function [  ] = generateSlideBasedEvalCSV(dir_pre,out_dir )
% Reads Lesion based evaluation data and generates slide based evluation
% data

in_dir=fullfile(dir_pre,'Evaluation2');
out_dir=fullfile(dir_pre,out_dir);

if not (exist(out_dir,'dir') ==7)
     mkdir(out_dir);
end
  
 
CSV_file_list = dir(fullfile(in_dir,'*.csv'));
CSV_file_list = {CSV_file_list.name}';

total_slides=numel(CSV_file_list);

slide_prob=cell(total_slides,1);
slide_name=cell(total_slides,1);

for i=1:total_slides
             
        fid = fopen(fullfile(in_dir, CSV_file_list{i}));
        results = textscan(fid,'%f %d32 %d32','Delimiter',',');
        fclose(fid);

        slide_prob{i,1}= get_slide_prob(results{1});
        slide_name{i,1} = CSV_file_list{i}(1:end-4);
      
end
slide_prob_mat = cell2mat(slide_prob);
slide_prob_mat = (slide_prob_mat - min(slide_prob_mat))/(max(slide_prob_mat) - min(slide_prob_mat));

slide_prob = num2cell(slide_prob_mat);
eval_table = table(slide_name,slide_prob);
writetable(eval_table, fullfile(out_dir,'slide_eval.csv'),'Delimiter',',','WriteVariableNames',false);


end 


function[slide_prob] =get_slide_prob(region_probs)
   opt=2;
  
   switch opt
        case 1
            slide_prob=max([region_probs;0.0]);
        case 2
             region_probs=region_probs(find(region_probs));
             x=ceil(.01*length(region_probs));
             [sort_probs,~] = sort(region_probs(:),'descend');
             slide_prob=mean(sort_probs(1:x)); 
         case 3
             x=ceil(.10*length(region_probs));
             [sort_probs,~] = sort(region_probs(:),'descend');
             slide_prob=max(sort_probs(x),0.0); 
         case 4
             x=max(100,ceil(.10*length(region_probs)));
             [sort_probs,~] = sort(region_probs(:),'descend');
             slide_prob=max(sort_probs(x),0.0);  
         case 5
             slide_prob= max(mean(region_probs),0);
         otherwise
            slide_prob=max([region_probs;0.0]);
    end
    
end 
