function [ net ] = CNN_googlenet_init( varargin )
    
opts.scale = 1;   %for individual learning rates
opts.weightDecay = [1,0];


%% Load googleNet and remove last layers
net = load('imagenet-googlenet-dag.mat');
net = dagnn.DagNN.loadobj(net) ;

print(net);

net.removeLayer('softmax');  %softmax 
net.removeLayer('cls1_fc2');  %last pooling 
net.removeLayer('cls2_fc2');  %last pooling 
net.removeLayer('cls3_fc');  %last pooling 


%n_previous_layers = numel(net.layers);





net.addLayer('cls1_fc2', ...
    dagnn.Conv('size', [1,1,1024,2], 'pad', 0, 'stride', 1), ...
    {'cls1_fc1x'}, ...
    {'cls1_fc2'}, ...
    {'cls1_fc2_filter','cls1_fc2_bias'});

%params=net.layers(net.getLayerIndex('cls1_fc2')).params;
p = net.layers(net.getLayerIndex('cls1_fc2')).paramIndexes ;

%[params.learningRate] = deal(opts.scale, opts.scale);
%[params.weightDecay] = deal(opts.weightDecay(1), opts.weightDecay(1));

params = net.layers(net.getLayerIndex('cls1_fc2')).block.initParams() ;
 switch net.device
    case 'cpu'
      params = cellfun(@gather, params, 'UniformOutput', false) ;
    case 'gpu'
      params = cellfun(@gpuArray, params, 'UniformOutput', false) ;
  end
[net.params(p).value] = deal(params{:}) ;
  
  
net.addLayer('cls2_fc2', ...
    dagnn.Conv('size', [1,1,1024,2], 'pad', 0, 'stride', 1), ...
    {'cls2_fc1x'}, ...
    {'cls2_fc2'}, ...
    {'cls2_fc2_filter','cls2_fc2_bias'});
%params=net.layers(net.getLayerIndex('cls2_fc2')).params;
p = net.layers(net.getLayerIndex('cls2_fc2')).paramIndexes ;

%[params.learningRate] = deal(opts.scale, opts.scale);
%5[params.weightDecay] = deal(opts.weightDecay(1), opts.weightDecay(1));

params = net.layers(net.getLayerIndex('cls2_fc2')).block.initParams() ;
 switch net.device
    case 'cpu'
      params = cellfun(@gather, params, 'UniformOutput', false) ;
    case 'gpu'
      params = cellfun(@gpuArray, params, 'UniformOutput', false) ;
  end
[net.params(p).value] = deal(params{:}) ;



net.addLayer('cls3_fc', ...
    dagnn.Conv('size', [1,1,1024,2], 'pad', 0, 'stride', 1), ...
    {'cls3_pool'}, ...
    {'cls3_fc'}, ...
    {'cls3_fc_filter','cls3_fc_bias'});

%params=net.layers(net.getLayerIndex('cls3_fc')).params;
p = net.layers(net.getLayerIndex('cls3_fc')).paramIndexes ;

%[params.learningRate] = deal(opts.scale, opts.scale);
%[params.weightDecay] = deal(opts.weightDecay(1), opts.weightDecay(1));

params = net.layers(net.getLayerIndex('cls3_fc')).block.initParams() ;
 switch net.device
    case 'cpu'
      params = cellfun(@gather, params, 'UniformOutput', false) ;
    case 'gpu'
      params = cellfun(@gpuArray, params, 'UniformOutput', false) ;
  end
[net.params(p).value] = deal(params{:}) ;


%% Initialize parameters for new layers

%for l = n_previous_layers+1:numel(net.layers)
 % p = net.getParamIndex(net.layers(l).params) ;
  %params = net.layers(l).block.initParams() ;
 % switch net.device
  %  case 'cpu'
   %   params = cellfun(@gather, params, 'UniformOutput', false) ;
  %  case 'gpu'
   %   params = cellfun(@gpuArray, params, 'UniformOutput', false) ;
 % end
 % [net.params(p).value] = deal(params{:}) ;
%end

%% ---------- Loss - Errors -----------------------------------------------

net.addLayer('loss1', dagnn.Loss('loss', 'softmaxlog'),{'cls1_fc2', 'label'}, 'objective1') ;
net.addLayer('loss2', dagnn.Loss('loss', 'softmaxlog'),{'cls2_fc2', 'label'}, 'objective2');
net.addLayer('loss3', dagnn.Loss('loss', 'softmaxlog'),{'cls3_fc', 'label'}, 'objective') ;
net.addLayer('error', dagnn.Loss('loss', 'classerror'), {'cls3_fc','label'}, 'error');

net.addLayer('prob', dagnn.SoftMax(), 'cls3_fc', 'prob', {}) ;     
for l = 1:numel(net.layers)
     p = net.layers(l).paramIndexes ;
     params= net.layers(l).block.initParams() ;
 
     switch net.device
       case 'cpu'
         params = cellfun(@gather, params, 'UniformOutput', false) ;
       case 'gpu'
          params = cellfun(@gpuArray, params, 'UniformOutput', false) ;
     end
     [net.params(p).value] = deal(params{:}) ;
     
 end
end



