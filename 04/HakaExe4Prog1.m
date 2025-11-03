clear; clc; close all

% significance level
a = 0.05; 

% Simulations number
NMC = 10^4;

% interval boundaries
L = round(NMC*a/2);
U = round(NMC*(1-a/2));

% import data
T = HakaExe4Fun1(["Rented Bike Count", "Hour", "Seasons", "Holiday"]);
seasons = ["Winter", "Spring", "Summer", "Autumn"];
holidays = [" No Holiday", "Holiday"];

% pivot table
pT = pivot(T, Rows="Holiday", Method="median", DataVariable="Rented Bike Count");

% median
mi = [pT{:,2}(1) pT{:,2}(2)];

% tensor
tensor = zeros(2,4,24,2);

% Holiday
for i=[0,1]
    T1 = T(T.Holiday == i, ["Rented Bike Count", "Hour", "Seasons"]);
    
    % Seasons
    for j=1:4
        T2 = T1(T1.Seasons == j, ["Rented Bike Count", "Hour"]);
        
        % Hours
        for k=0:23
            T3 = T2{T2.Hour == k, "Rented Bike Count"};
            size_T3 = length(T3);

            % indices matrix
            idxs = unidrnd(size_T3, size_T3, NMC);

            % samples and sorted medians
            samples = T3(idxs);
            medians = sort(median(samples));

            tensor(i+1, j, k+1, 1) = medians(L);
            tensor(i+1, j, k+1, 2) = medians(U);  
        end
    end
end

% results
for i=[1,2]
    figure(i)
    sgtitle(holidays(i))

    for j=1:4
        subplot(2,2,j)
        hold on
        plot(0:23, squeeze(tensor(i, j, :, 1)))
        plot(0:23, squeeze(tensor(i, j, :, 2)))
        yline(mi(i), "-.r","total median")
        xlim([0,23])
        title(seasons(j))
    end
end

fprintf("The figures indicate that the overall median for both holidays and\n" + ...
        "non-holidays does not correspond to the seasonal median trend.\n" + ...
        "This may be due to reduced demand during winter, which drags the\n" + ...
        "median down. One exception to this pattern is observed around 7 am\n" + ...
        "during spring, summer, and autumn for non-holidays, but this only\n" + ...
        "lasts for a short period. A similar occurrence is also observed for\n" + ...
        "holidays. However, it's important to note that the results may not\n" + ...
        "be entirely reliable due to the small sample size, which doesn't\n" + ...
        "accurately represent the entire population. In general, the trends\n" + ...
        "for holidays and non-holidays seem to be similar, with an exception\n" + ...
        "noted around 8 am.\n\n")

fprintf("Postscript\n")
fprintf("For our analysis, we have use the same size for the bootstrap\n" + ...
        "samples as the original sample size.\n\n")