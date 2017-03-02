function [ responses,centers_x,centers_y,res_img_width, res_img_height ] = EvaluateSlide3( net,slide,slide_name,opts)
%EVALUATESLIDE3
%Evaluates the slide using the net and returns a downscaled response
%Stained points at level are found by interpolating point from the lower
%level

    % Default downscaled response level
    response_level = 7;
     
    level=opts.level ;
    sample_size =opts.sample_size ;
     
    transformation_id=1;

    % For determining evaluation points
    res_img_size = slide.PixelSize(response_level,:);
    res_img_height= res_img_size(2);
    res_img_width= res_img_size(1);
    I = slide.getImagePixelData(0, 0, res_img_width, res_img_height,'level',response_level-1);
    I_trans=transform_image(I,transformation_id);

    trans_img_size(1)= size(I_trans,2);
    trans_img_size(2)= size(I_trans,1);
    trans_img_size(3)= size(I_trans,3);

    % For evaluation
    ws_img_size = slide.PixelSize(level,:);
    height=ws_img_size(2);
    width=ws_img_size(1);
    Eval_I = slide.getImagePixelData(0, 0, width, height,'level',level-1);
    Eval_I_trans=transform_image(Eval_I,transformation_id);
    
  
    % Get location otsu
    [stained_x,stained_y] = get_image_stained_region(I_trans);
    [stained_x,stained_y] = remove_invalid_patch_points(stained_x,stained_y, trans_img_size, sample_size );
  

    [interp_stained_x,interp_stained_y] = interpolateApproxCenter( stained_x,stained_y, response_level,level);
    resp = CNN.EvaluateImageInBatch(net,slide,Eval_I_trans,slide_name,interp_stained_x,interp_stained_y,opts);

    cent_x=stained_x;
    cent_y=stained_y;

    S = sparse(cent_y,cent_x,double(resp),trans_img_size(2),trans_img_size(1));
    [centers_y,centers_x,responses]= find(rev_transform(S,transformation_id));

end


