function [classified] = KNN_classifier(unknown_pattern, class1, class2, KNN, neighbours)
    features = size(class1, 2); %features in each class
    N1 = size(class1, 1); %patterns in class1
    N2 = size(class2, 1); %patterns in class2

    %find distances of unknown_pattern from patterns of class 1
    for i = 1 : N1
        d = 0;
        for j = 1 : features
            d = d + sqrt((unknown_pattern(j) - class1(i, j)) ^ 2);
        end
        val1(i, 1) = d;
        val1(i, 2) = 1;
    end

    %find distances of unknown_pattern from patterns of class 2
    for i = 1 : N2
        d = 0;
        for j = 1 : features
            d = d + sqrt((unknown_pattern(j) - class2(i, j)) ^ 2);
        end
        val2(i, 1) = d;
        val2(i, 2) = 2;
    end
    
    if (KNN == 1)
        q1 = min(val1);
        q2 = min(val2);
    
        if (q1 < q2) classified = 1; 
        else classified = 2;
        end
    elseif (KNN == 2)
        val = [val1; val2];
        sort_val = sortrows(val, 1); %taksinomisi twn apostasewn se auksousa seira
        counter1 = 0; counter2 = 0;

        for i = 1 : neighbours %pairnoume tous k prwtous geitones pou eixe epileksei o xristis na trexei to programma
            if (sort_val(i, 2) == 1) %an anikei stin 1i klasi auksanetai o metritis tis 1is klasis alliws auksanetai o metritis tis 2is klasis
                counter1 = counter1 + 1; 
            else
                counter2 = counter2 + 1;
            end
        end
        
        if (counter1 > counter2) classified = 1; end;
        if (counter1 < counter2) classified = 2; end;
        if (counter1 == counter2) classified = 0; end;
    elseif (KNN == 3)
        sort_val1 = sort(val1(:, 1)); %taksinomisi twn apostasewn tis klasis1 se auksousa seira
        sort_val2 = sort(val2(:, 1)); %taksinomisi twn apostasewn tis klasis2 se auksousa seira
        
        d1 = mean(sort_val1(1 : neighbours));
        d2 = mean(sort_val2(1 : neighbours));

        if (d1 < d2) classified = 1; end;
        if (d1 > d2) classified = 2; end;
        if (d1 == d2) classified = 0; end
    elseif (KNN == 4)
        val = [val1; val2];
        sort_val = sortrows(val, 1); %taksinomisi twn apostasewn se auksousa seira
        votes1 = 0; votes2 = 0; %the votes of these records are weighted according to the inverse square of their distances

        for i = 1 : neighbours %pairnoume tous k prwtous geitones pou eixe epileksei o xristis na trexei to programma
            if (sort_val(i, 2) == 1)
                votes1 = votes1 + 1 / (sort_val(i, 1) + 1);
            else
                votes2 = votes2 + 1 / (sort_val(i, 1) + 1);
            end
        end
        
        if (votes1 > votes2) classified = 1; end;
        if (votes1 < votes2) classified = 2; end;
        if (votes1 == votes2) classified = 0; end
    end
end