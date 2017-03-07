function [zero, tt] = sc(superClass,  classLabels, cl, first_time, KNN, neighbours, PNN_function)
    classifier = {'MDC', 'k-NN', 'PNN', 'Bayesian', 'Quadratic Bayesian', 'Matlab SVM', 'Matlab LDA', 'Matlab QDA', 'Matlab DTC'};        
    patternsInBothClasses = size(superClass, 1);
    
    class1 = []; class2 = [];
    for i = 1 : size(superClass, 1)
        if (classLabels(i) == 1)
            class1 = [class1; superClass(i, :)];
        elseif (classLabels(i) == 2)
            class2 = [class2; superClass(i, :)];
        end
    end
    
    zero = 0;
    tt = zeros(2, 2);
    for t = 1 : patternsInBothClasses
        unknown_pattern = superClass(t, :);
        unknown_pattern_label = classLabels(t);

        switch (cl)
            case 1 %MDC
                if (first_time(cl) == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time(cl) = 1;
                end
                classified = MDC_classifier(unknown_pattern, class1, class2);
            case 2  %k-NN
                if (first_time(cl) == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time(cl) = 1;
                end
                classified = KNN_classifier(unknown_pattern, class1, class2, KNN, neighbours);
            case 3  %PNN
                if (first_time(cl) == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time(cl) = 1;
                end
                classified = PNN_classifier(unknown_pattern, class1, class2, PNN_function);                        
            case 4  %Bayesian
                if (first_time(cl) == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time(cl) = 1;
                end
                classified = Bayesian_classifier(unknown_pattern, class1, class2);          
            case 5  %Quadratic Bayesian
                if (first_time(cl) == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time(cl) = 1;
                end
                classified = QuadraticBayesian_classifier(unknown_pattern, class1, class2);
            case 6 %Matlab SVM
                if (first_time(cl) == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time(cl) = 1;
                end
                classified = SVM_Matlab_classifier(unknown_pattern, class1, class2);
            case 7 %Matlab LDA
                if (first_time(cl) == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time(cl) = 1;
                end
                classified = LDA_Matlab_classifier(unknown_pattern, class1, class2);
            case 8 %Matlab QDA
                if (first_time(cl) == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time(cl) = 1;
                end
                classified = QDA_Matlab_classifier(unknown_pattern, class1, class2);
            case 9 %Matlab DTC
                if (first_time(cl) == 0)
                    fprintf('%s\n', classifier{cl});
                    first_time(cl) = 1;
                end
                classified = DTC_Matlab_classifier(unknown_pattern, class1, class2);
        end
        if (classified ~= unknown_pattern_label) zero = zero + 1; end;
        tt = truth_table(unknown_pattern_label, classified, tt);
    end            
end

