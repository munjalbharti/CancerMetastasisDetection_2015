function imdb = rgb2grayScript()
%INIT load and prepare an IMDB
%
% @Author: Amil George
    imdb_file = fullfile('F:','CamelyonTrainingData','imdb','camlyon_500k_500k-L4-boundary-loaded-1.imdb2.mat');

    load(imdb_file);
    
    data = imdb.images.data;
    num_files = length(data);
    
    batch_size = 1000;
    imdb_target_file = fullfile('F:','CamelyonTrainingData','imdb','camlyon_500k_500k-L4-boundary-loaded-1.imdb_gray.mat');
    imdb.meta.data_mat_file = imdb_target_file;
    m=matfile(imdb_target_file,'Writable',true);
    
    for  batch_start=1:batch_size:num_files
        
        batch_end = min(num_files,batch_start+batch_size -1);
        cur_batch_len = batch_end - batch_start + 1;
        %data = zeros(131,131,3,cur_batch_len,'uint8');

        for f=batch_start:batch_end
          %i = f - batch_start +1;   
          rgbImg = imdb.images.data(:,:,:,f);
          gray = rgb2gray(rgbImg);
          gray2 = imgaussfilt(gray,0.5);
          gray3 = imgaussfilt(gray,1);

%           figure;
%           subplot(1,3,1);
%           imshow(gray);
%           subplot(1,3,2);
%           imshow(gray2);
%           subplot(1,3,3);
%           imshow(gray3);
          
          imdb.images.data(:,:,1,f) = gray;
          imdb.images.data(:,:,2,f) = gray2;
          imdb.images.data(:,:,3,f) = gray3;

          
          

        end
        
   
    end
    
    imdb.images.dataMean = mean(imdb.images.data(:,:,:,find(imdb.images.set == 1)), 4);
    imdb.images.dataStd   =  std(single(imdb.images.data(:,:,:,find(imdb.images.set == 1))),0, 4);

    save(imdb_target_file, 'imdb', '-v7.3');
    %save(imdb_target_file, 'imdb', '-v7.3');
end

