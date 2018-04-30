
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Main Script for OMG Prediction %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% created and copyright: Tianlin Liu, March. 2018


clear;
clc;


%
%%%%%%%%%%%% Loading Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fold1TrainMAT = matfile ('trainDataForCV_1.mat');
fold2TrainMAT = matfile ('trainDataForCV_2.mat');
fold3TrainMAT = matfile ('trainDataForCV_3.mat');
fold4TrainMAT = matfile ('trainDataForCV_4.mat');
fold5TrainMAT = matfile ('trainDataForCV_5.mat');

fold1TestMAT = matfile ('testDataForCV_1.mat');
fold2TestMAT = matfile ('testDataForCV_2.mat');
fold3TestMAT = matfile ('testDataForCV_3.mat');
fold4TestMAT = matfile ('testDataForCV_4.mat');
fold5TestMAT = matfile ('testDataForCV_5.mat');



% load training data
fold1Train = fold1TrainMAT.RawDataLong; % the training utterances that are long
fold2Train = fold2TrainMAT.RawDataLong; % the training utterances that are long
fold3Train = fold3TrainMAT.RawDataLong; % the training utterances that are long
fold4Train = fold4TrainMAT.RawDataLong; % the training utterances that are long
fold5Train = fold5TrainMAT.RawDataLong; % the training utterances that are long







% load testing data
fold1Test = fold1TestMAT.RawData; % all testing utterances
fold2Test = fold2TestMAT.RawData; % all testing utterances
fold3Test = fold3TestMAT.RawData; % all testing utterances
fold4Test = fold4TestMAT.RawData; % all testing utterances
fold5Test = fold5TestMAT.RawData; % all testing utterances

testNamesCollection = {fold1Test(2,:), fold2Test(2,:), fold3Test(2,:), fold4Test(2,:), fold5Test(2,:)};

%%

% load the gold standard of OMG dataset
fold1TrainFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate1/omg_cv_Train1.csv';
fold2TrainFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate2/omg_cv_Train2.csv';
fold3TrainFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate3/omg_cv_Train3.csv';
fold4TrainFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate4/omg_cv_Train4.csv';
fold5TrainFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate5/omg_cv_Train5.csv';




fold1TestFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate1/omg_cv_Validation1.csv';
fold2TestFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate2/omg_cv_Validation2.csv';
fold3TestFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate3/omg_cv_Validation3.csv';
fold4TestFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate4/omg_cv_Validation4.csv';
fold5TestFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate5/omg_cv_Validation5.csv';





fold1PredictionFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate1/prediction1.csv';
fold2PredictionFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate2/prediction2.csv';
fold3PredictionFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate3/prediction3.csv';
fold4PredictionFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate4/prediction4.csv';
fold5PredictionFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationData/crossValidate5/prediction5.csv';

predictionFiles = {fold1PredictionFile, fold2PredictionFile, fold3PredictionFile, fold4PredictionFile, fold5PredictionFile};



%%%%%%%%%%%% Pre-processing the timeseries %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%smoothRange = 10; % the smoothing range for the timeseries.
smoothRange = 5; % the smoothing range for the timeseries.

plotData = 1;

%

% use the long utterances to train.

[inputSignalsTrainAndTest_fold1, outputDataCellTrainAndTest_fold1, intervalsTrainAndTest_fold1] = omgPreprocessTrainAndTest(smoothRange, fold1Train, fold1Test, fold1TrainFile, fold1TestFile, plotData);


[inputSignalsTrainAndTest_fold2, outputDataCellTrainAndTest_fold2, intervalsTrainAndTest_fold2] = omgPreprocessTrainAndTest(smoothRange, fold2Train, fold2Test, fold2TrainFile, fold2TestFile, plotData);
[inputSignalsTrainAndTest_fold3, outputDataCellTrainAndTest_fold3, intervalsTrainAndTest_fold3] = omgPreprocessTrainAndTest(smoothRange, fold3Train, fold3Test, fold3TrainFile, fold3TestFile, plotData);


[inputSignalsTrainAndTest_fold4, outputDataCellTrainAndTest_fold4, intervalsTrainAndTest_fold4] = omgPreprocessTrainAndTest(smoothRange, fold4Train, fold4Test, fold4TrainFile, fold4TestFile, plotData);
[inputSignalsTrainAndTest_fold5, outputDataCellTrainAndTest_fold5, intervalsTrainAndTest_fold5] = omgPreprocessTrainAndTest(smoothRange, fold5Train, fold5Test, fold5TrainFile, fold5TestFile, plotData);


%%






