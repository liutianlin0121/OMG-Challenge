
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Main Script for OMG Prediction %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% created and copyright: Tianlin Liu, March. 2018


clear;
clc;


%
%%%%%%%%%%%% Loading Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TrainMAT = matfile ('trainAndValidation_sensor.mat');

TestMAT = matfile ('test_sensor_rename.mat');



% load training data
Train = TrainMAT.RawDataLong; % the training utterances that are long

trainNames = Train(2,:);

% load testing data
Test = TestMAT.RawData; % all testing utterances


testNames = Test(2,:);



% load the gold standard of OMG dataset
TrainFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/challengeResult/omg_Train_and_Validation_Videos.csv';


predictionOnTrainFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/challengeResult/predictionOnTrainingData.csv';


PredictionOnTestFile = '/Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/challengeResult/predictionOnTestingData.csv';



%%
%%%%%%%%%%%% Pre-processing the timeseries %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

smoothRange = 5; % the smoothing range for the timeseries.

plotData = 1;

%

% use the long utterances to train.
%%
[inputSignalsTrainAndTest, outputDataCellTrainAndTest, intervalsTrainAndTest] = omgPreprocessTrainAndTest(smoothRange, Train, Test, TrainFile, PredictionOnTestFile, plotData);


%%






trainInputSignals = inputSignalsTrainAndTest{1};
trainOutputCells = outputDataCellTrainAndTest{1};
trainIntervals = intervalsTrainAndTest{1};


testInputSignals = inputSignalsTrainAndTest{2};
testIntervals = intervalsTrainAndTest{2};


%%


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



plotStates = 1;


diary('tuning')

%for neuScale = 0.4:0.2:1.2,
%   posNegScale = neuScale;
%   AUscale = neuScale;
%   bias_scale = neuScale;
%    for spectralRadius = 1.2:0.2:1.6
%        for reg = 0.3:0.2:1.6

disp(sprintf('leakage %g, nInternalUnits %g, neuScale %g, posNegScale %g, spectralRadius %g, reg %g, bias_scale %g', ...
    leakage, nInternalUnits, neuScale, posNegScale, spectralRadius, reg, bias_scale));




%%%%%%%%%%%% Generate a Reservoir %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[w_in, w] = genReservoirOMG(nInternalUnits, nInputUnits, spectralRadius, neuScale, posNegScale, AUscale, bias_scale);







%%%%%%%%%%%% Training the ESN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~, ~, w_out, ~] = trainESN_OMG(trainInputSignals, trainOutputCells, w, w_in, leakage, nForgetPoints, trainIntervals, reg, 0);





%%%%%%%%%%%% Testing the ESN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
[~, ~, trainPredictions] = testESN_OMG(trainInputSignals, trainIntervals, w_out, w_in, w, leakage, nForgetPoints, plotStates); % test on training data.


savePredictionResult(trainPredictions, predictionOnTrainFile, trainNames);
system('/Users/liutianlin/anaconda3/bin/python /Users/liutianlin/Desktop/Academics/MATLAB/OMG_codes/challengeResult/calculateEvaluationCCC_temp.py');


[~, ~, testPredictions] = testESN_OMG(testInputSignals, testIntervals, w_out, w_in, w, leakage, nForgetPoints, plotStates); % test on training data.


%%
savePredictionResult(testPredictions, PredictionOnTestFile, testNames);





diary off
load handel.mat;
sound(y, 2*Fs);