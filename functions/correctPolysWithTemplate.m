%{
    Template-based estimation (and correction) of zero rotation.

    Inputs: 
        - polyRX ((K+L) x P array of RX polynomial sequences)
        - templateMat (N x N template (Toeplitz) matrix) 
        - K (number of zeros)
        - L (CIR length)

    Outputs:
        - polyRXcorrected ((K+L) x P array of corrected polynomial sequences)
        - phiHat (1 x P array of estimated rotations (in radians))

    Notes:
        - P >= 1 is the number of polynomials to correct
        - Each element in phiHat lies in the interval [0,2*pi)
        - Coefficients need to be in descending order, i.e., 
          the leading coefficient is first

    References:
        - P. Huggins and A. Sahin, "Jutted BMOCZ for non-coherent OFDM,"
          IEEE Trans. Wireless Commun., vol. 24, pp. 17864-17878, 2026.
%}

function [polyRXcorrected, phiHat] = correctPolysWithTemplate(polyRX, templateMat, K, L)

    % Declare needed values
    N = K + L;
    Nover = height(templateMat);

    % Calculate RX templates
    rxTemplates = abs(fft(polyRX, Nover));

    % Compute inner product with template matrix
    innerProds = rxTemplates.' * templateMat;

    % Estimate rotations
    [~, nMax] = max(innerProds, [], 2);
    phiHat = 2*pi * (nMax-1) / Nover;

    % Correct rotations
    polyRXcorrected = polyRX .* exp(1j* -phiHat .* (0:(N-1))).';

end