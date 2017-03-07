function [classified] = LDA_Matlab_classifier(unknown_pattern, class1, class2)
    classLabels = [ones(1, size(class1, 1)) 2 * ones(1, size(class2, 1))]';
    %puts labels to class1 and 2 as 1 and 2 resp
    superClass = [class1; class2]; %form superclass
    [classified] = classify(unknown_pattern, superClass, classLabels, 'linear');
end