%{
    Implementation of the DiZeT decoder.

    Inputs: 
        - polyRX ((K+L) x P array of RX polynomial sequences)
        - K (number of zeros)
        - L (CIR length)
        - constellationZeros (K x 2 array of the constellation zeros;
                              first column is zeros with magnitude > 1;
                              second column is zeros with magnitude < 1;
                              zeros ordered by increasing phase)
        - soft (0 --> hard decision; 1 --> soft decision)

    Outputs:
        - outArray (decoded messages or soft information)

    Notes:
        - P >= 1 is the number of polynomials to decode
        - Soft-decision output is pseudo-log-likelihood ratios
        - Coefficients need to be in descending order, i.e.,
          the leading coefficient is first

    References:
        - P. Walk, P. Jung, B. Hassibi, and H. Jafarkhani, "MOCZ for blind 
          short-packet communication: Basic principles," IEEE Trans. 
          Wireless Commun., vol. 18, no. 11, pp. 5080-5097, 2019.
        - P. Huggins and A. Sahin, "Jutted BMOCZ for non-coherent OFDM,"
          IEEE Trans. Wireless Commun., under review.
%}

function outArray = standardDizet(polyRX, K, L, constellationZeros, soft)

    % Declare needed values
    N = K + L;
    
    % Evaluate RX polynomials at zeros in constellation
    outerEvaluationMat = (constellationZeros(:, 1) .^ ((N-1):-1:0)) * polyRX;
    innerEvaluationMat = (constellationZeros(:, 2) .^ ((N-1):-1:0)) * polyRX;

    % Soft-decision decoding
    if soft

        num = exp((-abs(outerEvaluationMat).^2 .* abs(constellationZeros(:, 1)).^(-(N-1))));
        den = exp((-abs(innerEvaluationMat).^2 .* abs(constellationZeros(:, 2)).^(-(N-1))));

        outArray(:, :, 1) = num;
        outArray(:, :, 2) = den;

    % Hard-decision decoding
    else
        outArray = double(abs(outerEvaluationMat) < abs(constellationZeros(:, 1).^(N-1) .* abs(innerEvaluationMat)));
    end

end