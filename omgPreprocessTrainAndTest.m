
function [inputSignalsTrainAndTest, outputDataCellTrainAndTest, intervalsTrainAndTest] = omgPreprocessTrainAndTest(smoothRange, rawDataTrain, rawDataTest, fileNameTrain, fileNameTest, plotData)

% rawDataTrain = fold4Train; rawDataTest = fold4Test;  fileNameTrain = fold4TrainFile;  fileNameTest = fold4TestFile; plotData;
% rawDataTrain = Train; rawDataTest = Test;  fileNameTrain = TrainFile;  fileNameTest = PredictionOnTestFile; plotData

% step 1: normalize the train data. return the shifts and scales. normData = scales * (data + shift)


rawFeaturesTrain = rawDataTrain(1,:);
rawFeaturesTest = rawDataTest(1,:);
utteranceNamesTrain = rawDataTrain(2,:);
utteranceNamesTest = rawDataTest(2,:);


rawFeatures = {rawFeaturesTrain, rawFeaturesTest};

utteranceNamesTrainAndTest = {utteranceNamesTrain, utteranceNamesTest};

fileNames = {fileNameTrain, fileNameTest};



[normDataTrain, shifts, scales] = normalizeCellData(rawFeaturesTrain);




% step 2: submit the test data into the same transformation.
normDataTest = transformCellData(rawFeaturesTest,  shifts, scales);



normDataTrainAndTest = {normDataTrain, normDataTest};


% step 3: smooth the normalized training and testing data.


intervalsTrainAndTest = cell(1);
inputSignalsTrainAndTest = cell(1);
outputDataCellTrainAndTest = cell(1);

