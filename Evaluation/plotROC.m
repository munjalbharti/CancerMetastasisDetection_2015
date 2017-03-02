function [ f ] = plotROC( total_TPR,total_FPR,result_dir_prefix)
%PLOTROC Summary of this function goes here
% This function plots the ROC curve
%
% Input:
% total_TPR:  

% total_FPR: 

f=figure;
aug_TPR = [1,total_TPR,0];
aug_FPR = [1,total_FPR,0];
plot(aug_FPR,aug_TPR,'LineWidth',6);
title('Receiver operating characteristic curve')
xlabel('False Positive Rate')
ylabel('True Positive Rate')
xlim([0 1]);
ylim([0 1]);
refline(1,0)


    auc_calc = 0.5*sum( (aug_FPR(2:end)-aug_FPR(1:end-1)).*(aug_TPR(2:end)+aug_TPR(1:end-1)) );
    auc= abs(auc_calc);
    legend_string_1=sprintf(' AUC :: %f',auc);
 
 
legend(legend_string_1);
file_roc_png = fullfile(result_dir_prefix,'plot_roc.png');
file_roc_fig = fullfile(result_dir_prefix,'plot_roc_fig.fig');

saveas(f,file_roc_png);
savefig(f,file_roc_fig);



