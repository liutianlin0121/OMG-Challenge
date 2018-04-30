function testInputsTrans = transformCellData(testInputs,  shifts, scales)

nrTestInputs = size(testInputs,2);
testInputsTrans = cell(nrTestInputs,1);
for s = 1:nrTestInputs
    testInputsTrans{s} =  (testInputs{s}  + repmat(shifts, size(testInputs{s},1), 1)) * diag(scales);
end