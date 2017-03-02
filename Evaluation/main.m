run ../SetupCamelyon.m
result_dir_prefix = 'F:\Camelyon\Results\Level_4New\post_process1LesionFeatures\LesionFeatures\ens';
slide_based_csv_output_dir = 'Evaluation1';

generateSlideBasedEvalCSV(result_dir_prefix,slide_based_csv_output_dir);

%Evaluate FROC
evaluation;

%Evaluate ROC
evaluateROC;
