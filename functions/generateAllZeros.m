%{
    Generate all zeros in a J-BMOCZ constellation.

    Inputs: 
        - K (number of zeros)
        - R (radius)
        - zeta (asymmetry factor)

    Outputs:
        - constellationZeros (K x 2 array of the constellation zeros;
                              first column is zeros with magnitude > 1;
                              second column is zeros with magnitude < 1;
                              zeros ordered by increasing phase)

    Notes:
        - Ensure R > 1
        - zeta = 1 (Huffman BMOCZ); zeta > 1 (J-BMOCZ)
%}

function constellationZeros = generateAllZeros(K, R, zeta)

    % Declare needed values
    radiusVals = [[R*zeta, R*ones(1, K-1)].', 1./[R*zeta, R*ones(1, K-1)].'];
    phaseVals = exp(1j*2*pi*(0:K-1)/K).';
    
    % Generate constellation zeros
    constellationZeros = radiusVals .* phaseVals;
    
end