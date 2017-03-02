function [ slide_name ] = get_slide_name( slide_index,isTumor )
%GET_SLIDE_NAME 

if(nargin ==1)
    slide_name= sprintf('Test_%03d',slide_index);
    return ;
end 

if(isTumor)
    tumor_slide_list = get_tumor_slide_list();
    slide_name = tumor_slide_list.Var1{slide_index};
else
    normal_slide_list = get_normal_slide_list();
    slide_name = normal_slide_list.Var1{slide_index};
end

end

