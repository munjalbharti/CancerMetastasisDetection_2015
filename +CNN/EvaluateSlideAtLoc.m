function [ probs ] = EvaluateSlideAtLoc( net,slide,level,centers_x,centers_y, sample_size )
% Evaluates the slide using the net at locations passed
     
       % fprintf('\nextracting patches');
        t1=tic ;
        patches=patchAtPoints(slide, level, centers_x , centers_y, sample_size);           
        fprintf('\npatches extracted in %.4f seconds',toc(t1));  
        total_patches=size(centers_y,1);
       
       % fprintf('\nclassifying batch');
       t2=tic; 
       for k=1:total_patches
            process_patches(:,:,:,k)=CNN.preprocess_image(patches(:,:,:,k),false);
        end 
        
        fprintf('\n preprocessing done in %.4f seconds',toc(t2));  
        
        t3=tic;
        responses = CNN.classifyBatch( net,single(process_patches));
        fprintf('\nbatch classified in %.4f seconds',toc(t3));
        probs=responses(1,:)';  

end



