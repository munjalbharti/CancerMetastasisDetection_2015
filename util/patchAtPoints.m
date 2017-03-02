function [ Patches] = patchAtPoints( slide, level,center_x,center_y,size )
%PATCHATPOINT Returns a patch centered at the given points froma given slide
%   level - Assuming the topmost level is 1
        
        %%TODO: Check Images are not stored properly if not using uint8
        Patches  = uint8(zeros(size,size,3,numel(center_x)));
        half_patch_size = floor(size/2);
        
        for i=1:numel(center_x)
            top_left_x = center_x(i) - half_patch_size;
            top_left_y = center_y(i) - half_patch_size;
            Patches(:,:,:,i) = slide.getImagePixelData(top_left_x-1,...
                top_left_y-1, size, size,'level',level-1);
                        
        end
end

