function [classified] = QuadraticBayesian_classifier(unknown_pattern, class1, class2)
    p1 = 0.5;
    p2 = 0.5;
    [mean_covariance] = BC_covariance(class1, class2); %C
    [inv_mean_covariance] = BC_inverse_covariance(class1, class2); %C^-1

    G_Class_1 = computeQuadrDiscrValue(unknown_pattern, class1, p1, mean_covariance, inv_mean_covariance);
    G_Class_2 = computeQuadrDiscrValue(unknown_pattern, class2, p2, mean_covariance, inv_mean_covariance);
    
    if (G_Class_1 > G_Class_2) classified = 1; end;
    if (G_Class_1 < G_Class_2) classified = 2; end;
    if (G_Class_1 == G_Class_2) classified = 0; end;
end