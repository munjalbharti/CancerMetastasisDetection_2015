function [ X,Y,prob ] = RMPostProcess3( rm )
%RMPOSTPROCESS3 

%Applies gaussian
%Thresholding and non-maximal supression

filt_g = fspecial('gaussian', [33 33], 8);

Ig = imfilter(rm,filt_g,'same');


Ig(find(Ig <=0.5)) = 0;


tmp_img = Ig > imdilate(Ig, [1 1 1; 1 0 1; 1 1 1]);

[y, x] = find(tmp_img ==1);

prob = zeros(size(x,1),1);
for k = 1 : size(x,1)
    prob(k) = Ig(y(k,1),x(k,1));
end
X = x;
Y = y;


end

