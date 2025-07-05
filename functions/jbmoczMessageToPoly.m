%{
    Map messages to zeros and polynomials for J-BMOCZ.

    Inputs:
        - messages (K x M array of binary messages)
        - R (radius)
        - zeta (asymmetry factor)
        - E (coefficient energy)
        
    Outputs: 
        - polyMat ((K+1) x M array of associated J-BMOCZ polynomials)
        - zerosMat (K x M array of associated zero patterns)

    Notes:
        - M >= 1 is the number of messages to encode
        - Ensure R > 1
        - zeta = 1 (Huffman BMOCZ); zeta > 1 (J-BMOCZ)
        - The norm-square of the coefficients is normalized to E
        - Coefficients returned in descending order, i.e.,
          the leading coefficient is first
%}

function [polyMat, zerosMat] = jbmoczMessageToPoly(messages, R, zeta, E)
    
    % Declare needed values
    K = height(messages);
    radiusVals = [[R*zeta, R*ones(1, K-1)].', 1./[R*zeta, R*ones(1, K-1)].'];
    phaseVals = exp(1j*2*pi*(0:K-1)/K).';

    % Generate the zero constellation
    constellationZeros = radiusVals .* phaseVals;
    
    % Map the messages to zeros
    zerosMat =  double(messages == 1) .* constellationZeros(:, 1) + double(messages == 0) .* constellationZeros(:, 2);

    % Map the zeros to polynomials (with coefficient energy E)
    polyMat = zerosToPoly(zerosMat, 1, E);
    
end