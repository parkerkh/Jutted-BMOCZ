%{
    Estimate zero stability given an array of polynomial zeros.

    Inputs:
        - zerosMat (K x P array of zero patterns)
        - E (coefficient energy; 1 is recommended)
        - Nover (DFT size used in calculation)

    Outputs:
        - Cmean (1 x P array of mean zero stability for each zero pattern)
        - Czeros (K x P array of estimated stability for each individual zero)

    Notes:
        - Ensure Nover >= K+1; a larger power of 2 is ideal, e.g., 1024
        - P >= 1 is the number of zero patterns to analyze
%}

function [Cmean, Czeros] = estimateZeroStability(zerosMat, E, Nover)

    % Get size of inputted zero array
    [K, P] = size(zerosMat);

    % Preallocate
    Czeros = ones(size(zerosMat));
    Cmean = ones(1, P);

    % Map zeros to polynomial(s) with coefficient energy E
    polyMat = zerosToPoly(zerosMat, 1, E);

    % Loop over the P polynomials
    for p = 1:P

        % Get all zero combinations for given zero pattern
        zeroCombinations = fliplr(nchoosek(zerosMat(:, p), K-1).');
    
        % Map zero combinations to coefficients 
        polyCombinations = polyMat(1, p) * zerosToPoly(zeroCombinations, 0, []);
    
        % Compute frequency response 
        Hmat = fft(flipud(polyCombinations), Nover);
    
        % Estimate stability of each zero 
        Czeros(:, p) = 1/Nover * sum(log2(1 + abs(Hmat).^2));
    
        % Estimate stability of the current polynomial
        Cmean(p) = mean(Czeros(:, p));

    end

end