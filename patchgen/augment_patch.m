function [ augmentations ] = augment_patch( I)
%AUGMENT_PA Summary of this function goes here
%   Detailed explanation goes here

patchsize=size(I,1);


I_flipped=fliplr(I);
count=1;
augmentations(:,:,:,count)=I_flipped;
count=count+1;

rotations=[45 90 180 270];
%rotations=[180];
patchsize_half=floor(patchsize/2);
I_padded = padarray(I, [floor(patchsize/2),floor(patchsize/2)], 'symmetric');
  
for r =rotations
    I_rot1=imrotate(I_padded,r,'crop');
    center_point=[floor(size(I_padded,1)/2)+1, floor(size(I_padded,2)/2)+1];
  
    patch = I_rot1(center_point(1)-patchsize_half:center_point(1)+patchsize_half,...
        center_point(2)-patchsize_half:center_point(2)+patchsize_half, :);

    augmentations(:,:,:,count)=patch;
    count=count+1;
end 



end
