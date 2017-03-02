function [ x_p, y_p] = interpolateApproxCenter( x,y, src_level,target_level  )
%INTERPOLATEAPPROXCENTER - Returns the indices of approximate center pixel 
% at target level corresponding to any pixel at src_level 

 [x_p,y_p]=interpolateCoordinatesByLevel(x,y,src_level,target_level);
   
 if(src_level > target_level)
     p=2^(src_level-target_level -1);
     x_p = x_p - p;
     y_p = y_p - p;
 end 
       
end

