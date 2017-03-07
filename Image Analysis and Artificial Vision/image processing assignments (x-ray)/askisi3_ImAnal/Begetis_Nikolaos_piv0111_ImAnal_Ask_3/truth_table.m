function [tt] = truth_table(unknown_pattern_label, classified, tt)
    if (classified == 1 || classified == 2) 
        tt(unknown_pattern_label, classified) = tt(unknown_pattern_label, classified) + 1;
    elseif(classified == 0)
        if (unknown_pattern_label == 1)
            tt(unknown_pattern_label, 2) = tt(unknown_pattern_label, 2) + 1;
        else
            tt(unknown_pattern_label, 1) = tt(unknown_pattern_label, 1) + 1;
        end
    end
end