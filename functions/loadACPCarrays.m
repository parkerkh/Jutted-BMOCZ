%{
    Load arrays needed for ACPC encoding and decoding.

    Inputs:
        - B (message length)
        - pathToArrays(full path of folder containing the ACPC arrays)

    Outputs:
        - Gtilde (B x K ACPC generator matrix)
        - Htilde ((K-k+m) x K ACPC check matrix),
        - goutn (1 x K ACPC affine translation vector),
        - HoutTilde ((K-k) x K outer BCH check matrix),
        - cosetLeaders (2^(K-k) x K array of coset leaders from BCH syndrome table)

    Notes:
        - B = 16 --> K = 31, k = 21, m = 5
        - B = 106 --> K = 127, k = 113, m = 7
%}

function [Gtilde, Htilde, goutn, HoutTilde, cosetLeaders] = loadACPCarrays(B, pathToArrays)

    % Add path to arrays
    addpath(pathToArrays)

    % Load arrays
    if B == 16
        load Gtilde31.mat
        load Htilde31.mat
        load goutn31.mat
        load HoutTilde31.mat
        load cosetLeaders31.mat
    else
        load Gtilde127.mat
        load Htilde127.mat
        load goutn127.mat
        load HoutTilde127.mat
        load cosetLeaders127.mat
    end

end