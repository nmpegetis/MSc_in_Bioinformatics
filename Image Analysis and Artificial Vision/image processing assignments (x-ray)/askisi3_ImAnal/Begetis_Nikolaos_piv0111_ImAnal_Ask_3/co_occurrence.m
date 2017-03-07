function [features] = co_occurrence (I, features) 
    [glcm, SI] = graycomatrix(I, 'GrayLimits', [0 255], 'NumLevels', 4, 'Offset', ...
        [0 1; -1 0; -1 1; -1 -1], 'Symmetric', true); % 0(-), 90(|), 45(/), 135(\), 1 pixel
    %neigbour

    stats = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
    C = stats.Contrast;
    Cr = stats.Correlation;
    E = stats.Energy;
    H = stats.Homogeneity;

%    [C' Cr' E' H']

    features(5) = mean(C);
    features(6) = max(C) - mean(C);
    features(7) = mean(Cr);
    features(8) = max(Cr) - mean(Cr);
    features(9) = mean(E);
    features(10) = max(E) - mean(E);
    features(11) = mean(H);
    features(12) = max(H) - mean(H);

%     disp('Energy = Uniformity, Uniformity of energy, Angular second moment.')
%     disp('Contrast = Variance, Inertia.');
end