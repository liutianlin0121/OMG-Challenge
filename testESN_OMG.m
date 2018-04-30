function [avStates, allStates, predictions] = testESN_OMG(testInputSignals,intervalsTest, w_out, w_in, w, leakage, nForgetPoints, plotStates)

% testInputSignals = testInputSignals; intervalsTest = testIntervals;
% testInputSignals = trainInputSignalsALL; intervalsTest = trainIntervalsALL;
predictions = zeros(size(intervalsTest, 1), 2);

avExtendedStatesCollection = cell(1,1);
allExtendedStatesCollection = cell(1,1);
 

for countTestSample = 1:size(intervalsTest,1),
    thisTestInput = testInputSignals(:,intervalsTest(countTestSample,1):intervalsTest(countTestSample,2));
    u = thisTestInput(:, 1); % u(1)
    T = size(thisTestInput, 2); 
    rng('default');
%    x = randn(size(w_in,1),1); % x(1)
%    x = x/ max(abs(x));
    x = zeros(size(w_in,1),1); % x(1)
    
    
    extendedStates = zeros(size([1; u; x],1), T);
    
    
    
    for countTime=1:T
        % update state
        u = thisTestInput(:,countTime); 
        internal = w * x;
        inputs = w_in * [1; u];
        x_tilde = tanh(internal + inputs);
        x = (1 - leakage) * x + leakage * x_tilde;
        extendedStates(:,countTime) = [1; u; x];
    end
    
        effectivenForgetPoints = (nForgetPoints < T)* nForgetPoints; % if the features have length larger than nForgetPoints, washout by nForgetPoints. else do not washout.
        %effectivenForgetPoints = min(T-1, nForgetPoints); % if the features have length larger than nForgetPoints, washout by nForgetPoints. else do not washout.
    
        extendedStatesWashedout = extendedStates(:, effectivenForgetPoints + 1 : end);
        
        
    
        avSpan = size(extendedStatesWashedout,2); 

           
        avExtendedStates = sum(extendedStatesWashedout(:, end-avSpan+1:end),2)./avSpan;
        
        
    
        avExtendedStatesCollection{1,countTestSample} = avExtendedStates; % collect the averaged states.
        allExtendedStatesCollection{1,countTestSample} = extendedStatesWashedout; % collect all the averaged states.

    
    
    
       
        classHyp = w_out*avExtendedStates;
        
        
        predictions(countTestSample, :) = classHyp';
    
    
end

avStates = cell2mat(avExtendedStatesCollection);
allStates = cell2mat(allExtendedStatesCollection);


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
    lengthFirstUtteranceActivation = intervalsTest(1,2) - intervalsTest(1,1)+1 - nForgetPoints;
    for i = 1:nPlotNeurons-1; hold on;
    plot(1:lengthFirstUtteranceActivation, allStates(end - nPlotNeurons +i, 1:lengthFirstUtteranceActivation))
    end
    hold off
    title('Activeity of the First 50 neurons for the first utterance')
    
    
end







