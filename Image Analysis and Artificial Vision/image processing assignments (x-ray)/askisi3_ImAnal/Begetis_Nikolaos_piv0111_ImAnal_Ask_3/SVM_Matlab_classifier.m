function [classified] = SVM_Matlab_classifier(unknown_pattern, class1, class2)
    warning off all
    classified = 0;
    classLabels = [ones(1, size(class1, 1)) (-1) * ones(1, size(class2, 1))]';
    %puts labels to class1 and 2 as 1 and -1 resp
    superClass = [class1; class2]; %form superclass
    [SVMStruct] = designSVM(superClass, classLabels);
    [classified] = classify_X(unknown_pattern, SVMStruct);
end