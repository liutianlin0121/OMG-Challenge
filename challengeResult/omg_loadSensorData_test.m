
clear; clc;


cd /Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/challengeResult/
%%
%%%%%%%%%%%% Data preparation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sourceRoot =  '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/sensors/';

Dataset = {'trainAndValidation_sensor', 'test_sensor_rename'};

%%


for i = 1:2
    
    dataName = Dataset{i};
    sourceDir = strcat(sourceRoot,dataName);
    sourceFiles = dir(sourceDir);
    allFilesNames = {sourceFiles(:).name}.';
    
    allFilesNames = natsortfiles(allFilesNames); % Natural-Order Filename Sort
    
    txtIndicators = cellfun(@(x) ~isempty(strfind(x,'txt')), allFilesNames); % indicate if the file is .txt file
    sourceFileNames = allFilesNames(txtIndicators); 
    RawData = cell(2,length(sourceFileNames)); % first row: data; second row: data name

    videoBeginCount = cell(1); % count the begin time (in terms of the utterance numbers) for the videos.
    videoBeginCount{1,1} = 1;    %A{end+1} = c;
    
    

    %%
    
    for fileCount = 1:length(sourceFileNames)
        
        
        % Create the full file name and partial filename
        fileFullnameCell = strcat(sourceDir,'/',sourceFileNames(fileCount));
        fileFullname = fileFullnameCell{1};

        
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
        
        
        RawData{1,fileCount} = nnzCombinedFeatures;
        
        fileNameCell = sourceFileNames(fileCount);
        fileNameString_pre = fileNameCell{1};
        %fileNameString = fileNameString_pre(1:end-4); % delete the .txt
        fileNameString = strtok(fileNameString_pre,'.');% delete the .txt

        splitsNames = strsplit(fileNameString,'_');
        
        
        videoCell = splitsNames(2:end-2);
        video = cell2mat(videoCell);
        

        
        
        videoUtteranceCell = splitsNames(2:end);

        
        
        videoUtterance = cell2mat(videoUtteranceCell);

        RawData{2,fileCount} = videoUtterance;        
    end
    
     videoBeginCountMat = cell2mat(videoBeginCount)';
     
     
    
     RawDataRow1 = RawData(1,:);
     
     [nrows,ncols] = cellfun(@size,RawDataRow1); 
    %%
    
    
     MoreThan3SecIndices = (nrows >= 90); % if a time series has more than 10 indices.
     
     
     RawDataLong = RawData(:,MoreThan3SecIndices);
     
     
     
    cd /Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/challengeResult/
     
    filename = strcat(dataName,'.mat');
    
    save(filename,'RawData','RawDataLong')
end


