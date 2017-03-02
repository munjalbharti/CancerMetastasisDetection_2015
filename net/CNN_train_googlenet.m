% Clean up
close all;
clear;

% Do not forget to run Setup first!
run ../SetupCamelyon.m

% Options
CNN_opts;

% Create the net
net=CNN_googlenet_init();

% 1. Load the IMDB file containing all patches
imdb = IMDB.load(opts.imdbPath);

% 2. Learn on the complete IMDB in 30 epochs
% As stated in the paper, non-mitosis patches are mostly easy-to-classify
% background. We are interested in learning a net which can classifiy
% between mitosis and hard-to-classify non-mitosis patches, hence we have
% to create an appropriate training dataset. For this purpose, we first
% learn a CNN, find false positives and then refine the CNN

[net,info] = CNN.train_dag(net, imdb, opts.getBatchFunction, ...,
                       'expDir', opts.train.expDir, ...
                       'batchSize', opts.train.batchSize, ...
                       'numEpochs', opts.train.numEpochs, ...
                       'continue', opts.train.continue, ...
                       'gpus', opts.train.gpus, ...
                       'learningRate', opts.train.learningRate, ...
                       'weightDecay', opts.train.weightDecay, ...
                       'momentum', opts.train.momentum, ...
                       'numSubBatches',opts.train.numSubBatches, ...
                       'derOutputs',{'objective',1,'objective1', 0.3, 'objective2', 0.3});

% Plot progress
%vl_simplenn_diagnose(net);
