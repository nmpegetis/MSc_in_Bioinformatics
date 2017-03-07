function [features] = createClassFeatureFiles(a)
    a = double(a);      
    %find mean value and standard deviation

    features(1) = mean2(a);
    features(2) = std2(a);
    features(3) = skewness(a(:));
    features(4) = kurtosis(a(:));
    features = co_occurrence(a, features);
    features = waveletFeatures(a, features);
    features = run_length(a, features);
    features = laws(a, features);
end