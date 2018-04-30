
clear; clc;

cd /Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation

%% load all training and validation utterances

sourceDir =  '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/sensors/trainAndValidation_sensor';
sourceFiles = dir(sourceDir);
allFilesNames = {sourceFiles(:).name}.';

allFilesNames = natsortfiles(allFilesNames); % Natural-Order Filename Sort

txtIndicators = cellfun(@(x) ~isempty(strfind(x,'txt')), allFilesNames); % indicate if the file is .txt file
sourceFileNames = allFilesNames(txtIndicators);



%% split the training and validation utterance into folds

trainFile1 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate1/omg_cv_Train1.csv';

trainFile2 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate2/omg_cv_Train2.csv';

trainFile3 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate3/omg_cv_Train3.csv';

trainFile4 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate4/omg_cv_Train4.csv';

trainFile5 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate5/omg_cv_Train5.csv';



validationFile1 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate1/omg_cv_Validation1.csv';

validationFile2 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate2/omg_cv_Validation2.csv';

validationFile3 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate3/omg_cv_Validation3.csv';

validationFile4 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate4/omg_cv_Validation4.csv';

validationFile5 = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate5/omg_cv_Validation5.csv';


trainFiles = {trainFile1, trainFile2, trainFile3, trainFile4, trainFile5};

validationFiles = {validationFile1, validationFile2, validationFile3, validationFile4, validationFile5};

trainAndValidationFiles = {trainFiles, validationFiles};



%%

keywords = {'train', 'test'};

for k = 1:2


for j = 1:5
    
    
    file = trainAndValidationFiles{k}{j};
        
    table = readtable(file);
    videoNames = unique(table2array(table(:,4)), 'stable');
    
    %any(strcmp(videoNamesFromTrainFile, readVideo))
    RawData = cell(2,1); % first row: data; second row: data name
    
    
    %%
    fileNrInThisFold = 1;
    for fileCount = 1:length(sourceFileNames)
        %%
        
        % Create the full file name and partial filename
        fileFullnameCell = strcat(sourceDir,'/',sourceFileNames(fileCount));
        fileFullname = fileFullnameCell{1};
        
        
        fileNameCell = sourceFileNames(fileCount);
        fileNameString_pre = fileNameCell{1};
        %fileNameString = fileNameString_pre(1:end-4); % delete the .txt
        fileNameString = strtok(fileNameString_pre,'.'); 

        splitsNames = strsplit(fileNameString,'_');
        
        if length(splitsNames) == 4,
            readedVideoName = splitsNames(2);
        elseif length(splitsNames) == 5
            readedVideoName = strcat(splitsNames(2),'_',splitsNames(3));
        else
            error('the readed video has wrong naming format')
        end
        
        %%
        if ~any(strcmp(videoNames, readedVideoName))
            continue
            
        else
            
            
            
            
            
            fid=fopen(fileFullname);
            g = textscan(fid,'%s','delimiter','\n');
            lastLineNr = length(g{1}); % the number of many lines
            fclose(fid);
            
            
            loadRange = strcat('AL7..BK',num2str(lastLineNr)); % select the features from the column AL (Neutral Evidence) to BK (AU43 Evidence)
            
            
            allFeatures = dlmread(fileFullname,'\t',loadRange);
            
            
            neuPosNegFeatures = allFeatures(:,[1,3,5]); % the evidence of neutral, positive, and negative emotion.
            
            AUseries_all = allFeatures(:,7:end); % the features of Action Units.
            
            % Only use the 2, 4, 5, 9, 10, 14, 15, 17, 18, and 26 action units
            %AUseries_ROI = AUseries_all(:,[2,3,4,7,8,10,11,12,13,18]);
            
            % select all features
            AUseries_ROI = AUseries_all;
            
            
            combinedFeatures = [neuPosNegFeatures, AUseries_ROI];
            %combinedFeatures = AUseries_ROI;
            %combinedFeatures = neuPosNegFeatures;
            
            % convert all NAN into 0.
            combinedFeatures(isnan(combinedFeatures)) = 0;
            
            % return non-zero indicator matrix
            nonzerosIndicator = combinedFeatures ~= 0;
            
            % how many nonzeros in a row?
            nrNonzerosInRows = sum(nonzerosIndicator,2);
            
            % If at a time stamp, the features are non-negative, we keep it.
            nonzerosInd = find(nrNonzerosInRows == size(combinedFeatures,2));
            nnzCombinedFeatures = combinedFeatures(nonzerosInd,:);
            
            
            RawData{1,fileNrInThisFold} = nnzCombinedFeatures;
            
            
            
            
            videoUtteranceCell = splitsNames(2:end);
            
            
            
            videoUtterance = cell2mat(videoUtteranceCell);
            
            RawData{2,fileNrInThisFold} = videoUtterance;
            
            fileNrInThisFold = fileNrInThisFold + 1;
        end
    end
    
    
    RawDataRow1 = RawData(1,:);
    
    [nrows,ncols] = cellfun(@size,RawDataRow1);
    
    
    MoreThan3SecIndices = (nrows >= 90); % if a time series has more than 90 indices.
    
    
    RawDataLong = RawData(:,MoreThan3SecIndices);
    
    
    
    
    filename = strcat(keywords{k},'DataForCV','_', int2str(j),'.mat');
    
    
    save(filename,'RawData','RawDataLong')
    
end

end


