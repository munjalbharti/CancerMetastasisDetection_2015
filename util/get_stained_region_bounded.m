function [ tx,ty ] = get_stained_region_bounded(slide,level )
%GET_STAINED_REGION_BOUNDED Returns the locations of stained region
% Discards the top bottom noisy areas generally found in slide


    [tx,ty] = get_stained_region(slide, level);
    
     ws_img_size = slide.PixelSize(level,:);
    [tx,ty]=skip_top_bottom_pixels(tx,ty,ws_img_size);
end

