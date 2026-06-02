%{
    Return template vector (and matrix) for a given zero constellation.

    Inputs: 
        - constellationZeros (K x 2 array of the constellation zeros;
                              first column is zeros with magnitude > 1;
                              second column is zeros with magnitude < 1;
                              zeros ordered by increasing phase)
        - E (coefficient energy)
        - N (number of template samples)

    Outputs: 
        - templateVector (N x 1 template transform)
        - templateMat (N x N template (Toeplitz) matrix) 

    Notes:
        - Ensure N >= K + 1

    References:
        - P. Huggins and A. Sahin, "Jutted BMOCZ for non-coherent OFDM,"
          IEEE Trans. Wireless Commun., vol. 24, pp. 17864-17878, 2026.
%}

function [templateVector, templateMat] = getTemplate(constellationZeros, E, N)
    
    % Map zeros to polynomials
    polyMat = zerosToPoly(constellationZeros, 1, E);

    % Return template vector
    templateVector = abs(fft(polyMat(:, 1), N));

    % Return template matrix (Toeplitz)
    templateMat = toeplitz(templateVector, [templateVector(1); templateVector(end:-1:2)]);
    
end