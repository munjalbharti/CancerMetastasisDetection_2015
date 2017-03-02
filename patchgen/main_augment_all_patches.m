function [  ] = main_augment_all_patches( )

LoadDefaults;
dir_pref=fullfile('F:','CamelyonTrainingData','Level7');

thresh=30000; 


%Currently k=1 as we have to augment only positive patches 
for k=1:1
    if(k==1)
		in_dir=fullfile(dir_pref,'Positive'); 
        indexes=dataset2_indexes_tumor;
        is_Tumor=true;
    else       
		in_dir=fullfile(dir_pref,'Negative');
        indexes=all_slide_indexes_normal ;
        is_Tumor=false ;
    end
         
for slide_index=indexes

   slide_name=get_slide_name(slide_index,is_Tumor);
   filename=sprintf('%s.mat',slide_name) ;
  
   load(fullfile(in_dir,filename),'Patches');
  
   total_patches=size(Patches,4);
         
   if(total_patches >= thresh)
       continue ;
   end 
  
   patches_to_be_generated = thresh-total_patches ;
   
   printf('%d number of patches will be generated for slide:  %s',patches_to_be_generated,slide_name);
   no_of_patches_augment=ceil(patches_to_be_generated/5);
   no_of_patches_augment=min(no_of_patches_augment,total_patches);
   
   slide_patches=zeros(0,0,0,0,'uint8');
   %put all patches 
   slide_patches(:,:,:,end+1:end+size(Patches,4))=uint8(Patches);
   
     for patch_index=1:no_of_patches_augment      
       patch_to_augment= Patches(:,:,:,patch_index);
       augmentations= augment_patch(patch_to_augment); 
       slide_patches(:,:,:,end+1:end+size(augmentations,4))=uint8(augmentations);
     end 
     

    writePatchesMat(slide_patches,fullfile(dir_pref,'Augmented'),slide_name,is_Tumor);
       
end

end


end




