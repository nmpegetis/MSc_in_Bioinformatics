function [] = features_ranking(evaluation_method, cl, superClass, classLabels, patterns1, patterns2)
    patternsInBothClasses = size(superClass, 1);
	first_time = zeros(9, 1);
    temp = superClass;
    clear superClass; superClass = [];
    
    if (patterns1 <= patterns2)
        min_patt = patterns1;
    else
        min_patt = patterns2;
    end
    
    no = floor(min_patt / 3);
    I = rankfeatures(temp', classLabels, 'CRITERION', 'wilcoxon', 'NumberOfIndices', no);
    I = sort(I,'ascend')
    for i = 1 : length(I)
        pattern = temp(:, I(i));
        superClass = [superClass pattern];
    end
    
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
        end
        PNN_function = 0;
    elseif (cl == 3)
        PNN_function = menu('Choose function', 'Gaussian', 'Exponential', 'Reciprocal');
        KNN = 0;
        neighbours = 0;
    else
        KNN = 0;
        neighbours = 0;
        PNN_function = 0;
    end
    
    tic;
    tStart(cl) = tic;
    success = 0;
    for i = 1 : no %5 epanalipseis wste na petixoume mexri 5 dinatous sindiasmous xarakthristikwn
        fc = nchoosek(1 : size(superClass, 2), i); %paragoume olous tous dinatous sindismous xaraktiristikwn, ana ena, ana dio, ana tria, ana tessera k ana pente
        f_leave_out = 0; %arxikopoiisi tou pinaka pou tha periexei ta xaraktiristika pou prepei na afisoume ektos
        for j = 1 : size(fc, 1)
            m = 1; %arxikopoiisi tis 1is thesis tou pinaka f_leave_out
            for k = 1 : size(superClass, 2) %epanalamvanoume 5 fores gia na vroume poia xaraktiristika prepei na afisoume ektos
                 if (isempty((find(fc(j, :) == k)))) %an vroume xaraktiristiko pou den iparxei ston pinaka feat_comb, to prosthetoume ston pinaka f_leave_out
                    f_leave_out(m) = k;
                    m = m + 1;
                 end
            end

            temp = superClass; %apothikeuoume tin superClass se ena proswrino pinaka gia na mporesoume na efarmosoume tis allages
            for l = m - 1 : -1 : 1 %antistrofi epanalipsi gia na mporesoume na afairesoume tis stiles me ta xaraktiristika pou den theloume
                temp(:, f_leave_out(l)) = [];    %LOO     
            end

            if (evaluation_method == 1)
                [zero, tt] = sc(superClass,  classLabels, cl, first_time, KNN, neighbours, PNN_function);
            else
                [zero, tt] = loo(temp,  classLabels, cl, first_time(cl), KNN, neighbours, PNN_function);
            end
            first_time(cl) = 1;
            
            overallSuccess = 100 * ((patternsInBothClasses - zero) / patternsInBothClasses);
            if (overallSuccess > success)
                feature_combination = fc(j, :);
                feature_combination = I(feature_combination(:));
                success = overallSuccess;
                truthtable = tt;
            end
        end
    end
    tElapsed(cl) = toc(tStart(cl));
    
    if (success ~= 0)
        fprintf('Accuracy Combination:\t%d\t%d\t%d\t%d\t%d\t%d\n\n', feature_combination);
        fprintf('\nSuccess: %3.0f%%\n', success);
        fprintf('Time Elapsed: %.2f\n', tElapsed(cl));        
        fprintf('Truth Table\n%d\t%d\n%d\t%d\n\n', truthtable(1, 1), truthtable(1, 2), truthtable(2, 1), truthtable(2, 2));
    else
        fprintf('\nSuccess: %1.0f%% for every feature combination\n', success);
    end
end