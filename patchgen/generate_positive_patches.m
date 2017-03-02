function [  ] = generate_positive_patches( slide_name,slide_index )

opts.sample_size = 33; % The size is odd so that we have a center
%opts.stride = 300;
opts.level =7;
%opts.num_samples_per_slide = 20000;
opts.num_samples_per_slide = 3000; %150k/90 because 90 samples are used for training (1:110)


opts.target_path = fullfile('F:','CamelyonTrainingData','Level4_2k_s_224');
close all;

%target_folder = [opts.target_path filesep 'Positive' filesep slide_name];
%mkdir(target_folder);

slide = get_slide(slide_index,true);
ws_img_size = slide.PixelSize(opts.level,:);

wsi_fig = figure();
wsi_ax = axes('parent',wsi_fig);

%imshow(I_lower);
slide.show;
hold on;

[tx,ty] = findTumorIndices(slide_name, opts.level);

%remove points where we dont need to generate patches
[tx,ty]=remove_indices_for_patch(tx,ty, ws_img_size, opts.sample_size );

ridx = randperm(length(tx));



total_samples_generated = min(length(tx),opts.num_samples_per_slide);
selected_ridx = ridx(1:min(length(tx),opts.num_samples_per_slide));
c_x = tx(selected_ridx);
c_y = ty(selected_ridx);


 for i=1:total_samples_generated
     [window_x,window_y]= boundingBox(c_x(i),c_y(i),opts.sample_size);
     [wx,wy] = interpolateCoordinatesByLevel(window_x,window_y, opts.level,1 );
     plot(wsi_ax, wx, wy, 'y', 'LineWidth', 10)
 end

%Patch and Write
batch_size = 1000;
slide_patches=zeros(0,0,0,0,'uint8');

for k=1:batch_size:total_samples_generated
    batch_start = k;
    batch_end = min(batch_start+batch_size -1 ,total_samples_generated);
    bx= c_x(batch_start:batch_end);
    by = c_y(batch_start:batch_end);
    P=patchAtPoints(slide,opts.level,bx,by,opts.sample_size);  
    slide_patches(:,:,:,end+1:end+size(P,4))=uint8(P);
     
    %writeImageBatchPooled(opts.target_path,true,slide_name,P,bx,by);
end

writePatchesMat(slide_patches,opts.target_path,slide_name,true);

% %Save matlab fig for verification
% fig_name = sprintf('Ref-Pos-%s-slide.fig',slide_name);
% savefig(wsi_fig,[opts.target_path filesep 'Positive' filesep slide_name filesep fig_name]);

% while(num_generated<opts.num_samples_per_slide && gen_index<=length(tx))
% 
%     center_x = tx(ridx(gen_index));
%     center_y = ty(ridx(gen_index));
%     
%     image_name = sprintf('Pos_%s_%06d_%06d.tiff',slide_name,center_x,center_y);
%     [window_x,window_y]= boundingBox(center_x,center_y,opts.sample_size);
%     [wx,wy] = interpolateCoordinatesByLevel(window_x,window_y, opts.level,1 );
%  
%     plot(wsi_ax, wx, wy, 'y', 'LineWidth', 10);
%     
%     patch=patchAtPoints(slide, opts.level,center_x,center_y,opts.sample_size );
%     imwrite(patch,[opts.target_path filesep slide_name filesep image_name]);
%     
%     num_generated = num_generated + 1;
%     gen_index = gen_index +1;
%     
% end




end

