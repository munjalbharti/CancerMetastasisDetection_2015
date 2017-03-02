function response = classifyBatch( net, data, isDag )
%CLASSIFYBATCH Given a batch of images, classify them all at once and
%return a matrix of responses
opts.gpu=false;

    if nargin < 2
        isDag = false;    
    end 
	if ~isDag

		res = vl_simplenn(net, data,[],[],'mode','test');
		response = squeeze(res(end).x(1,1,:,:));
    else
        net.mode = 'test' ;
        
        if opts.gpu
            data=gpuArray(data);
        end


		net.eval({'data', data})
        response = net.vars(net.getVarIndex('prob')).value ;
        response = squeeze(gather(response)) ;
	end    
end

