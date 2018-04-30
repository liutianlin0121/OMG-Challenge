function []  = savePredictionResult(predictions, predictionFile, utteranceNames)

% predictions = trainPredictionsALL; predictionFile =  predictionOnTrainFileALL; utteranceNames= rawDataTrainALL(2,:);
% predictions = testPredictions; predictionFile = predictionOnTestFile; utteranceNames = testNames;

table = readtable(predictionFile);

table{:,[6,7]} = 0;

videoUtteranceFromCSV = table2array(table(:,[4,5]));

%j = 0;
for i = 1:size(table,1)
    utteranceDOTMP4 = videoUtteranceFromCSV{i,2};
    %utterance = cell2mat(strsplit(utteranceDOTMP4(1:end-4),'_'));
    utterance = cell2mat(strsplit(strtok(utteranceDOTMP4, '.'),'_'));
    videoWithUnderscore = videoUtteranceFromCSV{i,1};
    video = cell2mat(strsplit(videoWithUnderscore,'_'));
    
    videoUtterance = strcat(video,utterance);
    
    if isempty(find(strcmp(utteranceNames, videoUtterance),1)),
      %  j = j + 1;
        if i == 1,
            table{i,6} = rand(1);
            table{i,7} = rand(1);
        else
        table{i,6} = table{i-1,6};
        table{i,7} = table{i-1,6};
        end
    else
        
        
    index = find(strcmp(utteranceNames, videoUtterance));
    table{i,6} = predictions(index,1);
    table{i,7} = predictions(index,2);
    end
end

%disp(sprintf('%g utterances can not be found.', j))

writetable(table,predictionFile)
