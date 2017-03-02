function net = load(path,isDag)
%INIT load and prepare a CNN
%
% @Author: Amil George

if nargin < 2
    isDag = false;    
end 
    
    if isDag
        n=load(path);
        net = dagnn.DagNN.loadobj(n.net) ;
    else
        load(path)
    end

end

