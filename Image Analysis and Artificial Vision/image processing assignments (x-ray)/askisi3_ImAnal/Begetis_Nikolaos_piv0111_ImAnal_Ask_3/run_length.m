%Για την εξαγωγή των run-length χαρακτηριστικών χρησιμοποίηθηκε το Gray Level Run Length Matrix Toolbox
%http://www.mathworks.com/matlabcentral/fileexchange/17482-gray-level-run-length-matrix-toolbox
%που περιλαμβάνει τις συναρτήσεις findmaxnum.m, grayrlmatrix.m, grayrlprops.m, rle_0.m, rle_45.m και zigzag.m
%Δημιουργός: Xunkai Wei, Gray Level Run Length Matrix Toolbox v1.0,Software,Beijing Aeronautical Technology Research Center, 2007
function [features] = run_length(I, features)
    [glrlm, SI] = grayrlmatrix(I, 'GrayLimits', [0 255], 'NumLevels', 4, 'Offset', [1; 2; 3; 4]);
    
    stats = grayrlprops(glrlm);

    SRE = stats(:, 1);
    LRE = stats(:, 2);
    GLN = stats(:, 3);
    RLN = stats(:, 4);
    RP = stats(:, 5);

%    [S' L' G' R1' R2']

    features(21) = mean(SRE);
    features(22) = max(SRE) - mean(SRE);
    features(23) = mean(LRE);
    features(24) = max(LRE) - mean(LRE);
    features(25) = mean(GLN);
    features(26) = max(GLN) - mean(GLN);
    features(27) = mean(RLN);
    features(28) = max(RLN) - mean(RLN);
    features(29) = mean(RP);
    features(30) = max(RP) - mean(RP);
end