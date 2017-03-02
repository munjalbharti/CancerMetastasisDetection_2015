function [ responses,centers_x,centers_y ] = EvaluateSlide2( net,slide,slide_name,lower_level,lower_response_map,thresh,level, sample_size,transformation_id )
%EVALUATESLIDE Evaluates the slide using the net 
% Only high probabilty points from lower_response_map are evaluated at
% higher level


     ws_img_size = slide.PixelSize(level,:);
     height=ws_img_size(2);
     width=ws_img_size(1);

     I = slide.getImagePixelData(0, 0, width, height,'level',level-1);
     I_trans=transform_image(I,transformation_id);

    trans_img_size(1)= size(I_trans,2);
    trans_img_size(2)= size(I_trans,1);
    trans_img_size(3)= size(I_trans,3);

    
    
    [sx,sy]= get_high_prob_points( lower_response_map, lower_level,level,thresh ) ;
    resp = CNN.EvaluateImageInBatch(net,slide,I_trans,slide_name,level,sx,sy,sample_size);

    cent_x=sx;
    cent_y=sy;

    S = sparse(cent_y,cent_x,double(resp),trans_img_size(2),trans_img_size(1));
    [centers_y,centers_x,responses]= find(rev_transform(S,transformation_id));

end


