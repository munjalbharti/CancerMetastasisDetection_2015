function [  ] = generate_boundary_negative_patches( slide_name,slide_index )

opts.sample_size = 224; 
opts.level =4;
opts.num_samples_per_slide = 500;
opts.target_path = fullfile('F:','CamelyonTrainingData','Level4_2k_s_224','Boundary');

close all;

slide = get_slide(slide_index,true);
ws_img_size = slide.PixelSize(opts.level,:);

wsi_fig = figure();
wsi_ax = axes('parent',wsi_fig);

slide.show;
hold on;

[tx,ty] = findBoundaryNonTumorIndices(slide_name, opts.level);
scatter(tx,ty);

[tx,ty]=remove_invalid_patch_points(tx,ty, ws_img_size, opts.sample_size );

ridx = randperm(length(tx));

total_samples_generated = min(length(tx),opts.num_samples_per_slide);
selected_ridx = ridx(1:min(length(tx),opts.num_samples_per_slide));
c_x = tx(selected_ridx);
c_y = ty(selected_ridx);

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
  
end

writePatchesMat( slide_patches,opts.target_path,slide_name,false);


end


