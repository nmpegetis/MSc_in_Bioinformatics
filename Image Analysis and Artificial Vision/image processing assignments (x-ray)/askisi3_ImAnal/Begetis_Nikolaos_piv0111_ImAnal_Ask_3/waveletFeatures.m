function [features] = waveletFeatures(A, features)
    nbcol = size(A, 1);
    % Perform single-level decomposition 
    % of A using db1. 
    [cA1, cH1, cV1, cD1] = dwt2(A, 'db1');
    A1 = wcodemat(cA1, nbcol); %subband LL  
    H1 = wcodemat(cH1, nbcol); %subband HL  
    V1 = wcodemat(cV1, nbcol); %subband LH  
    D1 = wcodemat(cD1, nbcol); %subband HH  

    features(13) = mean2(A1);
    features(14) = mean2(H1);
    features(15) = mean2(V1);
    features(16) = mean2(D1);
    features(17) = std2(A1);
    features(18) = std2(H1);
    features(19) = std2(V1);
    features(20) = std2(D1);
end