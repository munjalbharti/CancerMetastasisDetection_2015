%This script is used to generate RF features from respponse maps
clear;
close all;
run ../SetupCamelyon
LoadDefaults;

result_dir_prefix ='F:\Camelyon\Results\Level_4_Trained_Results_googlenet\';
out_dir1 = 'post_process8LesionFeatures';

level = 7;
out_path_prefix1 = fullfile(result_dir_prefix,out_dir1,'LesionFeatures');

for k=1:2
    if(k == 1)
        type_dir= 'Tumor';
        list =train_slide_indexes_tumor;
        isTumor = true;
    else
        type_dir='Normal';
        list =train_slide_indexes_normal;
        isTumor = false;        
    end
   
    mkdir(fullfile(out_path_prefix1));
    
    for i=list
        slide_name = get_slide_name(i,isTumor);
        res_name = sprintf('%s.mat',slide_name) ; 
        rm_file = fullfile(result_dir_prefix,res_name);
        csv_name = sprintf('%s.csv',res_name(1:end-4));
        csv_file1 = fullfile(out_path_prefix1,csv_name);

        rm = load(rm_file);
        full_rm = full(rm.RM);
        [X1,Y1,prob1,s]= RMPostProcess8(full_rm,level);
        [X1,Y1]= interpolateCoordinatesByLevel(X1,Y1,level,1);
        numObj = numel(s);
        isTP = [];
        area = [];
        majorAxisLength = [];
        minorAxisLength = [];
        orientation = [];
        maxIntensity = [];
        minIntensity = [];
        meanIntensity = [];
        eccentricity=[];
        if(isTumor)
            mask = ReadMask(slide_name,level);    
        end
        for j=1:numObj
            X = s(j).WeightedCentroid(1);
            Y = s(j).WeightedCentroid(2);
            if (isTumor)
                if(mask(round(Y),round(X)) == 0);
                    isTruePositiveLesion = false ;
                else 
                    isTruePositiveLesion= true;
                end  
            else
                    isTruePositiveLesion = false;
            end
            isTP = [isTP;isTruePositiveLesion];
            area = [area;s(j).Area];
            majorAxisLength = [majorAxisLength;s(j).MajorAxisLength];
            minorAxisLength = [minorAxisLength;s(j).MinorAxisLength];
            orientation = [orientation;s(j).Orientation];
            maxIntensity = [maxIntensity;s(j).MaxIntensity];
            minIntensity = [minIntensity;s(j).MinIntensity];
            meanIntensity = [meanIntensity;s(j).MeanIntensity];
            eccentricity =[eccentricity; s(j).Eccentricity];
            
        end
        feature_table =  table(X1,Y1,isTP,area,majorAxisLength,minorAxisLength,orientation,maxIntensity,minIntensity,meanIntensity,eccentricity);
        
        writetable(feature_table, csv_file1,'Delimiter',',',...
            'WriteVariableNames',false);
      

    end
end