trainInputSignalsCollection = {inputSignalsTrainAndTest_fold1{1}, inputSignalsTrainAndTest_fold2{1}, inputSignalsTrainAndTest_fold3{1}, inputSignalsTrainAndTest_fold4{1}, inputSignalsTrainAndTest_fold5{1}};
trainOutpCellsCollection = {outputDataCellTrainAndTest_fold1{1}, outputDataCellTrainAndTest_fold2{1}, outputDataCellTrainAndTest_fold3{1}, outputDataCellTrainAndTest_fold4{1}, outputDataCellTrainAndTest_fold5{1}};
trainIntervalsCollection = {intervalsTrainAndTest_fold1{1}, intervalsTrainAndTest_fold2{1}, intervalsTrainAndTest_fold3{1}, intervalsTrainAndTest_fold4{1}, intervalsTrainAndTest_fold5{1}};

testInputSignalsCollection = {inputSignalsTrainAndTest_fold1{2}, inputSignalsTrainAndTest_fold2{2}, inputSignalsTrainAndTest_fold3{2}, inputSignalsTrainAndTest_fold4{2}, inputSignalsTrainAndTest_fold5{2}};
testOutpCellsCollection = {outputDataCellTrainAndTest_fold1{2}, outputDataCellTrainAndTest_fold2{2}, outputDataCellTrainAndTest_fold3{2}, outputDataCellTrainAndTest_fold4{2}, outputDataCellTrainAndTest_fold5{2}};
testIntervalsCollection = {intervalsTrainAndTest_fold1{2}, intervalsTrainAndTest_fold2{2}, intervalsTrainAndTest_fold3{2}, intervalsTrainAndTest_fold4{2}, intervalsTrainAndTest_fold5{2}};





%%%%%%%%%%%% Model setup %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nInputUnits = 23; % number of input units (= nr features we get from video preprocessing with FACET). fixed at 13 for this task.
nOutputUnits = 2; % number of output units. fix it as 2 as we have a binary classification task.



% Tuning parameters:
nInternalUnits= 500;  % size of the reservoir.
%reg = 0.1;  % regularization constant for ridge regression.
%reg = 0.1;  % regularization constant for ridge regression.

nForgetPoints = 10;  % "washout period" for reservoir states collection.
neuScale = 0.4;
posNegScale = 0.4;
AUscale = posNegScale;
bias_scale = 0.6;
spectralRadius = 1.5;  % spectral radius
leakage = 1; % leaky rate of ESN.
reg = 0.1;


plotStates = 0;


diary('tuning')

%for neuScale = 0.4:0.2:1.6,
%    posNegScale = neuScale;
%    AUscale = neuScale;
    
%    for bias_scale = 0.4:0.2:1.6;
        %    for spectralRadius = 1.2:0.2:1.6
        
        disp(sprintf('leakage %g, nInternalUnits %g, neuScale %g, posNegScale %g, spectralRadius %g, reg %g, bias_scale %g', ...
            leakage, nInternalUnits, neuScale, posNegScale, spectralRadius, reg, bias_scale));
        
        
        
        
        %%%%%%%%%%%% Generate a Reservoir %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %[w_in, w] = genReservoir(nInternalUnits, nInputUnits, spectralRadius, in_scale, bias_scale);
        [w_in, w] = genReservoirOMG(nInternalUnits, nInputUnits, spectralRadius, neuScale, posNegScale, AUscale, bias_scale);
        
        
        
        for i = 1:5
            %%
            trainInputSignals = trainInputSignalsCollection{i};
            trainOutputCells = trainOutpCellsCollection{i};
            trainIntervals = trainIntervalsCollection{i};
            
            testInputSignals = testInputSignalsCollection{i};
            testIntervals = testIntervalsCollection{i};
            
            predictionOnTestFile = predictionFiles{i};
            
            testNames = testNamesCollection{i};
            
            %%%%%%%%%%%% Training the ESN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            [~, ~, w_out, ~] = trainESN_OMG(trainInputSignals, trainOutputCells, w, w_in, leakage, nForgetPoints, trainIntervals, reg, 0);
            
            
            
            
            
            %%%%%%%%%%%% Testing the ESN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            [~, ~, testPredictions] = testESN_OMG(testInputSignals, testIntervals, w_out, w_in, w, leakage, nForgetPoints, plotStates); % test on training data.
            
            
            savePredictionResult(testPredictions, predictionOnTestFile, testNames);
            
        end
        
        
        %system('/Users/liutianlin/anaconda3/bin/python /Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/calculateEvaluationCCC_temp.py');
        system('/Users/liutianlin/anaconda3/bin/python /Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/crossValidation/crossValidationCCC.py');
        
        
        
%    end
    %    end
%end


diary off
load handel.mat;
sound(y, 2*Fs);