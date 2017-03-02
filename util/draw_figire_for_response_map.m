function [ response_map_f ] = draw_figire_for_response_map( slide, name, sparse_response_map, level, is_tumor)
%DRAW_FIGIRE_FOR_RESPONSE_MAP: draws figure of the response map passed


  
    response_map=full(sparse_response_map);
    response_map_f=figure ;
   
    %Original image of this level will be displayed
    level_to_display=7;
    dsp_img_size = slide.PixelSize(level_to_display,:);
    dsp_img_cols=dsp_img_size(1);
    dsp_img_rows=dsp_img_size(2);
   
    I_disp = slide.getImagePixelData(0, 0,  dsp_img_cols, dsp_img_rows,'level',level_to_display -1);
 
    if(nargin == 5 && is_tumor == true)  
      tumor_mask= ReadMask(name,level);
      total_subplots=5;
    else 
       total_subplots=4;
    end

    plot_no=1;
    subplot(1,total_subplots,plot_no);
    imshow(I_disp);
    title('Orig');
    plot_no=plot_no+1;

    if(nargin == 5 && is_tumor == true)
      subplot(1,total_subplots,plot_no);
      imshow(tumor_mask);
      title('Tumor');
      plot_no=plot_no+1;
    end
    
  
    response_map_lower=response_map;
               
    subplot(1,total_subplots,plot_no);
    imshow(response_map_lower);
    title('RM');
    plot_no=plot_no+1;
    
    thresholded_response_map1=response_map_lower;
    thresholded_response_map1(thresholded_response_map1 < 0.5)=0;
    subplot(1,total_subplots,plot_no);
    imshow(thresholded_response_map1);
    colormap(jet);
    title('Th 0.5');
    plot_no=plot_no+1;
    
    thresholded_response_map2=response_map_lower;
    thresholded_response_map2(thresholded_response_map2 < 0.9)=0;
    subplot(1,total_subplots,plot_no);
    imshow(thresholded_response_map2);
    colormap(jet);
    title('Th 0.9');
    plot_no=plot_no+1;
     
    
end

