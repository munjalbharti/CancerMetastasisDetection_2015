function [ probs ] = EvaluateImageAtLoc( net,slide,loaded_image,centers_x,centers_y, opts )
% Evaluates the slide using the net at locations passed
     
        sample_size=opts.sample_size;
        
       % fprintf('\nextracting patches');
        t1=tic ;
        %patches1=patchAtPoints(slide, level, centers_x , centers_y, sample_size);    
        patches=patchImageAtPoints(loaded_image,centers_x , centers_y, sample_size); 
        fprintf('\npatches extracted in %.4f seconds',toc(t1));  
        total_patches=size(centers_y,1);
       
        process_patches =single(opts.preprocess_fn(patches));
        if opts.gpu
            process_patches = gpuArray(process_patches);
        end
        t3=tic;        
        responses = CNN.classifyBatch( net,process_patches,opts.isDagNN);
       
        fprintf('\nbatch classified in %.4f seconds',toc(t3));
        probs=responses(1,:)';  

end



