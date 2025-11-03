function T = HakaExe3Fun2(T)
    s = height(T);
    cleaner = false(s,1);
    counter = 0;
    while counter ~= s
        counter = counter +1;
    
        if (counter+23 <= s) && all(T.Hour(counter:counter+23)' == 0:1:23)
            cleaner(counter:counter+23) = true;
            counter = counter +23;
        else
            idx = counter;
            
            while T.Hour(counter+1) ~= 0 && counter ~= s-1
                counter = counter+1; 
            end
    
            cleaner(idx:counter) = false;
        end
    end
    T = T(cleaner,:);