function [classified] = Bayesian_classifier(unknown_pattern, class1, class2)
    [inv_mean_covariance] = BC_inverse_covariance(class1, class2); %C^-1
    G_Class_1 = computeDiscrValue(unknown_pattern, class1, inv_mean_covariance);
    G_Class_2 = computeDiscrValue(unknown_pattern, class2, inv_mean_covariance);
    
    if (G_Class_1 > G_Class_2) classified = 1;end;
    if (G_Class_1 < G_Class_2) classified = 2;end;
    if (G_Class_1 == G_Class_2) classified = 0; end;
end