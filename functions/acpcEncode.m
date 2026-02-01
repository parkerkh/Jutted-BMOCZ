%{
    Encode messages using a (K,B)-ACPC.

    Inputs: 
        - messages (B x M array of binary messages; 
                    each column is a message)   
        - Gtilde (B x K ACPC generator matrix)
        - goutn (1 x K affine translation vector)

    Outputs: 
        - codewords (K x M array of ACPC codewords;
                     each column is a codeword)

    Notes:  
        - M >= 1 is the number of messages to encode
        - B = 16,106 is the message length 
        - K = 31,127 is the codeword length 
        - Use loadACPCarrays() to load the associated arrays for encoding
        - Both the (31,16)-ACPC and (127,106)-ACPC have a 2-bit
          error-correction capability

    References:
        - P. Walk, P. Jung, B. Hassibi, and H. Jafarkhani, "MOCZ for blind 
          short-packet communication: Practical aspects," IEEE Trans. 
          Wireless Commun., vol. 19, no. 10, pp. 6675-6692, 2020.
%}

function codewords = acpcEncode(messages, Gtilde, goutn)

    % Perform encoding
    codewords = mod(messages.' * Gtilde + goutn, 2).';
    
end