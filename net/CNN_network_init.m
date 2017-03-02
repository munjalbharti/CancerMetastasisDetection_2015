function net = CNN_network_init(varargin)
% CNN_IMAGENET_INIT  Initialize a standard CNN for ImageNet

opts.scale = 0.1 ;
opts.initBias = 0.1 ;
opts.weightDecay = 1 ;
opts.weightInitMethod = 'xavierimproved' ;
%opts.weightInitMethod = 'gaussian' ;
opts.model = 'default' ;
opts.batchNormalization = false ;
opts.networkType = 'simplenn' ;
opts.cudnnWorkspaceLimit = 1024*1024*1204 ; % 1GB
opts = vl_argparse(opts, varargin) ;

% Define layers
switch opts.model
  case 'net2'
    net.meta.normalization.imageSize = [33, 33, 3] ;
    net = net2(net, opts) ;
  case 'net3'
    net.meta.normalization.imageSize = [33, 33, 3] ;
    net = net3(net, opts) ;    
  case 'net4'
    net.meta.normalization.imageSize = [33, 33, 3] ;
    net = net4(net, opts) ;  
  case 'netl4-2'
    net.meta.normalization.imageSize = [33, 33, 3] ;
    net = net131px_2(net, opts) ;  
end

% final touches
switch lower(opts.weightInitMethod)
  case {'xavier', 'xavierimproved'}
    net.layers{end}.weights{1} = net.layers{end}.weights{1} / 10 ;
end
net.layers{end+1} = struct('type', 'softmaxloss', 'name', 'loss') ;



% Fill in default values
net = vl_simplenn_tidy(net) ;
end

% --------------------------------------------------------------------
function net = add_block(net, opts, id, h, w, in, out, stride, pad, init_bias)
% --------------------------------------------------------------------
info = vl_simplenn_display(net) ;
fc = (h == info.dataSize(1,end) && w == info.dataSize(2,end)) ;
if fc
  name = 'fc' ;
else
  name = 'conv' ;
end
convOpts = {'CudnnWorkspaceLimit', opts.cudnnWorkspaceLimit} ;
net.layers{end+1} = struct('type', 'conv', 'name', sprintf('%s%s', name, id), ...
                           'weights', {{init_weight(opts, h, w, in, out, 'single'), zeros(out, 1, 'single')}}, ...
                           'stride', stride, ...
                           'pad', pad, ...
                           'learningRate', [1 2], ...
                           'weightDecay', [opts.weightDecay 0], ...
                           'opts', {convOpts}) ;
if opts.batchNormalization
  net.layers{end+1} = struct('type', 'bnorm', 'name', sprintf('bn%d',id), ...
                             'weights', {{ones(out, 1, 'single'), zeros(out, 1, 'single'), zeros(out, 2, 'single')}}, ...
                             'learningRate', [2 1 0.05], ...
                             'weightDecay', [0 0]) ;
end
net.layers{end+1} = struct('type', 'relu', 'name', sprintf('relu%s',id)) ;
end
% -------------------------------------------------------------------------
function weights = init_weight(opts, h, w, in, out, type)
% -------------------------------------------------------------------------
% See K. He, X. Zhang, S. Ren, and J. Sun. Delving deep into
% rectifiers: Surpassing human-level performance on imagenet
% classification. CoRR, (arXiv:1502.01852v1), 2015.

switch lower(opts.weightInitMethod)
  case 'gaussian'
    sc = 0.01/opts.scale ;
    weights = randn(h, w, in, out, type)*sc;
  case 'xavier'
    sc = sqrt(3/(h*w*in)) ;
    weights = (rand(h, w, in, out, type)*2 - 1)*sc ;
  case 'xavierimproved'
    sc = sqrt(2/(h*w*out)) ;
    weights = randn(h, w, in, out, type)*sc ;
  otherwise
    error('Unknown weight initialization method''%s''', opts.weightInitMethod) ;
