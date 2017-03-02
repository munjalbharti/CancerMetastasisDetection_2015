function [ S_rev ] = rev_transform( S,case_id )
%Applies reverse transformation to the sparse response map S

            resp=full(S);
            
            if(case_id==1)
                resp_trans=resp;
            elseif (case_id==2)
                resp_trans=imrotate(resp,-90);
            elseif (case_id==3)
                resp_trans=imrotate(resp,-180);
            elseif (case_id==4)
                resp_trans=imrotate(resp,-270);
            elseif (case_id==5)
                resp_trans=fliplr(resp);
            elseif (case_id==6)
                resp_trans=imrotate(resp,-90);
                resp_trans=fliplr(resp_trans);
            elseif (case_id == 7)   
                resp_trans=imrotate(resp,-180);
                resp_trans=fliplr(resp_trans);
             elseif (case_id == 8)
                 resp_trans=imrotate(resp,-270);
                 resp_trans=fliplr(resp_trans);
            end 
            
            S_rev=sparse(resp_trans);


end

