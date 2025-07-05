%{
    Template-based estimation (and correction) of zero rotation.

    Inputs: 
        - polyRX ((K+1) x P array of RX polynomial sequences)
        - templateMat (N x N template (Toeplitz) matrix) 

    Outputs:
        - polyRXcorrected ((K+1) x P array of corrected polynomial sequences)
        - phiHat (1 x P array of estimated rotations (in radians))

    Notes:
        - P >= 1 is the number of polynomials to correct
        - Each element in phiHat lies in the interval [0,2*pi)
%}

function [polyRXcorrected, phiHat] = correctPolysWithTemplate(polyRX, templateMat)

    % Declare needed variables
    K = height(polyRX) - 1;
    N = height(templateMat);

    % Calculate RX templates
    rxTemplates = abs(fft(polyRX, N));

    % Compute inner product with template matrix
    innerProds = rxTemplates.' * templateMat;

    % Estimate rotations
    [~, nMax] = max(innerProds, [], 2);
    phiHat = 2*pi * (nMax-1) / N;

    % Correct rotations
    polyRXcorrected = polyRX .* exp(1j* -phiHat .* (0:K)).';

end