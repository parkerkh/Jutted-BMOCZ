## Functions

This folder contains a selection of MATLAB functions for J-BMOCZ, ACPC encoding and decoding, zero stability analysis, and more. 

A brief description of each function is given below. Use of the functions is illustrated in the /examples folder of this repository.

- `acpcDecode()` decode codewords for a ($K,B$)-ACPC 
- `acpcDecode()` encode messages using a ($K,B$)-ACPC
- `correctPolysWithTemplate()` correct zero rotation for J-BMOCZ using template cross-correlation 
- `estimateZeroStability()` measure the zero stability of a polynomial given its roots
- `generateAllZeros()` generate all zeros in the J-BMOCZ zero constellation 
- `getTemplate()` get J-BMOCZ template transform transform in sampled form 
- `idftDizet()` decode polynomials for BMOCZ using the oversampled (IDFT-based) DiZeT decoder 
- `jbmoczMessageToPoly()` map messages to zero patterns and polynomials for J-BMOCZ
- `loadACPCarrays()` load the arrays needed for ACPC encoding and decoding
- `perturbPoly()` perturb a polynomial with AWGN and save its perturbed roots
- `standardDizet()` decode polynomials for BMOCZ using the standard DiZeT decoder  
- `zerosToPoly()` map zeros to polynomial coefficients without using MATLAB's `poly()` function

**Note:** we do not claim for the functions to be well written or thoroughly commented. Nevertheless, we hope that you find them useful.