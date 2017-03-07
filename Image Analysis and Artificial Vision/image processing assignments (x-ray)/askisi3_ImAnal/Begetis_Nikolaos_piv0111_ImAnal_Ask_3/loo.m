function [zero, tt] = loo(superClass,  classLabels, cl, first_time, KNN, neighbours, PNN_function)
    classifier = {'MDC', 'k-NN', 'PNN', 'Bayesian', 'Quadratic Bayesian', 'Matlab SVM', 'Matlab LDA', 'Matlab QDA', 'Matlab DTC'};    
    patternsInBothClasses = size(superClass, 1);
    zero = 0;
    tt = zeros(2, 2);
    for looPatt = 1 : patternsInBothClasses
        scTemp = superClass;    %refresh
        clTemp = classLabels;   %refresh
        unknown_pattern = scTemp(looPatt, :);    %pick Pattern to be left out
        unknown_pattern_label = classLabels(looPatt);    %pick label of Pattern to be left out
        scTemp(looPatt, :) = [];    %LOO
        clTemp(looPatt) = [];   %LOO

        clear class1; class1 = [];
        clear class2; class2 = [];
        for t = 1 : size(scTemp, 1)
            if (clTemp(t) == 1)
                class1 = [class1; scTemp(t, :)];
            elseif (clTemp(t) == 2)
                class2 = [class2; scTemp(t, :)];
            end
        end

        switch (cl)
            case 1 %MDC
                if (first_time == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time = 1;
                end
                classified = MDC_classifier(unknown_pattern, class1, class2);
            case 2  %k-NN
                if (first_time == 0)                    
                    fprintf('%s\n', classifier{cl});
                    first_time = 1;
                end                
                classified = KNN_classifier(unknown_pattern, class1, class2, KNN, neighbours);
            case 3  %PNN
                if (first_time == 0)                    
                    fprintf('%s\n', classifier{cl});
                    first_time(cl) = 1;
                end
                classified = PNN_classifier(unknown_pattern, class1, class2, PNN_function);                        
            case 4  %Bayesian
                if (first_time == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time = 1;
                end
                classified = Bayesian_classifier(unknown_pattern, class1, class2);          
            case 5  %Quadratic Bayesian
                if (first_time == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time = 1;
                end
                classified = QuadraticBayesian_classifier(unknown_pattern, class1, class2);
            case 6 %Matlab SVM
                if (first_time == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time = 1;
                end
                classified = SVM_Matlab_classifier(unknown_pattern, class1, class2);
            case 7 %Matlab LDA
                if (first_time == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time = 1;
                end
                classified = LDA_Matlab_classifier(unknown_pattern, class1, class2);
            case 8 %Matlab QDA
                if (first_time == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time = 1;
                end
                classified = QDA_Matlab_classifier(unknown_pattern, class1, class2);
            case 9 %Matlab DTC
                if (first_time == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time = 1;
                end
                classified = DTC_Matlab_classifier(unknown_pattern, class1, class2);
        end
        if (classified ~= unknown_pattern_label) zero = zero + 1; end;
        tt = truth_table(unknown_pattern_label, classified, tt);
    end
end

