function [  ] = generatePatchesCascade( layer_obj,target_folder,cutOffThreshold,level2)
%GENERATEPATCHESCASCADE Generate better patches for training NN Cascade
%  - Generate positive and negative patches
%  - Ignore patches that fall below cutOffThreshold
%  - Postive patches are those that are actually tumor and falls
%    above cutOffThreshold
%  - Negative patches are those that are actually non tumor and falls
%    above cutOffThreshold

% which layer to create the patches from
LoadDefaults;

%Layer1 patch size
sample_size1=33 ;

%Layer2 patc size
sample_size2=33 ;

% Tumor Slides (Positive Patches)
%for slide_index=train_slide_indexes_tumor
 %   slide_name = get_slide_name(slide_index,true);
  %  [tx,ty] = findTumorIndices(slide_name, opts.level);
   % [Patches,filt_x,filt_y] = filtered_patches_using_net(net,cutOffThreshold,slide,tx,ty,sample_size);
    %writeImageBatch(opts.target_folder,true,slide_name,Patches,filt_x,filt_y);
%end
batch_size= 1000;
%all_patches=zeros(0,0,0,0);

%all_slide_indexes_normal
for slide_index= dataset2_indexes_normal
    slide_name = get_slide_name(slide_index,false);
    slide = get_slide(slide_index,false);
    [tx,ty] = get_stained_region_bounded( slide, layer_obj.level);
    ridx = randperm(length(tx));
    tx = tx(ridx);
    ty = ty(ridx);
    num_patches_generated = 0;
    patches_per_slide=zeros(0,0,0,0);
   
    for k=1:batch_size:length(tx)
        %if (num_patches_generated >= get_max_samples(slide_index))
        if(num_patches_generated >= 12000)
         break;
        end
        batch_start = k;
        batch_end = min(batch_start + batch_size -1,length(tx)) ;
        bx = tx(batch_start:batch_end);
        by = ty(batch_start:batch_end);
        [Patches_per_batch,filt_x,filt_y] = filtered_patches_using_net(layer_obj,...
            cutOffThreshold,slide,bx,by,sample_size1,level2,sample_size2);
      
        patches_per_slide(:,:,:,num_patches_generated+1:num_patches_generated + length(filt_x))=Patches_per_batch;        
      
        num_patches_generated = num_patches_generated + length(filt_x);   
       
       % writeImageBatchPooled(target_folder,false,slide_name,Patches_per_batch,filt_x,filt_y);
    end
    
    mat_name=sprintf('%s.mat',slide_name);
    target_file= [target_folder filesep mat_name];
    Patches=patches_per_slide;
    save(target_file, 'Patches', '-v7.3');

   % all_patches(:,:,:,end+1:end+num_patches_generated) = patches_per_slide;        
end


     

% Normal Slides (Negative Patches)

end

function [max] =  get_max_samples(slide_index)

train_max_samples_dataset1 = 8000;
train_max_samples_dataset2 = 12000;

global train_normal_indexes_dataset1;
global train_normal_indexes_dataset2;

if(length(find(train_normal_indexes_dataset2==slide_index)) == 1)
    max = train_max_samples_dataset2; 
else
    max = train_max_samples_dataset1;
end
end
function [P,x_p,y_p]=filtered_patches_using_net(layer_obj,cutoff, slide,tx,ty,sample_size1,level2,sample_size2)
        loc_probs=layer_obj.evaluate(slide,tx,ty,sample_size1);  
        idx=find(loc_probs > cutoff);
        x_fil=tx(idx);
        y_fil=ty(idx);
       
       [x_p,y_p]= interpolateApproxCenter(x_fil,y_fil,layer_obj.level,level2);
       
         %remove points where we dont need to generate patches    
        
         ws_img_size = slide.PixelSize( level2,:);
        [x_p,y_p]=remove_invalid_patch_points(x_p,y_p, ws_img_size,sample_size2);
        
        P=patchAtPoints(slide,level2,x_p,y_p,sample_size2);                      
end
