close all;
clear ;


epoch=200 ;
level1=7 ;
level2=7;
sample_size=33 ;
target_folder = 'F:\CamelyonTrainingData\Level7\camelyonl7-net2-L-001-adagrad-Val200-Batch-500-Cascade\Negative\';

net1 = CNN.load(['..' filesep 'data' filesep 'camelyonl7-net2-L-001-adagrad-Val200-Batch-500' filesep sprintf('net-epoch-%d.mat',epoch)]);
net1.layers{end}.type = 'softmax'; 


% Set the expected recall here
expected_recall=0.99 ;


one_layer_obj=OneLayer(net1,level1);

% Find threshold for the given expected recall
cutOffThreshold=findThreshold(one_layer_obj,expected_recall);
fprintf('Threshold found is %f',cutOffThreshold);

generatePatchesCascade(one_layer_obj,target_folder,cutOffThreshold,level2);