TestOutput = 1;
%%
for j = 1:2 % for the training and testing data
    %%
    normData = normDataTrainAndTest{j};
    smoothData = cell(1);
    
    for s = 1:length(normData) % for each utterance
        
        utterance = normData{s};
        
        if size(utterance, 1) <= 1,
            disp(sprintf('The utterance contains 0 or 1 feature'))
            smoothData{s,1} = smoothData{s-1};
            continue
        elseif size(utterance, 1) <= 10,
            smoothData{s,1} = utterance;
        else
            %effectiveSmoothRange = min(smoothRange, size(utterance,1)-1);
            effectiveSmoothRange = smoothRange;            
            smoothUtterance = tsmovavg(utterance,'s',effectiveSmoothRange,1);
            smoothUtterance(any(isnan(smoothUtterance), 2), :) = [];
            smoothData{s,1} = smoothUtterance;
            
        end
    end
    
    %%
    
    smoothDataSizes = cell2mat(cellfun(@size,smoothData,'uni',false)); % the [length, featureDim] of the utterances
    
    smoothDataLengths = smoothDataSizes(:,1);  % the lengths of the utterances
    
    smoothEndings = cumsum(smoothDataLengths);  % the ending time of the utterances
    smoothStartings = [1;(smoothEndings(1:end-1) + 1)];  % the starting time of the utterances
    intervals = [smoothStartings,smoothEndings]; % the [start time, end time] interval of the utterances
    
    
    %%
    
    
    intervalsTrainAndTest{j} = intervals;
    inputSignalsTrainAndTest{j} = cell2mat(smoothData)';
    
    
    fileName = fileNames{j};
    table = readtable(fileName);
    videoUtteranceFromCSV = table2array(table(:,[4,5]));
    videoUtterance_arousalValence = cell(1,1);
    
    %%
    for i = 1:size(videoUtteranceFromCSV,1)
        utteranceDOTMP4 = videoUtteranceFromCSV{i,2};
        utterance = cell2mat(strsplit(strtok(utteranceDOTMP4,'.'),'_'));
        
        videoWithUnderscore = videoUtteranceFromCSV{i,1};
        video = cell2mat(strsplit(videoWithUnderscore,'_'));
        
        videoUtterance = strcat(video,utterance);
        try
            videoUtterance_arousalValence{i,1} = videoUtterance;
            videoUtterance_arousalValence{i,2} = [table{i,6},table{i,7}];
            
        catch
            TestOutput = 0;
            continue
        end
    end
    
    if TestOutput,
    outputDataCell = cell(1,1);
    
    rawDataNames = utteranceNamesTrainAndTest{j};
    for i = 1:length(rawDataNames)
        name = rawDataNames{i};
        index = strcmp(videoUtterance_arousalValence, name);
        outputDataCell{i,1} = videoUtterance_arousalValence{index,2}';
    end
    outputDataCellTrainAndTest{j} = outputDataCell;    
    end
    
    
    
    %%
    
    if plotData
        %%
        figure(); clf;
        fs = 18;
        set(gcf, 'WindowStyle','normal');
        set(gcf,'Position', [800 300 800 400]);
        utterances = [1 2 3];
        
        currentPlot = 0;
        for utterance = utterances
            currentPlot = currentPlot +1;
            subplot(2,3,currentPlot)
            utterancedata = rawFeatures{j}{utterance};
            l = size(utterancedata,1);
            
            plot(1:l,utterancedata(:,1)', 'k','LineWidth', 2); hold on;
            plot(1:l,utterancedata(:,2)', 'k','LineWidth', 1);
            plot(1:l,utterancedata(:,3)', 'g','LineWidth', 2);
            plot(1:l,utterancedata(:,4)', 'g','LineWidth', 1);
            plot(1:l,utterancedata(:,5)', 'k:','LineWidth', 2);
            plot(1:l,utterancedata(:,6)', 'k:','LineWidth', 1);
            plot(1:l,utterancedata(:,7)', 'k:','LineWidth', 0.5);
            %             plot(1:l,utterancedata(:,8)', 'g','LineWidth', 0.5);
            %             plot(1:l,utterancedata(:,9)', 'k','LineWidth', 0.5);
            %             plot(1:l,utterancedata(:,10)', 'k--','LineWidth', 2);
            %             plot(1:l,utterancedata(:,11)', 'k--','LineWidth', 1);
            %             plot(1:l,utterancedata(:,12)', 'k--','LineWidth', 0.5);
            %             plot(1:l,utterancedata(:,13)', 'g--','LineWidth', 0.5);
            hold off;
            
            set(gca, 'FontSize', fs);
            title(sprintf('utterance %g', utterances(currentPlot)));
            
        end
        
        
        for utterance = utterances
            currentPlot = currentPlot +1;
            subplot(2,3,currentPlot)
            utterancedata = smoothData{utterance};
            l = size(utterancedata,1);
            
            plot(1:l,utterancedata(:,1)', 'k','LineWidth', 2); hold on;
            plot(1:l,utterancedata(:,2)', 'k','LineWidth', 1);
            plot(1:l,utterancedata(:,3)', 'g','LineWidth', 2);
            plot(1:l,utterancedata(:,4)', 'g','LineWidth', 1);
            plot(1:l,utterancedata(:,5)', 'k:','LineWidth', 2);
            plot(1:l,utterancedata(:,6)', 'k:','LineWidth', 1);
            plot(1:l,utterancedata(:,7)', 'k:','LineWidth', 0.5);
            %             plot(1:l,utterancedata(:,8)', 'g','LineWidth', 0.5);
            %             plot(1:l,utterancedata(:,9)', 'k','LineWidth', 0.5);
            %             plot(1:l,utterancedata(:,10)', 'k--','LineWidth', 2);
            %             plot(1:l,utterancedata(:,11)', 'k--','LineWidth', 1);
            %             plot(1:l,utterancedata(:,12)', 'k--','LineWidth', 0.5);
            %             plot(1:l,utterancedata(:,13)', 'g--','LineWidth', 0.5);
            hold off;
            %axis([1 4 0 1]);
            set(gca, 'FontSize', fs);
        end
    end
    
    
    
    
end

















