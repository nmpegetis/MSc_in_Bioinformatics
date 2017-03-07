function [classified] = PNN_classifier(unknown_pattern, class1, class2, PNN_function)
    N_feat = size(unknown_pattern, 2);							
    N_patt_C1 = size(class1, 1);
    N_patt_C2 = size(class2, 1);
    sigma = 0.24;

    %ipologismos twn discriminant functions simfwna me tous tipous twn
    %Gaussian, Exponential kai Reciprocal analoga me tin epilogi tou xristi

    val1 = (2 * pi) ^ (N_feat / 2) * (sigma ^ N_feat) * N_patt_C1;
    val2 = (2 * pi) ^ (N_feat / 2) * (sigma ^ N_feat) * N_patt_C2;
    
    if (PNN_function == 1) %Gaussian
        sumi = 0;
        for i = 1 : N_patt_C1
            sumj = 0;
            for j = 1 : N_feat
                sumj = sumj + (class1(i, j) - unknown_pattern(j)) ^ 2;
            end
            sumi = sumi + exp(-sumj / (2 * sigma ^ 2));
        end
        G_Class_1 = sumi / val1;


        val2 = (2 * pi) ^ (N_feat / 2) * (sigma ^ N_feat) * N_patt_C2;
        sumi = 0;
        for i = 1 : N_patt_C2
            sumj = 0;
            for j = 1 : N_feat
                sumj = sumj + (class2(i, j) - unknown_pattern(j)) ^ 2;
            end
            sumi = sumi + exp(-sumj / (2 * sigma ^ 2));
        end
        G_Class_2 = sumi / val2;
    elseif (PNN_function == 2) %Exponential
        sumi = 0;
        for i = 1 : N_patt_C1
            sumj = 0;
            for j = 1 : N_feat
                sumj = sumj + abs(class1(i, j) - unknown_pattern(j));
            end
            sumi = sumi + exp(-sumj / sigma);
        end
        G_Class_1 = sumi / val1;


        val2 = (2 * pi) ^ (N_feat / 2) * (sigma ^ N_feat) * N_patt_C2;
        sumi = 0;
        for i = 1 : N_patt_C2
            sumj = 0;
            for j = 1 : N_feat
                sumj = sumj + abs(class2(i, j) - unknown_pattern(j));
            end
            sumi = sumi + exp(-sumj / sigma);
        end
        G_Class_2 = sumi / val2;
    elseif (PNN_function == 3) %Reciprocal
        sumi = 0;
        for i = 1 : N_patt_C1
            sumj = 0;
            for j = 1 : N_feat
                sumj = sumj + (class1(i, j) - unknown_pattern(j)) ^ 2;
            end
            sumi = sumi + 1 / (1 + sumj / (sigma ^ 2));
        end
        G_Class_1 = sumi / val1;


        val2 = (2 * pi) ^ (N_feat / 2) * (sigma ^ N_feat) * N_patt_C2;
        sumi = 0;
        for i = 1 : N_patt_C2
            sumj = 0;
            for j = 1 : N_feat
                sumj = sumj + (class2(i, j) - unknown_pattern(j)) ^ 2;
            end
            sumi = sumi + 1 / (1 + sumj / (sigma ^ 2));
        end
        G_Class_2 = sumi / val2;
    end
    
    if (G_Class_1 > G_Class_2) classified = 1; end;
    if (G_Class_1 < G_Class_2) classified = 2; end;
    if (G_Class_1 == G_Class_2) classified = 0; end;
end