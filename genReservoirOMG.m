function [w_in, w] = genReservoirOMG(nInternalUnits, nInputUnits, spectralRadius, neuScale, posNegScale, AUscale, bias_scale)
% Generate a reservoir for ESN.

if nInternalUnits <= 20
    connectivity = 1;
else
    connectivity = 10/nInternalUnits;
end



success = 0;

while not(success)
    try
        rng('default');
        internalWeights = sprandn(nInternalUnits, nInternalUnits, connectivity);
        opts.disp = 0;
        specRad = abs(eigs(internalWeights,1, 'lm', opts));
        internalWeights = internalWeights/specRad;
        success = 1;
    catch
    end
end


w = spectralRadius*internalWeights;

in_scale = [neuScale, posNegScale*ones(1,2), AUscale*ones(1, 20)];

rng('default');
temp = randn(nInternalUnits, nInputUnits) * diag(in_scale);


rng('default');
bias = bias_scale * randn(nInternalUnits,1);

w_in = [bias, temp];

