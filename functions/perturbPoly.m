%{
    Perturb polynomial with AWGN and save the perturbed zeros.

    Inputs:
        - polyToPerturb ((K+1) x 1 array of the polynomial coefficients)
        - Nsim (number of independent noise realizations)
        - EbN0 (Eb/N0 in dB)

    Outputs:
        - perturbedRoots(K x Nsim array of the perturbed zeros)

    Notes:
        - Coefficients need to be in descending order, i.e., 
          the leading coefficient is first
%}

function perturbedRoots = perturbPoly(polyToPerturb, Nsim, EbN0)
    
    % Declare needed variables
    K = height(polyToPerturb) - 1;
    EsN0 = EbN0 + 10*log10(K/(K+1));
    N0 = 10^(-EsN0 / 10);

    % Repeat polynomial Nsim times
    polyRepeated = repmat(polyToPerturb, 1, Nsim);
    
    % Perturb polynomial with Nsim independent AWGN realizations
    perturbedPolys = polyRepeated + ... 
                     sqrt(N0/2)*(randn(size(polyRepeated)) + 1j*randn(size(polyRepeated)));

    % Get roots of the perturbed polynomials
    perturbedRoots = ones(K, Nsim);
    for n = 1:Nsim
        perturbedRoots(:, n) = roots(perturbedPolys(:, n));
    end

end