function [ X,Y,prob ] = RMPostProcess2( rm,rm_level)
%RMPOSTPROCESS7 Post process the response maps

%Smooth the response map using disk filter
%Apply adaptive non maximal supression

filt = fspecial('disk', 7);
I = rm;
Ig = imfilter(I,filt,'same');

b=Ig;
BW2 = imregionalmax(b);
s = regionprops(BW2, Ig, {'Centroid','WeightedCentroid','MajorAxisLength',...
    'MaxIntensity'});

numObj = numel(s);
disp('Num Regions');
disp(numObj);


prob = [];
X = [];
Y = [];
for k = 1 : numObj
        X = [X;s(k).WeightedCentroid(1)];
        Y = [Y;s(k).WeightedCentroid(2)];
        prob = [prob;s(k).MaxIntensity];
end
hold off


[sort_prob,s_idxs] = sort(prob,'descend');
points = [X(s_idxs),Y(s_idxs)];

selected_prob=[];
selected_points=[];

threshold_dist = 13;

while ~isempty(points)
    curr_point = points(1,:);
    curr_prob = sort_prob(1);
    selected_points = [selected_points;curr_point];
    selected_prob = [selected_prob;curr_prob];

    points = points(2:end,:);
    sort_prob = sort_prob(2:end);
    
    dist_mat = pdist2(curr_point,points);
    idx_less_thresh = find(dist_mat < threshold_dist);

    %Remove points less than threshold
    sort_prob = sort_prob(setdiff(1:end,idx_less_thresh));
    points = points(setdiff(1:end,idx_less_thresh),:);
end


disp('Num Selected');
disp(numel(selected_prob));

 X = selected_points(:,1);
 Y = selected_points(:,2);
 prob = selected_prob;


end

