% Options and parameters for the current CNN
opts.imdbPath =  fullfile('F:','CamelyonTrainingData','imdb','camlyon_120k_120k-L4-boundary-loaded.imdb.mat');
%opts.imdbPath = fullfile('F:','CamelyonTrainingData','imdb','camlyon_10_10-L4-boundary-loaded-1-testing1.imdb.mat')
opts.getBatchFunction = @CNN.getBatchLoaded;

%lr = logspace(-1, -4, 30) ;
lr1= ones(1,10)*0.0001 ;
lr2= ones(1,20)*0.00001 ;

lr = [lr1,lr2,0.000001] ;
% Training options

opts.train.expDir = '../data/camelyonl4-120k-googlenet-reinit-L-step-M-9-Batch-32-1/';
opts.train.batchSize = 32;
opts.train.numEpochs = 400;
opts.train.learningRate = lr;
opts.train.weightDecay = 0.0005 ;
opts.train.continue = true;
opts.train.gpus = [1];
opts.train.errorFunction = @CNN.ErrorFn;
opts.train.useGpu= true;
opts.train.momentum = 0.9 ; % this guy should be 0.9 
opts.train.numSubBatches = 4;
% 
% % Refinement options
% opts.refine.d = 30;
% 
% % Eval options
% opts.eval.thresh_coarsePixelwise = 0.9; % Best: 0.9766
% opts.eval.thresh_coarseCC = 0.9892046;
% opts.eval.thresh_refined = 0.08211;
% opts.eval.radius = 30; % 30 px radius for scale 1
