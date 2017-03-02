function [  ] = CNN_EvaluateSlides( )

clear ;
close all ;

run(['..' filesep 'SetupCamelyon'])
%run(['..' filesep 'extern' filesep 'tepismat' filesep 'init'])
LoadDefaults;

opts.level =4;
opts.target_dir='F:\Camelyon\Results\Testing_Data_Results_googlenet\';
opts.gpu=false;
opts.isDagNN=true ;

if opts.isDagNN
    test=load('mean.mat');   
    train_mean=test.data_mean ;
    opts.preprocess_fn = @(patches)CNN.PreprocessPatches2(patches,train_mean);
    opts.sample_size = 224 ;
    epoch=54 ;
    net = CNN.load(['..' filesep 'data' filesep 'camelyonl4-120k-googlenet-reinit-L-step-M-9-Batch-32-1' filesep sprintf('net-epoch-%d.mat',epoch)],opts.isDagNN);
    if opts.gpu
        net.move('gpu') ;
    end
else 
    imdbPath = fullfile('F:','CamelyonTrainingData','imdb','camlyon_500k_500k-L4-boundary-loaded-1.imdb2.mat');
    train_imdb=load(imdbPath);
    train_mean=train_imdb.imdb.images.dataMean;    
    train_std=train_imdb.imdb.images.dataStd ;
    opts.preprocess_fn = @(patches)CNN.PreprocessPatches1(patches,train_mean,train_std);
    opts.sample_size = 33 ;
    epoch=330;
    net = CNN.load(['..' filesep 'data' filesep 'camelyonl4-net2-L-005-adagrad-M-9-Val100-Batch-500-boundary' filesep sprintf('net-epoch-%d.mat',epoch)]);
    net.layers{end}.type = 'softmax'; % Change the last layer to softmax for classification in order to output class probabilities


end 

%training_dir = fullfile('/Volumes/bm_usb/','CamelyonTrainingData');
%tumor_csv_path = fullfile(training_dir,'tEPIS_CaseIDs','CaseID_Tumor.csv');
%tumor_slide_list = readtable(tumor_csv_path,'ReadVariableNames',false);

if not (exist(opts.target_dir,'dir') ==7)
     mkdir(opts.target_dir);
end

%parpool('local');
%pctRunOnAll run(['..' filesep 'SetupCamelyon'])
%Loop for tumor and normal slides k=1 tumor k=2 normal
isTrainData = false;
if(isTrainData)
    
    
  for k=1:2
    
    if k==1
        indexes = setdiff(train_slide_indexes_tumor,[1:75]);
        is_Tumor=true;
        %target_dir=fullfile(target_dir_pre,'Tumor');
   else 
        indexes =setdiff( train_slide_indexes_normal,[0:0]);  
        is_Tumor=false ;
        %target_dir=fullfile(target_dir_pre,'Normal');
   end
  end
  
else
    
    indexes = setdiff(test_slide_indexes,[1:73]);    
    is_Tumor=NaN;
end

for (itr=1:length(indexes)) 
  eval_save_slide(isTrainData, indexes(itr),is_Tumor,opts,net);
end 



end


function [  ] = eval_save_slide(isTrainData,slide_index,is_Tumor,opts,net )

    if(isTrainData)
        name=get_slide_name(slide_index,is_Tumor);
        slide = get_slide(slide_index, is_Tumor);
    else
        name=get_slide_name(slide_index);
        slide = get_slide(slide_index);
        
    end
    
    t1=tic;
    fprintf('\ngenerating response map for slide %s',name);
 
    
    ws_img_size = slide.PixelSize(opts.level,:);
    
    width=ws_img_size(1);
    height=ws_img_size(2);
    
    
  %  S = generate_response_map_for_slide(net,slide,opts.level, is_Tumor, opts.sample_size);
   [responses,centers_x,centers_y,width,height] =  CNN.EvaluateSlide3(net,slide,name,opts);

  
    fprintf('elapsed time for response map generation is: %.4f seconds for slide %s \n', toc(t1),name);
    S = sparse(centers_y,centers_x,double(responses),height,width);

    fprintf('\ndone with response map  generation..going to save response map for slide %s',name);
    t2=tic;
    save_and_draw_response_map(S,slide,name,opts.level,opts.target_dir,is_Tumor);
    fprintf('elapsed time for response map saving is: %.4f seconds for slide \n', toc(t2),name);
end
