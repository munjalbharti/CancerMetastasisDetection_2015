function [ Eval ] = computeResults( Eval )
%COMPUTERESULTS Summary of this function goes here
%   Detailed explanation goes here

    Eval.precision = Eval.TP/(Eval.TP + Eval.FP); % TP/(TP+FP)
    Eval.recall = Eval.TP/(Eval.TP + Eval.FN); % TP/(TP+FN)
    Eval.fscore = (2 * Eval.precision * Eval.recall)/(Eval.precision + Eval.recall);
    Eval.accuracy = (Eval.TP + Eval.TN) / (Eval.P + Eval.N);
    Eval.error = (Eval.FP + Eval.FN)/(Eval.P + Eval.N);

end

