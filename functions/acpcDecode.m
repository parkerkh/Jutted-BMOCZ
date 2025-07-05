%{
    Decode codewords for a (K,B)-ACPC.

    Inputs: 
        - v (K x C array of received codewords),
        - Htilde ((K-k+m) x K ACPC check matrix),
        - goutn (1 x K ACPC affine translation vector),
        - HoutTilde ((K-k) x K outer BCH check matrix),
        - cosetLeaders (2^(K-k) x K array of coset leaders from BCH syndrome table)

    Outputs: 
        - messages (B x C array of decoded messages),
        - uHat (1 x C array of estimated cyclic shifts)

    Notes:
        - C >= 1 is the number of codewords to decode
        - B = 16,106 is the message length
        - K = 31,127 is the codeword length
        - Use loadACPCarrays() to load the associated arrays for decoding
        - B = 16 --> k = 21, m = 5; B = 106 --> k = 113, m = 7
        - Both the (31,16)-ACPC and (127,106)-ACPC have a 2-bit 
          error-correction capability

    References:
        - P. Walk, P. Jung, B. Hassibi, and H. Jafarkhani, "MOCZ for blind 
          short-packet communication: Practical aspects," IEEE Trans. 
          Wireless Commun., vol. 19, no. 10, pp. 6675-6692, 2020.
%}

function [messages, uHat] = acpcDecode(v, Htilde, goutn, HoutTilde, cosetLeaders)
    
    % Declare needed variables
    if numel(goutn) == 31
        B = 16;
    else
        B = 106;
    end

    [K, C] = size(v);

    % Detect additive errors
    syndromes = mod(v.' * HoutTilde.', 2);
    syndTableIndices = bit2int(syndromes.', width(syndromes)) + 1;
    errors = cosetLeaders(syndTableIndices, :);

    % Correct additive errors
    cRX = mod(v + errors.', 2);

    % Generate 3D array of shifted codewords
    colIndicesShift = repmat(1:C, K, 1);
    shifted3D = zeros(K, C, K);

    for shiftInd = 0:K-1
        rowIndicesFshift = mod((0:K-1).' - shiftInd*ones(1, C), K) + 1;

        idxFshift = sub2ind(size(cRX), rowIndicesFshift, colIndicesShift);
        shifted3D(:, :, shiftInd+1) = cRX(idxFshift); 
    end
    
    % Multiply shifted codewords into check matrix
    prodIntoCheckMat = mod(pagemtimes((pagetranspose(shifted3D)-goutn), Htilde.'), 2);

    % Get row indices minimizing check
    rowSums = reshape(sum(prodIntoCheckMat, 2), C, K);
    
    % Estimate shifts
    [~, colMinInds] = min(rowSums, [], 2);
    uHat = ( K - (colMinInds-1) ).';

    % Correct shifts
    rowIndicesBshift = mod((0:K-1).' - (colMinInds-1).', K) + 1;
    idxBshift = sub2ind(size(cRX), rowIndicesBshift, colIndicesShift);
    cRXtilde = cRX(idxBshift);

    % Crop out messages
    messages = cRXtilde(end-B+1:end, :);

end