function [ GM ] = calculate_GM_for_response_maps( response_maps )


GM=prod(response_maps,3);

%if (size(Response_Map1) == size(Response_Map2)) 
%   GM = Response_Map1 .* Response_Map2;    
%else 
%    fprintf('Response maps have different sizes. Cannot calculate gemoetric mean');
%end 

end

