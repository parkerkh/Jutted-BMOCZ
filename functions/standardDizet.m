%{
    Implementation of the DiZeT decoder.

    Inputs: 
        - polyRX ((K+1) x P array of RX polynomial sequences)
        - K (number of zeros)
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
%}

function outArray = standardDizet(polyRX, K, constellationZeros, soft)
    
    % Evaluate RX polynomials at zeros in constellation
    outerEvaluationMat = (constellationZeros(:, 1) .^ (K:-1:0)) * polyRX;
    innerEvaluationMat = (constellationZeros(:, 2) .^ (K:-1:0)) * polyRX;

    % Soft-decision decoding
    if soft

        num = exp((-abs(outerEvaluationMat).^2 .* abs(constellationZeros(:, 1)).^(-K)));
        den = exp((-abs(innerEvaluationMat).^2 .* abs(constellationZeros(:, 2)).^(-K)));

        outArray(:, :, 1) = num;
        outArray(:, :, 2) = den;

    % Hard-decision decoding
    else
        outArray = double(abs(outerEvaluationMat) < abs(constellationZeros(:, 1).^K .* abs(innerEvaluationMat)));
    end

end