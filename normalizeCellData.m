function [normData, shifts, scales] = normalizeCellData(data)
% Normalizes training input data. Returns shifts and
% scales of first 20 columns as row vectors (size 20), where 
% normData = scales * (data + shift).


% assemble all samples in one big matrix



dataSizes = cell2mat(cellfun(@size,data','uni',false)); % the [length, featureDim] of the utterances

totalLength = sum(dataSizes(:,1),1);


dimData = size(data{1},2);

allData = zeros(totalLength, dimData);
currentStartIndex = 0;


for s = 1:size(data,2)
    L = size(data{s},1);
    allData(currentStartIndex+1:currentStartIndex+L,:) = ...
        data{s}(:,1:dimData);
    currentStartIndex = currentStartIndex + L;
end

maxVals = max(allData);
minVals = min(allData);
shifts = - minVals;
scales = 1./(maxVals - minVals);
normData = cell(size(data,2),1);
for s = 1:size(data,2)
    normData{s} = data{s}(:,1:dimData) + repmat(shifts, size(data{s},1),1);
    normData{s} = normData{s} * diag(scales);
end


   