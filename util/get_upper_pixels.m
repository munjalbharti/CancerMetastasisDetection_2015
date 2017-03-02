function[x_total,y_total] = get_upper_pixels(x,y, count)
 %Returns the indices of top left points from (y,x)      
       width = sqrt(count);
       height=width;
       x_total=[];
       y_total=[];
       
       for k=1:size(x)              
           x_upper=[(x(k,1)-width+1:x(k,1))];
           y_upper=[(y(k,1)-height+1:y(k,1))];
         
           x_y_comb= combvec(x_upper,y_upper);
         
           x_total=[x_total; x_y_comb(1,:)'];
           y_total=[y_total; x_y_comb(2,:)'];
       end
end 
