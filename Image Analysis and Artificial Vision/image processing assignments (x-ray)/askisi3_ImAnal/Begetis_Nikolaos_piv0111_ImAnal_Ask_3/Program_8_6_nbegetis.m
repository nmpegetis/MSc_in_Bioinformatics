function [] = Program_8_6_nbegetis()
    clc; echo off; close all; clear all;

    %data from astrocytomas images
    class1 = load('Class_1.dat');
    class2 = load('Class_2.dat');
    patterns1 = size(class1, 1);
    patterns2 = size(class2, 1);
    classLabels = [ones(1, size(class1, 1)) 2 * ones(1, size(class2, 1))]'; %puts labels for class1 and 2 as 1 and -1
    superClass = [class1; class2];  %form superclass
    [superClass] = normalize(superClass);
    
    selection_method = menu('Choose features selection method', 'Exhaustive Search', 'Features Ranking and Exhaustive Search', 'Sequential Forward Selection', 'Sequential Backward Selection');
    evaluation_method = menu('Choose evaluation method', 'Self Consistency', 'Leave One Out');
    classifier = menu('Choose classifier', 'MDC', 'k-NN', 'PNN', 'Bayesian', 'Quadratic Bayesian', 'Matlab SVM', 'Matlab LDA', 'Matlab QDA', 'Matlab DTC');
    
    fprintf('This may take a while. Please wait.\n\n');
    switch (selection_method)
        case 1 %exhaustive_search(superClass, classLabels)
            exhaustive_search(evaluation_method, classifier, superClass, classLabels, patterns1, patterns2);
        case 2
            features_ranking(evaluation_method, classifier, superClass, classLabels, patterns1, patterns2);
        case 3
            forward_selection(evaluation_method, classifier, superClass, classLabels, patterns1, patterns2);
        case 4
            backward_selection(evaluation_method, classifier, superClass, classLabels, patterns1, patterns2);
    end
end