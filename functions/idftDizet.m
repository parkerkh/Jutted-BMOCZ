%{
    Implementation of the oversampled DiZeT decoder based on the IDFT.

    Inputs:
        - polyRX ((K+1) x P array of RX polynomial sequences)
        - Q (IDFT oversampling factor)
        - R (radius)

    Outputs:
        - messagesRX (K x P array of decoded messages)
        - epHat (1 x P array of estimated zero rotations (fractional component))

    Notes:
        - P >= 1 is the number of polynomials to decode
        - Ensure Q >= 2
        - Each element in epHat lies in the interval [0,1)
        - Coefficients need to be in descending order, i.e.,
          the leading coefficient is first

    References:
        - P. Walk, P. Jung, B. Hassibi, and H. Jafarkhani, "MOCZ for blind 
          short-packet communication: Practical aspects," IEEE Trans. 
          Wireless Commun., vol. 19, no. 10, pp. 6675-6692, 2020.
%}

function [messagesRX, epHat] = idftDizet(polyRX, Q, R)

    % Declare needed variables
    K = height(polyRX) - 1; P = width(polyRX);
    yFlip = flipud(polyRX);
    Ntilde = Q*K;
    
    % Scaling vectors
    Rk = R .^ (0:K).';
    Rm1k = (1/R) .^ (0:K).';
    
    % Take IDFT
    YalphaR = Ntilde * ifft((yFlip .* Rk), Ntilde);
    YalphaRm1 = Ntilde * ifft((yFlip .* Rm1k), Ntilde);
   
    % Reshape for summing
    Y1 = reshape(abs(YalphaR), Q, K, P);
    Y2 = R^K * reshape(abs(YalphaRm1), Q, K, P);

    % Perform summing
    minVals = min(Y1, Y2);
    minSumVec = squeeze(sum(minVals, 2));

    % Find indices of minimum sums
    [~, qHat] = min(minSumVec, [], 1);

    % Estimate fractional component of zero rotation
    epHat = (qHat-1) / Q;
    
    % Get indices for decoding
    numRows = floor((Ntilde - qHat) / Q) + 1;
    rowIndices = qHat + (0:max(numRows)-1).' * Q;
    colIndices = repmat(1:P, K, 1);
    indDecode = sub2ind(size(YalphaR), rowIndices, colIndices);
    
    % Apply decoding rule
    messagesRX = double(abs(YalphaR(indDecode)) < R^K * abs(YalphaRm1(indDecode)));

end