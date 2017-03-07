function [d] = computeDiscrValue (unknown_pattern, class, inv_mean_covariance)
    Mean_Class = mean(class); %m
    G1 = (unknown_pattern * inv_mean_covariance) * Mean_Class'; %x^T*C^-1*m
    G2 = (Mean_Class * inv_mean_covariance) * Mean_Class'; %m^T*C^-1*m
    d = G1 - 0.5 * G2; %x^T*C^-1*m-0.5*m^T*C^-1*m
end