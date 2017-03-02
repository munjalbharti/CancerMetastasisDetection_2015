function [ I_trans ] = transform_image( I,transformation_id )
%TRANSFORM_IMAGE Applies a transformation to a given image given by
%transformation_id

        case_id=transformation_id;

        if(case_id==1)
            I_trans=I;
        elseif (case_id==2)
            I_trans=imrotate(I,90);
        elseif (case_id==3)
            I_trans=imrotate(I,180);
        elseif (case_id==4)
            I_trans=imrotate(I,270);
        elseif (case_id==5)
            I_trans=fliplr(I);
        elseif (case_id==6)
            I_trans=fliplr(I);
            I_trans=imrotate(I_trans,90);
        elseif (case_id == 7)    
            I_trans=fliplr(I);
            I_trans=imrotate(I_trans,180);
        elseif (case_id==8)
            I_trans=fliplr(I);
            I_trans=imrotate(I_trans,270);

        else 
        end 

end

