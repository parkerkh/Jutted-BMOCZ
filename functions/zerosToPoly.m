%{
    Map zeros to polynomial coefficients.

    Intputs:
        - zerosMat (K x P array of polynomial zeros),
        - normalize (0 --> don't normalize coefficients, 1 --> normalize coefficients),
        - E (coefficient energy, if normalized)

    Outputs:
        - polyMat ((K+1) x P array of associated polynomial coefficients)

    Notes:
        - P >= 1 is the number of polynomials to generate
        - Coefficients are returned in descending order, i.e.,
          the leading coefficient is first
        - The functions avoids using MATLAB's poly function and is
          based on Appendix D in [1].

    References:
        [1] A. Sahin, "Over-the-air majority vote computation with 
        modulation on conjugate-reciprocal zeros," IEEE Trans. Wireless 
        Commun., vol. 23, no. 11, pp. 17714-17726, 2024.
%}

function polyMat = zerosToPoly(zerosMat, normalize, E)

    K = height(zerosMat);

    % Map zeros to coefficients
    k = 0:K;
    p = K + 1;
    angles = exp(1i*2*pi/p);
    mList = (0:p-1).';
    polyMat = flipud(angles .^ (-mList*k) * prod(angles .^ mList - permute(zerosMat, [3 2 1]), 3) / p);

    % Normalize coefficients
    if normalize
        polyMat = polyMat ./ vecnorm(polyMat, 2, 1) * sqrt(E);
    end

end