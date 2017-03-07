function [features] = laws(I, features)
    mask(:, :, 1) = [1, 2, 1; 2, 4, 2; 1, 2, 1];
    mask(:, :, 2) = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
    mask(:, :, 3) = [-1, 2, -1; -2, 4, -2; -1, 2, -1];
    mask(:, :, 4) = [-1, -2, -1; 0, 0, 0; 1, 2, 1];
    mask(:, :, 5) = [1, 0, -1; 0, 0, 0; -1, 0, 1];
    mask(:, :, 6) = [1, -2, 1; 0, 0, 0; -1, 2, -1];
    mask(:, :, 7) = [-1, -2, -1; 2, 4, 2; -1, -2, -1];
    mask(:, :, 8) = [1, 0, -1; -2, 0, 2; 1, 0, -1];
    mask(:, :, 9) = [1, -2, 1; -2, 4, -2; 1, -2, 1];
    
    k = 30;    
    for i = 1 : 9
        A = conv2(I, mask(:, :, i));
        features(k + 1) = mean2(A);
        features(k + 2) = std2(A);
        features(k + 3) = skewness(A(:));
        features(k + 4) = kurtosis(A(:));
        k = k + 4;
    end

end