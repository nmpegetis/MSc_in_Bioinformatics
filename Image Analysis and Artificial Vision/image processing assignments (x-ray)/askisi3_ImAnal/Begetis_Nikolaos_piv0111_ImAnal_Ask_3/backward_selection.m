function [] = backward_selection(evaluation_method, cl, superClass, classLabels, patterns1, patterns2)
    patternsInBothClasses = size(superClass, 1);
    first_time = zeros(9, 1);
    classifier = {'MDC', 'k-NN', 'PNN', 'Bayesian', 'Quadratic Bayesian', 'Matlab SVM', 'Matlab LDA', 'Matlab QDA', 'Matlab DTC'};
    
	fprintf('Enter maximum number of features (up to %d): ', size(superClass, 2));
    N = input(' ');
    while (isempty(N) || N <= 0)
         N = input('Your choice is out of range. Try again. ');
    end
    fprintf('\n');
	
    if (cl == 2)
        KNN = menu('Choose between:', 'Single Nearest Neighbor', 'k - Nearest Neighbor', 'k+k - Nearest Neighbor', 'k - Nearest Neighbor with weighted votes');
        if (KNN == 1)
            neighbours = 1;
        elseif (KNN == 2 || KNN == 4)
            if (evaluation_method == 1)
                fprintf('Enter number of neighbours between 1-%d: ', patternsInBothClasses);
                neighbours = input(' ');
                %an o xristis den dwsei tpt i dwsei arithmo ektos oriwn tipwnetai sxetiko minima k kaleitai na ksanaepileksei
                while (isempty(neighbours) || neighbours <= 0 || neighbours > patternsInBothClasses)
                     neighbours = input('Your choice is out of range. Try again. ');
                end
            else
                fprintf('Enter number of neighbours between 1-%d: ', patternsInBothClasses - 1);
                neighbours = input(' ');
                %an o xristis den dwsei tpt i dwsei arithmo ektos oriwn tipwnetai sxetiko minima k kaleitai na ksanaepileksei
                while (isempty(neighbours) || neighbours <= 0 || neighbours > patternsInBothClasses - 1)
                     neighbours = input('Your choice is out of range. Try again. ');
                end
            end
            fprintf('\n');
        elseif (KNN == 3)
            if (patterns1 < patterns2)
                patt = patterns1;
            else
                patt = patterns2;
            end
            if (evaluation_method == 1)
                fprintf('Enter number of neighbours between 1-%d: ', patt);
                neighbours = input(' ');
                %an o xristis den dwsei tpt i dwsei arithmo ektos oriwn tipwnetai sxetiko minima k kaleitai na ksanaepileksei
                while (isempty(neighbours) || neighbours <= 0 || neighbours > patt)
                     neighbours = input('Your choice is out of range. Try again. ');
                end
            else
                fprintf('Enter number of neighbours between 1-%d: ', patt - 1);
                neighbours = input(' ');
                %an o xristis den dwsei tpt i dwsei arithmo ektos oriwn tipwnetai sxetiko minima k kaleitai na ksanaepileksei
                while (isempty(neighbours) || neighbours <= 0 || neighbours > patt - 1)
                     neighbours = input('Your choice is out of range. Try again. ');
                end
            end
            fprintf('\n');
        end
        PNN_function = 0;
    elseif (cl == 3)
        PNN_function = menu('Choose function', 'Gaussian', 'Exponential', 'Reciprocal');
        KNN = 0;
        neighbours = 0;
    elseif (cl == 4 || cl == 5)
        fprintf('%s\n', classifier{cl});
        fprintf('Unable to classify with these data.\n\n');
        return;
    elseif (cl == 7 || cl == 8)
        fprintf('%s\n', classifier{cl});
        fprintf('Unable to classify with so many features.\nThe pooled covariance matrix of TRAINING must be positive definite.\n\n');
        return;
    else
        KNN = 0;
        neighbours = 0;
        PNN_function = 0;
    end 
        
    tic;
    tStart(cl) = tic;
    scTemp = superClass;
    if (evaluation_method == 1)
        [zero, tt] = sc(scTemp,  classLabels, cl, first_time, KNN, neighbours, PNN_function);
    else
        [zero, tt] = loo(scTemp,  classLabels, cl, first_time(cl), KNN, neighbours, PNN_function);
    end
    first_time(cl) = 1;
    overallSuccess = 100 * ((patternsInBothClasses - zero) / patternsInBothClasses);
    success = overallSuccess;
    fc = nchoosek(1 : size(superClass, 2), size(superClass, 2));
    I = fc;
    
    
    while (size(fc, 2) > N)
        fc = nchoosek(1 : size(scTemp, 2), size(scTemp, 2) - 1);
        for j = 1 : size(fc, 1)
            m = 1; %arxikopoiisi tis 1is thesis tou pinaka f_leave_out
            for k = 1 : size(scTemp, 2) %epanalamvanoume gia na vroume poia xaraktiristika prepei na afisoume ektos
                 if (isempty((find(fc(j, :) == k)))) %an vroume xaraktiristiko pou den iparxei ston pinaka feat_comb, to prosthetoume ston pinaka f_leave_out
                    f_leave_out(m) = k;
                    m = m + 1;
                 end
            end

            temp = scTemp; %apothikeuoume tin superClass se ena proswrino pinaka gia na mporesoume na efarmosoume tis allages
            for l = m - 1 : -1 : 1 %antistrofi epanalipsi gia na mporesoume na afairesoume tis stiles me ta xaraktiristika pou den theloume
                temp(:, f_leave_out(l)) = [];    %LOO     
            end

            if (evaluation_method == 1)
                [zero, tt] = sc(temp,  classLabels, cl, first_time, KNN, neighbours, PNN_function);
            else
                [zero, tt] = loo(temp,  classLabels, cl, first_time(cl), KNN, neighbours, PNN_function);
            end
            overallSuccess = 100 * ((patternsInBothClasses - zero) / patternsInBothClasses);
            if (overallSuccess >= success)
                s_c = temp;
                feature_combination = fc(j, :);
                success = overallSuccess;
                truthtable = tt;
            end
        end
        I = I(feature_combination);
        scTemp = s_c;
    end

    feature_combination = I;
    tElapsed(cl) = toc(tStart(cl));

    if (success ~= 0)
        fprintf('Accuracy Combination: '); disp(feature_combination);
        fprintf('Success: %3.0f%%\n', success);
        fprintf('Time Elapsed: %.2f\n', tElapsed(cl));        
        fprintf('Truth Table\n%d\t%d\n%d\t%d\n\n', truthtable(1, 1), truthtable(1, 2), truthtable(2, 1), truthtable(2, 2));
    else
        fprintf('\nSuccess: %1.0f%% for every feature combination\n', success);
    end
end