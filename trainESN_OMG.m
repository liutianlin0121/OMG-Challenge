function [avStates, allStates, w_out, teachers] = trainESN_OMG(trainInputSignals, trainOutputCells, w, w_in, leakage, nForgetPoints, trainIntervals, reg, plotStates)
 

% trainInputSignals, trainOutputSignals, w, w_in, leakage, nForgetPoints, trainIntervals, reg, collectionLength

% collect responses for the internal dynamics 
% u: input signals
% y: teacher signals
% x: internal units a vector of length NX
% w: weight matrix NX by NX
% w_in: input to internal units weights
% w_out: output weight matrix NC by (1 + LP + NX)
% leakage: leaky rate
% trainIntervals: the range of each data entries
% reg: regulization term




rng('default');




avextendedStatesWashedoutOverSamples  = cell(1,1);
avTeacherSignalsOverSamples = cell(1,1);

extendedStateLength = size(w,1) + size(trainInputSignals, 1) + 1;

for i = 1:size(trainIntervals, 1)

    
   
    collectionLength = trainIntervals(i,2) - trainIntervals(i,1)+1 - nForgetPoints; % the length for state mat and for teacher signal
    

    
    extendedStatesWashedout = zeros(extendedStateLength , collectionLength ); 
%     teacherSignals = zeros(size(trainOutputSignals, 1), collectionLength);
    
    
    
    countTime = 1;
            
    x = zeros(size(w,1),1); % initial state of zero. 

    for timeNow = trainIntervals(i,1):trainIntervals(i, 2)
        % update state
        u = trainInputSignals(:, timeNow);

        internal = w * x;
        inputs = w_in * [1; u];
        extendedStatesWashedout_temp = tanh(internal + inputs);
        x = (1 - leakage) * x + leakage * extendedStatesWashedout_temp;

        % discard for the init phase for every sequence
        if countTime > nForgetPoints
            extendedStatesWashedout(:, countTime - nForgetPoints) = [1; u; x];
            %teacherSignals(:, countTime - nForgetPoints) = trainOutputSignals(:, timeNow);
        end  
        countTime = countTime + 1;
    end
    
    avextendedStatesWashedoutOverSamples{1,i} = sum(extendedStatesWashedout(:, end-collectionLength+1:end),2)./collectionLength; % collect the averaged states.
    
    allStatesWashedoutOverSamples{1,i} = extendedStatesWashedout; % collect the all the states.
    
    
    avTeacherSignalsOverSamples{1,i} = trainOutputCells{i}; % collect the teacher signals.

    
end

%%
avStates = cell2mat(avextendedStatesWashedoutOverSamples);
allStates = cell2mat(allStatesWashedoutOverSamples);

avStatesTranspose = avStates';

teachers = cell2mat(avTeacherSignalsOverSamples);


% ridge regression
%w_out =  teachers * statesTranspose * inv(states * statesTranspose + reg * eye(extendedStateLength));
w_out =  teachers * avStatesTranspose/(avStates * avStatesTranspose + reg * eye(extendedStateLength));





%%

if plotStates == 1,
    nPlotNeurons = min(50, size(w,2)); % number of neurons one wants to inspeculate.
    lengthAvStates = size(avStates,2); % length of the first utterance.

    figure
    for i = 1:nPlotNeurons-1
    plot(1:lengthAvStates, avStates(end - nPlotNeurons +i,1:lengthAvStates)); hold on;
    end
    hold off;
    title('Activeity of the first 50 neurons avaraged across utterances')

    
    
    figure 
    
    % plot the neuron activity in the first utterance
    lengthFirstUtteranceActivation = trainIntervals(1,2) - trainIntervals(1,1)+1 - nForgetPoints;
    for i = 1:nPlotNeurons-1 hold on
    plot(1:lengthFirstUtteranceActivation, allStates(end - nPlotNeurons +i, 1:lengthFirstUtteranceActivation))
    end
    hold off
    title('Activeity of the First 50 neurons for the first utterance')
    
    
end












end