function [ imdb ] = CreateCamelyonIMDBData(  )
%CreateCamelyonIMDBData Build data for training
% Paths for positive patches, negative patches and boundary negative patches
% are given in CamelyonIMDBDataPaths.m



[pathstr,name,ext] = fileparts(mfilename('fullpath')); 
addpath([pathstr '/']);
addpath([pathstr '/util/']);

options.patchsize = [224 224];
options.num_train_negative = 120000;
options.num_train_positive =  120000;
options.num_val_negative = 20000;
options.num_val_positive =  20000;

 
 
 num_total_samples = options.num_train_negative+ options.num_train_positive + ...
     options.num_val_negative + options.num_val_positive ; 
 num_train_negative_random=.80* options.num_train_negative;
 num_train_negative_boundary=.20* options.num_train_negative;
 
 
 num_test_negative_random=.80* options.num_val_negative;
 num_test_negative_boundary=.20* options.num_val_negative;
 
 
options.imdb_target_file = fullfile('F:','CamelyonTrainingData','imdb','camlyon_120k_120k-L4-boundary-loaded.imdb.mat');

CamelyonIMDBDataPaths;
LoadDefaults
 
imdb = IMDB.init();
imdb.images.data = zeros(options.patchsize(1),options.patchsize(2),3,num_total_samples,'uint8');% If this step is omitted, matlab does some weird indexing things 
imdb.images.dataCount = 0;
imdb.meta.classes = [1 2];


%% Prepare train Set
train_tumor_indexes_dataset1 = intersect(train_slide_indexes_tumor,1:70);
train_normal_indexes_dataset1 = intersect(train_slide_indexes_normal,1:100);

train_tumor_indexes_dataset2 = intersect(train_slide_indexes_tumor,71:110);
train_normal_indexes_dataset2 = intersect(train_slide_indexes_normal,101:160);


train_positive_samples_array_dataset1 = get_sample_distribution(positive_patch_path,train_tumor_indexes_dataset1,tumor_slide_list);
train_negative_samples_array_dataset1 = get_sample_distribution(negative_patch_path,train_normal_indexes_dataset1,normal_slide_list);
b_train_negative_samples_array_dataset1 = get_sample_distribution(boundary_negative_patch_path,train_tumor_indexes_dataset1,tumor_slide_list);


train_positive_samples_array_dataset2 = get_sample_distribution(positive_patch_path,train_tumor_indexes_dataset2,tumor_slide_list);
train_negative_samples_array_dataset2 = get_sample_distribution(negative_patch_path,train_normal_indexes_dataset2,normal_slide_list);
b_train_negative_samples_array_dataset2 = get_sample_distribution(boundary_negative_patch_path,train_tumor_indexes_dataset2,tumor_slide_list);


train_positive_samples_array_dataset1 = distribute_among_slides(train_positive_samples_array_dataset1,4, options.num_train_positive/2);
train_negative_samples_array_dataset1 = distribute_among_slides(train_negative_samples_array_dataset1,4, num_train_negative_random/2);
b_train_negative_samples_array_dataset1 = distribute_among_slides(b_train_negative_samples_array_dataset1,4, num_train_negative_boundary/2);


train_positive_samples_array_dataset2 = distribute_among_slides(train_positive_samples_array_dataset2,4, options.num_train_positive/2);
train_negative_samples_array_dataset2 = distribute_among_slides(train_negative_samples_array_dataset2,4, num_train_negative_random/2);
b_train_negative_samples_array_dataset2 = distribute_among_slides(b_train_negative_samples_array_dataset2,4, num_train_negative_boundary/2);

train_positive_samples_array = vertcat(train_positive_samples_array_dataset1,train_positive_samples_array_dataset2);
train_negative_samples_array = vertcat(train_negative_samples_array_dataset1,train_negative_samples_array_dataset2);
b_train_negative_samples_array = vertcat(b_train_negative_samples_array_dataset1,b_train_negative_samples_array_dataset2);



imdb = addToImdbSet(imdb,1,1,train_positive_samples_array,4,positive_patch_path,tumor_slide_list);
imdb = addToImdbSet(imdb,1,2,train_negative_samples_array,4,negative_patch_path,normal_slide_list);
imdb = addToImdbSet(imdb,1,2,b_train_negative_samples_array,4,boundary_negative_patch_path,tumor_slide_list);

% Added Training images... Computing mean and std for these images
imdb.images.dataMean = mean(imdb.images.data, 4);
%imdb.images.dataStd   =  std(single(imdb.images.data),0, 4);


%% Prepare Validation Set
test_positive_samples_array = get_sample_distribution(positive_patch_path,test_slide_indexes_tumor,tumor_slide_list);
test_negative_samples_array = get_sample_distribution(negative_patch_path,test_slide_indexes_normal,normal_slide_list);
b_test_negative_samples_array=get_sample_distribution(boundary_negative_patch_path,test_slide_indexes_tumor,tumor_slide_list);


