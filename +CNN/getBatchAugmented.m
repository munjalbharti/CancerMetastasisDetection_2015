function [ inputs] = getBatchAugmented(imdb, batch)
%GETBATCHLOADED Pick a batch of images from the imdb struct
% Returns a randomly rotated or flipped version of images from imdb


    images = imdb.images.data(:,:,:,batch);
    size_unpadded = size(images);
    padding_size=[ceil(size(images,1)/2),ceil(size(images,2)/2)];
    pad_images = padarray(images,padding_size ,'symmetric');

    
    num_files = size(pad_images,4);
    for f=1:num_files
       
       if(randi(0:1))
         pad_images(:,:,:,f) = fliplr(pad_images(:,:,:,f));
       end
       
       pad_images(:,:,:,f) = imrotate(pad_images(:,:,:,f),((randi(360))),'crop');
       images(:,:,:,f) = pad_images(padding_size(1)+1:...
           padding_size(1)+size_unpadded(1),padding_size(2)+1:...
           padding_size(2)+size_unpadded(2),:,f);
    end
    images = single(images);

    mean=imdb.images.dataMean;
    images = bsxfun(@minus,images,mean);
   
    labels = single(imdb.images.labels(1,batch));
    
    %images = images./255;
    inputs = {'data', gpuArray(images),'label',labels} ;

end



