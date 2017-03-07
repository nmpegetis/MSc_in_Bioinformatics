function [classified] = classify_X(X_patt, SVMStruct)
    G_class = svmclassify(SVMStruct, X_patt, 'Showplot', false);
    %classify pattern
    if (G_class >= 0) classified = 1; %i.e. correctly classified
    elseif (G_class <= 0) classified = 2; %i.e. correctly classified
    else classified = 0; %i.e. incorrectly classified
    end
end