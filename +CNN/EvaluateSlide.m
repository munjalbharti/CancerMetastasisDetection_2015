function [ responses,centers_x,centers_y ] = EvaluateSlide( net,slide,slide_name,opts )
%EVALUATESLIDE Evaluates the slide using the net 
%Evaluate all pixels found in stained region

     level=opts.level ;
     sample_size =opts.sample_size ;
     
     ws_img_size = slide.PixelSize(level,:);
     height=ws_img_size(2);
     width=ws_img_size(1);
     transformation_id=8;

     I = slide.getImagePixelData(0, 0, width, height,'level',level-1);
     I_trans=transform_image(I,transformation_id);

    trans_img_size(1)= size(I_trans,2);
    trans_img_size(2)= size(I_trans,1);
    trans_img_size(3)= size(I_trans,3);

  
    % Get location otsu
    [stained_x,stained_y] = get_image_stained_region(I_trans);
    [stained_x,stained_y] = remove_invalid_patch_points(stained_x,stained_y, trans_img_size, sample_size );
   
    resp = CNN.EvaluateImageInBatch(net,slide,I_trans,slide_name,level,stained_x,stained_y,sample_size);

    cent_x=stained_x;
    cent_y=stained_y;

    S = sparse(cent_y,cent_x,double(resp),trans_img_size(2),trans_img_size(1));
    [centers_y,centers_x,responses]= find(rev_transform(S,transformation_id));

end


