function [ images, labels] = getBatchLoaded(imdb, batch)
%GETBATCHLOADED Pick a batch of images from the imdb struct

    images = imdb.images.data(:,:,:,batch);
    images = single(images);
    
    mean=imdb.images.dataMean;
    S=imdb.images.dataStd ;
    images = bsxfun(@rdivide,bsxfun(@minus,images,mean),S);
   
    labels = single(imdb.images.labels(1,batch));
    
    %images = images./255;
end



