function [ responses ] = EvaluateImageInBatch(net,slide,loaded_image,slide_name,centers_x,centers_y,opts )
%EVALUATE_BATCH Summary of this function goes here
%   Detailed explanation goes here

%batch_size = 32;
batch_size = 50;

total_patches=size(centers_y,1);
total_batches=ceil(total_patches/batch_size);
 
sample_size=opts.sample_size;
level=opts.level ;


response_cells=cell(total_batches,1);

      
parfor batch_no=1:total_batches
        fprintf('\nevaluating batch [%d/%d] for slide %s',batch_no,total_batches,slide_name);
        batch_start=(batch_no-1)*batch_size+1;
       
        if(batch_no == total_batches)
            %Last batch
            batch_end = total_patches;         
        else 
            batch_end= batch_no*batch_size;
          
        end 
        
        patches_index=[batch_start:batch_end];
        
        curr_centers_x=centers_x(patches_index,1);
        curr_centers_y=centers_y(patches_index,1);
        
        response_cells{batch_no,1}=CNN.EvaluateImageAtLoc(net,slide,loaded_image,...
            curr_centers_x,curr_centers_y, opts );
        
         
 end 

responses = cell2mat(response_cells);
      

end

function [responses] = Evaluate_Batch(batch_no,total_batches,net,slide,loaded_image,level,...
            centers_x,centers_y, sample_size)


        batch_start=(batch_no-1)*batch_size+1;
       
        if(batch_no == total_batches)
            %Last batch
            batch_end = total_patches;         
        else 
            batch_end= batch_no*batch_size;
          
        end 
        
        patches_index=[batch_start:batch_end];
        
        curr_centers_x=centers_x(patches_index,1);
        curr_centers_y=centers_y(patches_index,1);
        
        responses=CNN.EvaluateImageAtLoc(net,slide,loaded_image,level,...
            curr_centers_x,curr_centers_y, sample_size );

end
