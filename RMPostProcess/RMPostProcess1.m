function [ X,Y,prob,S ] = RMPostProcess1( rm, level )
%RMPOSTPROCESS Post process the response maps
%   Smooth the response map with gaussian  
%   Segment it by thresholding
%   Find connected components



% Smooth the response map
filt_g = fspecial('gaussian', [5 5], 1);
Ig = imfilter(rm,filt_g,'same');

I_above_t = Ig >0.5;
Ig(find(Ig <=0.5)) = 0;


CC = bwconncomp(I_above_t,8);
S = regionprops(CC,Ig,{'Centroid','WeightedCentroid','MajorAxisLength',...
    'MinorAxisLength','MaxIntensity','MinIntensity','MeanIntensity','PixelValues','PixelIdxList','Orientation','Eccentricity','Area'});

centroids = cat(1, S.Centroid);
prob = zeros(1,CC.NumObjects);
for k = 1 : CC.NumObjects
    region_probs{k} = Ig(CC.PixelIdxList{k}) ;
    prob(k) = max(region_probs{k});
end
if (size(centroids) ==[0,0])
    X=[];
    Y=[];
else
X = centroids(:,1);
Y = centroids(:,2);
end
prob = prob';

end

