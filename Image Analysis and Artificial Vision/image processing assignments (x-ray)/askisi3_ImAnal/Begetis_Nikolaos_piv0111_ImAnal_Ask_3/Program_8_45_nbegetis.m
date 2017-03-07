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
    
    choice = menu('Choose features selection method', 'Exhaustive search', 'Features ranking and Exhaustive search', 'Sequential Forward Selection', 'Sequential Backward Selection');
    fprintf('This may take a while. Please wait.\n\n');
    switch (choice)
        case 1 %exhaustive_search(superClass, classLabels)
            exhaustive_search(superClass, classLabels, patterns1, patterns2);
        case 2            
            features_ranking(superClass, classLabels, patterns1, patterns2);
        case 3
            forward_selection(superClass, classLabels, patterns1, patterns2);
        case 4
            backward_selection(superClass, classLabels, patterns1, patterns2);
    end
end