end
end
% --------------------------------------------------------------------
function net = add_norm(net, opts, id)
% --------------------------------------------------------------------
if ~opts.batchNormalization
  net.layers{end+1} = struct('type', 'normalize', ...
                             'name', sprintf('norm%s', id), ...
                             'param', [5 1 0.0001/5 0.75]) ;
end
end
% --------------------------------------------------------------------
function net = add_dropout(net, opts, id)
% --------------------------------------------------------------------
if ~opts.batchNormalization
  net.layers{end+1} = struct('type', 'dropout', ...
                             'name', sprintf('dropout%s', id), ...
                             'rate', 0.5) ;
end
end

function [net]= net2(net,opts)
%% Architecture of the network
% Layer 0: Input Layer, 3 channels @ 33x33px
% Layer 1: Convolution Layer  2x2 filters, 16 channels @ 32x32px
% Layer 2: MaxPooling Layer 2x2 filters, 16 channels @ 16x16px,
% Layer 3: Convolution Layer 3x3 filters, 16 channels @ 14x14px,
% Layer 4: MaxPooling Layer 2x2 filters, 16 channels @ 7x7px, 
% Layer 5: Convolution Layer 4x4 filters, 16 channels @ 4x4px, 
% Layer 6: MaxPooling Layer 2x2 filters, 16 channels @ 2x2px
% Layer 7: Fully Connected , 100 neurons
% Layer 8: Fully Connected , 100 neurons
% Layer 9: Fully Connected , 2 neurons
  
    
net.layers = {} ;
net = add_block(net, opts, '1', 2, 2, 3, 16, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool2', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
net = add_block(net, opts, '3', 3, 3, 16, 16, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool4', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
net = add_block(net, opts, '5', 4, 4, 16, 16, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool6', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;  
                       
net = add_block(net, opts, '7', 2, 2, 16, 100, 1, 0) ;
net = add_dropout(net, opts, '7') ;
net = add_block(net, opts, '8', 1, 1, 100, 100, 1, 0) ;
net = add_dropout(net, opts, '8') ;
net = add_block(net, opts, '9', 1, 1, 100, 2, 1, 0) ;

net.layers(end) = [] ;
if opts.batchNormalization, net.layers(end) = [] ; end                     
end


function [net]= net3(net,opts)
%% Architecture of the network
% Layer 0: Input Layer, 3 channels @ 33x33px
% Layer 1: Convolution Layer  2x2 filters, 16 channels @ 32x32px
% Layer 2: MaxPooling Layer 2x2 filters, 16 channels @ 16x16px,
% Layer 3: Convolution Layer 3x3 filters, 16 channels @ 16x16px,
% Layer 4: Convolution Layer 3x3 filters, 16 channels @ 16x16px,
% Layer 5: Convolution Layer 3x3 filters, 16 channels @ 14x14px,
% Layer 6: MaxPooling Layer 2x2 filters, 16 channels @ 7x7px, 
% Layer 7: Convolution Layer 4x4 filters, 16 channels @ 4x4px, 
% Layer 8: MaxPooling Layer 2x2 filters, 16 channels @ 2x2px
% Layer 9: Fully Connected , 100 neurons
% Layer 10: Fully Connected , 100 neurons
% Layer 11: Fully Connected , 2 neurons
  
net.layers = {} ;
net = add_block(net, opts, '1', 2, 2, 3, 16, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool2', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
net = add_block(net, opts, '3', 3, 3, 16, 16, 1, [1,1,1,1]) ;
net = add_block(net, opts, '4', 3, 3, 16, 16, 1, [1,1,1,1]) ;
net = add_block(net, opts, '5', 3, 3, 16, 16, 1, 0) ;

net.layers{end+1} = struct('type', 'pool', 'name', 'pool6', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
net = add_block(net, opts, '7', 4, 4, 16, 16, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool8', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;  
                       
net = add_block(net, opts, '9', 2, 2, 16, 100, 1, 0) ;
net = add_dropout(net, opts, '9') ;
net = add_block(net, opts, '10', 1, 1, 100, 100, 1, 0) ;
net = add_dropout(net, opts, '10') ;
net = add_block(net, opts, '11', 1, 1, 100, 2, 1, 0) ;

net.layers(end) = [] ;
if opts.batchNormalization, net.layers(end) = [] ; end                     
end

function [net]= net4(net,opts)
%% Architecture of the network
% Layer 0: Input Layer, 3 channels @ 33x33px
% Layer 1: Convolution Layer  2x2 filters, 16 channels @ 32x32px
% Layer 2: MaxPooling Layer 2x2 filters, @ 16x16px,
% Layer 3: Convolution Layer 3x3 filters,24 channels @ 14x14px,
% Layer 4: MaxPooling Layer 2x2 filters, @ 7x7px, 
% Layer 5: Convolution Layer 4x4 filters,36 channels @ 4x4px, 
% Layer 6: MaxPooling Layer 2x2 filters, @ 2x2px
% Layer 7: Fully Connected , 100 neurons
% Layer 8: Fully Connected , 150 neurons
% Layer 9: Fully Connected , 2 neurons
  
net.layers = {} ;
net = add_block(net, opts, '1', 2, 2, 3, 16, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool2', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
net = add_block(net, opts, '3', 3, 3, 16, 24, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool4', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
net = add_block(net, opts, '5', 4, 4, 24, 36, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool6', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;  
                       
net = add_block(net, opts, '7', 2, 2, 36, 100, 1, 0) ;
net = add_dropout(net, opts, '7') ;
net = add_block(net, opts, '8', 1, 1, 100, 150, 1, 0) ;
net = add_dropout(net, opts, '8') ;
net = add_block(net, opts, '9', 1, 1, 150, 2, 1, 0) ;

net.layers(end) = [] ;
if opts.batchNormalization, net.layers(end) = [] ; end                     
end

function [net]= net131px_2(net,opts)
%% Architecture of the network
% Layer 0: Input Layer, 3 channels @ 131x131px
% Layer 1: Convolution Layer  2x2 filters, 16 channels @ 130x130px
% Layer 2: MaxPooling Layer 2x2 filters,  @ 65x65px,
% Layer 3: Convolution Layer  2x2 filters, 16 channels @ 64x64px
% Layer 4: MaxPooling Layer 2x2 filters,  @ 32x32px,
% Layer 5: Convolution Layer  3x3 filters, 16 channels @ 30x30px
% Layer 6: MaxPooling Layer 2x2 filters,  @ 15x15px,
% Layer 7: Convolution Layer 2x2 filters, 16 channels @ 14x14px,
% Layer 8: MaxPooling Layer 2x2 filters, 16 channels @ 7x7px, 
% Layer 9: Convolution Layer 4x4 filters, 16 channels @ 4x4px, 
% Layer 10: MaxPooling Layer 2x2 filters, 16 channels @ 2x2px
% Layer 11: Fully Connected , 100 neurons
% Layer 12: Fully Connected , 100 neurons
% Layer 13: Fully Connected , 2 neurons
  
net.layers = {} ;
net = add_block(net, opts, '1', 2, 2, 3, 16, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool2', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
net = add_block(net, opts, '3', 2, 2, 16, 16, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool4', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
net = add_block(net, opts, '5', 3, 3, 16, 16, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool6', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;                       
net = add_block(net, opts, '7', 2, 2, 16, 16, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool8', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;
net = add_block(net, opts, '9', 4, 4, 16, 16, 1, 0) ;
net.layers{end+1} = struct('type', 'pool', 'name', 'pool10', ...
                           'method', 'max', ...
                           'pool', [2 2], ...
                           'stride', 2, ...
                           'pad', 0) ;  
                       
net = add_block(net, opts, '11', 2, 2, 16, 100, 1, 0) ;
net = add_dropout(net, opts, '11') ;
net = add_block(net, opts, '12', 1, 1, 100, 100, 1, 0) ;
net = add_dropout(net, opts, '12') ;
net = add_block(net, opts, '13', 1, 1, 100, 2, 1, 0) ;

net.layers(end) = [] ;
if opts.batchNormalization, net.layers(end) = [] ; end                     
end