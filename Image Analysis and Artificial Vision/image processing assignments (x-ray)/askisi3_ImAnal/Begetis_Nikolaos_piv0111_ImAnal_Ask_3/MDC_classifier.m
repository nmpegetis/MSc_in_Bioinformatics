function [classified] = MDC_classifier(unknown_pattern, class1, class2)
    N_feat = size(unknown_pattern, 2);

    for i = 1 : N_feat
        Mean_Class1(i) = mean(class1(:, i));
        Mean_Class2(i) = mean(class2(:, i));
    end

    G_Class_1 = 0;
    G_Class_2 = 0;
    for i = 1 : N_feat
        G_Class_1 = G_Class_1 + Mean_Class1(i) * unknown_pattern(i) - 0.5 * Mean_Class1(i) ^ 2;
        G_Class_2 = G_Class_2 + Mean_Class2(i) * unknown_pattern(i) - 0.5 * Mean_Class2(i) ^ 2;
    end
    
    if (G_Class_1 > G_Class_2) classified = 1; end;
    if (G_Class_1 < G_Class_2) classified = 2; end;
    if (G_Class_1 == G_Class_2) classified = 0; end;
end