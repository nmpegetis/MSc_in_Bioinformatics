function [d] = computeQuadrDiscrValue (unknown_pattern, class, p, mean_covariance, inv_mean_covariance)
    Mean_Class = mean(class); %m
    G = (unknown_pattern - Mean_Class) * inv_mean_covariance * (unknown_pattern - Mean_Class)'; %(x-m)^T*C^-1*(x-m)
    d = log(p) - 0.5 * log(det(mean_covariance)) - 0.5 * G; %ln(p)-0.5*ln(C)-0.5*(x-m)^T*C^-1*(x-m)
end