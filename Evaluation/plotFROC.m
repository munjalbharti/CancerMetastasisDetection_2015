function plotFROC(total_FPs, total_sensitivity,result_dir_prefix)
% This function plots the FROC curve
%
% Input:
% total_FPs:    an array containing the average number of false positives 
%         per image for different thresholds;
%
% total_sensitivity: an array containing overall sensitivity of the system 
%         for different thresholds;

f_froc=figure, plot(total_FPs, total_sensitivity)
title('Free response receiver operating characteristic curve')
xlabel('Average Number of False Positives')
ylabel('Metastasis detection sensitivity')
avg = getCPM(total_FPs, total_sensitivity);
sensitivity_legend = sprintf('Avg : %f',avg);
legend(sensitivity_legend);

file_froc_png = fullfile(result_dir_prefix,'plot_froc.png');
file_froc_fig = fullfile(result_dir_prefix,'plot_froc_fig.fig');

saveas(f_froc,file_froc_png);
savefig(f_froc,file_froc_fig);

end
function [avg]= getCPM(total_FPs, total_sensitivity)
fixed_fps = [0.25,0.5,1,2,4,8];
fixed_sens = zeros(size(fixed_fps));
sel_fps = zeros(size(fixed_fps));
for i=1:numel(fixed_fps)
    diffPrior = max(max(total_FPs),1000);
    fix_fp = fixed_fps(i);
    for j=1:numel(total_FPs)
        diffCurr = abs(total_FPs(j) - fix_fp);
        if (diffCurr < diffPrior)
            diffPrior = diffCurr;
            fixed_sens(i) = total_sensitivity(j);  
            sel_fps(i) = total_FPs(j);
        end
    end

end
disp('Selected FPs');
disp(sel_fps);
disp('Fixed Sensitivity');
disp(fixed_sens);
avg = mean(fixed_sens);



end