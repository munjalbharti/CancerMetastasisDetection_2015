function [ sx,sy ] = get_image_stained_region(I)

        l = graythresh(I);
        stain_mask= im2bw(I,l);

        %Reversing the image..1 replaced by 0..0 replaced by 1 to find connected components
        stain_mask_rev=~stain_mask;
        stain_mask_conn= get_connected_components(stain_mask_rev);

        [sy,sx] = find(stain_mask_conn==1);

end