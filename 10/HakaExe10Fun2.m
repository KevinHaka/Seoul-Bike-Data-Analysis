function T1 = HakaExe10Fun2(T)
    n = height(T);
    idx_start = 1;
    idx_end = 1;
    temp_start = 1;

    for i=2:n
        if (T.Holiday(i) == 1)
            if (i - 1 - temp_start) > (idx_end - idx_start)
                idx_start = temp_start;
                idx_end = i - 1;
            end

            temp_start = i + 1;
        end
    end
    
    T1 = T{idx_start:idx_end, 1};