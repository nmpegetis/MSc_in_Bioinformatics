function [inv_m_covar] = BC_inverse_covariance(class1, class2)
    covar1 = cov(class1, 1); %covariance of class1
    covar2 = cov(class2, 1); %covariance of class2
    m_covar = (covar1 + covar2) / 2; %mean covariance
    inv_m_covar = inv(m_covar); %inverse of mean covariance
end