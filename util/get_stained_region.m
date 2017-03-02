function [ sx,sy ] = get_stained_region( slide, level)
%Returns stained points for a slide at a given level by OTSU thresholding
        ws_img_size = slide.PixelSize(level,:);
        height=ws_img_size(2);
        width=ws_img_size(1);

        I = slide.getImagePixelData(0, 0, width, height,'level',level-1);
        l = graythresh(I);
        stain_mask= im2bw(I,l);

        %Reversing the image..1 replaced by 0..0 replaced by 1 to find connected components
        stain_mask_rev=~stain_mask;
        stain_mask_conn= get_connected_components(stain_mask_rev);

        [sy,sx] = find(stain_mask_conn==1);
        
end
