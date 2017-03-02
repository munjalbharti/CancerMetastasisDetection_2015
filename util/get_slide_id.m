function [ slide_id ] = get_slide_id( slide_index,isTumor )
%GET_SLIDE_ID returns slideId for a given slide index

if(isTumor)
    slide_id = tumor_slide_list.Var2{slide_index};
else
    slide_id = normal_slide_list.Var2{slide_index};
end

end

