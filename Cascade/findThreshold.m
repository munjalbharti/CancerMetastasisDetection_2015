function [ thresholdProb ] = findThreshold( layer_obj,expectedRecall )
%FINDTHRESHOLD Find the threshold probability 
% Find the threshold probability by evaluating the net at all
% tumor locs in the train slides and find the min probability such that
% expectedRecall(percentage of true positives that gets passed) is obtained

LoadDefaults;
sample_size=33 ;
level=layer_obj.level;
all_locs_count =0 ;
for slide_no=train_slide_indexes_tumor          
    mask=ReadMask(get_slide_name( slide_no,true ),level);
    all_locs_count= all_locs_count + length(find(mask));        
end 

perct_skipped=(1-expectedRecall);
points_skipped_count=ceil(perct_skipped * all_locs_count);

min_probs=ones(points_skipped_count,1);

for slide_no=train_slide_indexes_tumor  
    
    fprintf('\nWorking on slide %d',slide_no);
    
    slide = get_slide(slide_no,true);
    slide_name = get_slide_name( slide_no,true );
    
    [tum_locs_x,tum_locs_y] = findTumorIndices(slide_name,level);
    
    loc_probs=layer_obj.evaluate(slide,tum_locs_x,tum_locs_y,sample_size);  
    curr_min_props=min_x_probs(loc_probs, min(points_skipped_count,length(loc_probs))) ;     
    
    probs=[min_probs; curr_min_props];
    min_probs=min_x_probs(probs,points_skipped_count);   
end 

thresholdProb=max(min_probs);


end

function[probs]=min_x_probs(probs, x)
        [sort_probs,~] = sort(probs(:));
         probs=sort_probs(1:x);       
end 
  