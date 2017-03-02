function [ slide] = get_slide( slide_index,isTumor)
%GET_SLIDE Returns slide for the for slide index of Tumor or normal slides
if(nargin == 1)   
     slide_path = get_slide_path(slide_index);    
else
     slide_path = get_slide_path(slide_index,isTumor);      
end
    
    slide = OpenSlide(slide_path);

%if(ispc)
    % Open slide to be used for windows  
   % slide_path = get_slide_path(slide_index,isTumor);
   % slide = OpenSlide(slide_path);
%else
 %   slide_path = get_slide_path(slide_index,isTumor);
  %  slide = OpenSlide(slide_path);
    
    % Tepis Slide to be used for Linux
    %slide_id = get_slide_id(slide_index,isTumor);
    %slide = TepisSlide(slide_id);
%end

end