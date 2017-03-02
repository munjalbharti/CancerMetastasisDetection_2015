function [ images, labels ] = getBatchRGBPooled(imdb, batch)
%GETBATCH Pick a batch of images from the imdb struct that only hols
%filenames of patches

    tic;
    filenames = imdb.images.filenames(batch);
    images = zeros(33,33,3,length(filenames));
    num_files = length(filenames);
    parfor (f=1:num_files,15)   
       %Image.data = imresize(Image.data, [33 33]);
       %Image.data = CNN.preprocess_image(Image.data,false);
       %
       images(:,:,:,f) = single(imread(filenames{f}));
       
    end
    images =  images./255;
    %images = normalize2(images, 'single', 8);
    images = single(images);
    labels = imdb.images.labels(1,batch);
    %labels = imdb.images.labels(:,:,:,batch,:); 
    timeElapsed = toc;
    disp(['Dur:', num2str(timeElapsed)]);
    disp(['Batch min: ' num2str(min(images(:))) ', max: ' num2str(max(images(:)))]);
end
