% Evaluate vthe net on the test patches of the IMDB
run ../SetupCamelyon.m
CNN_opts;

net_loc = '../data/camelyonl4-net2-L-005-adagrad-M-9-Val100-Batch-500-boundary/net-epoch-100.mat';
imdb_loc=fullfile('F:','CamelyonTrainingData','imdb','camlyon_500k_500k-L4-boundary-loaded-1.imdb2.mat');
%'../data/camelyon/net-epoch-30.mat'
net = CNN.load(net_loc);

%IMDB.load('../../../data/mitosisfp_unbalanced_s033_p33x33_r10.imdb.mat');
imdb = IMDB.load(imdb_loc);
net.layers{end}.type = 'softmax'; % Change the last layer to softmax for classification in order to output class probabilities
batch_size = 1000;

%% CONSTANTS
POSITIVE_CLASS_LABEL = 1;
NEGATIVE_CLASS_LABEL = 2;

%% Variables to hold statistics
Eval = CNN.EvalStruct();
%% ----------------------------

imdb_set3 = find(imdb.images.set == 2);
length_test_set = length(imdb_set3);

%% Dont need randperm for testing
%ridx = randperm(min(10000, length(imdb_set3)));
num_batches = length_test_set/batch_size;
for i=1:num_batches
    start_loc = ((i-1)*batch_size)+1;
    end_loc = min(i*batch_size,length_test_set);
    

    batch_indexes = imdb_set3(start_loc:end_loc);
    labels_groundtruth = imdb.images.labels(1,imdb_set3(start_loc:end_loc));

    [batch_images,batch_labels] = opts.getBatchFunction(imdb,batch_indexes);

    responses = CNN.classifyBatch( net, batch_images);

    
    % Correct this to check responses
    labels_responses = 1 + (responses(1,:) > 0.5); % 2 means mitosis
    [prob_sort,lab_res] = sort(responses,1,'descend');
    labels_responses = lab_res(1,:);
    probabilities=prob_sort(1,:);
    
    
    eval_positive_indexes = find(labels_responses==POSITIVE_CLASS_LABEL);
    eval_negative_indexes = find(labels_responses==NEGATIVE_CLASS_LABEL);

    gt_positive_indexes = find(labels_groundtruth == POSITIVE_CLASS_LABEL);
    gt_negative_indexes = find(labels_groundtruth == NEGATIVE_CLASS_LABEL);
    
    tp = length(intersect(eval_positive_indexes,gt_positive_indexes));
    tn = length(intersect(eval_negative_indexes,gt_negative_indexes));
    fp = length(setdiff(eval_positive_indexes,gt_positive_indexes));
    fn = length(setdiff(eval_negative_indexes,gt_negative_indexes));
    p  = length(gt_positive_indexes);
    n  = length(gt_negative_indexes);
    
    Eval.TP = Eval.TP + tp;
    Eval.TN = Eval.TN + tn;
    Eval.FP = Eval.FP + fp;
    Eval.FN = Eval.FN + fn;
    Eval.P = Eval.P + p;
    Eval.N = Eval.N + n;
    errors = (labels_responses ~= labels_groundtruth);
    
end

Eval = computeResults(Eval);
disp(Eval);
