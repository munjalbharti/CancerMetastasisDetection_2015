function [ ] = writeImageBatch( path_prefix,isPositive,slide_name,I,center_x,center_y)
%WRITEIMAGE Save image batch to disk 
batch_size = size(I,4);

for i=1:batch_size
    writeImage( path_prefix,isPositive,slide_name,I(:,:,:,i),center_x(i),center_y(i));
end

end

