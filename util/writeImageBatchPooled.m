function [ ] = writeImageBatchPooled( path_prefix,isPositive,slide_name,I,center_x,center_y)
%write image batch to disk parallely

batch_size = size(I,4);
parfor (i=1:batch_size, 10)
    writeImage( path_prefix,isPositive,slide_name,I(:,:,:,i),center_x(i),center_y(i));
end

end