test_positive_samples_array = distribute_among_slides(test_positive_samples_array,4, options.num_val_positive);
test_negative_samples_array = distribute_among_slides(test_negative_samples_array,4, num_test_negative_random);
b_test_negative_samples_array = distribute_among_slides(b_test_negative_samples_array,4, num_test_negative_boundary);



%% Validation Set
imdb = addToImdbSet(imdb,2,1,test_positive_samples_array,4,positive_patch_path,tumor_slide_list);
imdb = addToImdbSet(imdb,2,2,test_negative_samples_array,4,negative_patch_path,normal_slide_list);
imdb = addToImdbSet(imdb,2,2,b_test_negative_samples_array,4,boundary_negative_patch_path,tumor_slide_list);


%--------------------
fig_train = figure;
fig_dist_name = sprintf('%s_dist.jpg',options.imdb_target_file);
subplot(2,2,1);
plot_pos_indexes = [cat(1,train_positive_samples_array{:,1})];
plot_pos_values = cat(1,(train_positive_samples_array{:,4}));
bar(plot_pos_indexes,plot_pos_values);
title('Train Positive (Tumor)')
xlim([min(all_slide_indexes_tumor) max(all_slide_indexes_tumor)])

subplot(2,2,2);
plot_neg_indexes = cat(1,train_negative_samples_array{:,1});
plot_neg_values = cat(1,(train_negative_samples_array{:,4}));
bar(plot_neg_indexes,plot_neg_values);
title('Train Negative (Normal)')
xlim([min(all_slide_indexes_normal) max(all_slide_indexes_normal)])

subplot(2,2,3);
plot_test_pos_indexes = cat(1,test_positive_samples_array{:,1});
plot_test_pos_values = cat(1,(test_positive_samples_array{:,4}));
bar(plot_test_pos_indexes,plot_test_pos_values);
title('Validation Positive (Tumor)')
xlim([min(all_slide_indexes_tumor) max(all_slide_indexes_tumor)])

subplot(2,2,4);
plot_test_neg_indexes = cat(1,test_negative_samples_array{:,1});
plot_test_neg_values = cat(1,(test_negative_samples_array{:,4}));
bar(plot_test_neg_indexes,plot_test_neg_values);
title('Validation Negative (Normal)')
xlim([min(all_slide_indexes_normal) max(all_slide_indexes_normal)])

saveas(fig_train,fig_dist_name);

save(options.imdb_target_file, 'imdb', '-v7.3');

end


function [imdb] = addToImdbSet(imdb,set_no,label,samples_array,num_files_index,path,slide_list_table)

for s=1:size(samples_array,1); 
    mat_file=get_mat_file(path,samples_array{s,1},slide_list_table);  
    loaded_files_in_slide = uint8(mat_file.Patches);    
    num_samples_from_slide = samples_array{s,num_files_index};
    ridx = randperm(length(loaded_files_in_slide));
    loaded_files_in_slide =loaded_files_in_slide(:,:,:,ridx(1: num_samples_from_slide));
    
    imdb.images.data(:,:,:,imdb.images.dataCount+1:imdb.images.dataCount+num_samples_from_slide) = uint8(loaded_files_in_slide);
    imdb.images.labels(1,end+1:end+num_samples_from_slide) = label;    
    imdb.images.set(1,end+1:end+num_samples_from_slide) = set_no;
    imdb.images.dataCount = imdb.images.dataCount + num_samples_from_slide;           
end

end

function[mat_file]= get_mat_file(path,slide_index,slide_list_table)
    slide_name=slide_list_table.Var1{slide_index};
    mat_name=[path filesep sprintf('%s.mat',slide_name)];  
    mat_file = matfile(mat_name);
end 

%% Samples from subdirectories of the path passed
function [samples_array]= get_sample_distribution(path,slide_idx,slide_list_table)
num_slides = length(slide_idx);

samples_array =cell(num_slides,6);
for i=1:num_slides
    slide_index = slide_idx(i);
    mat_file=get_mat_file(path,slide_index,slide_list_table);    
    [nrows, ncols,depth,total_patches] = size(mat_file,'Patches');
    samples_array{i,1} = slide_index;
    samples_array{i,2} = total_patches;
 end

end

function [samples_array]=distribute_among_slides(samples_array,result_index1,total)

num_slides = size(samples_array,1);

num_samples_per_slide = floor(total/num_slides);

for i=1:num_slides
   samples_array{i,result_index1}= min(samples_array{i,2},num_samples_per_slide);
end

num_allocated = sum([samples_array{:,result_index1}]);
remaining = total - num_allocated;

j=0;
%% Change this ...BAd
while(remaining >0)
    index = mod(j,num_slides)+1;
    if(samples_array{index,2}>samples_array{index,result_index1})
        samples_array{index,result_index1} = samples_array{index,result_index1} +1;
        remaining = remaining -1;
    end
    
    j = j+1;
end


end
