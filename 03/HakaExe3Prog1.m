clear; clc; close all

% significance level
a = 0.05; 

% import data
T = HakaExe3Fun1(["Hour", "Rented Bike Count", "Seasons"]);
seasons = ["Winter", "Spring", "Summer", "Autumn"];

% data cleaning
T = HakaExe3Fun2(T);

% mean differences and h tensor
means_diffs_tensor = zeros(24,24,4);
h_tensor = zeros(24,24,4);

% seasons
for i=1:4
    t = T(T.Seasons == i, ["Hour", "Rented Bike Count"]);
    
    % "A" hour
    for j=0:23
        t1 = t{t.Hour == j, "Rented Bike Count"};
        
        % "B" hour
        for k=0:23
            t2 = t{t.Hour == k, "Rented Bike Count"};

            % differences
            diffs = t1 - t2;

            means_diffs_tensor(j+1, k+1, i) = abs(mean(diffs));
            h_tensor(j+1, k+1, i) = ttest(diffs, 0, 'Alpha', a);
        end
    end
end

% results
for i=1:4
    figure(1)
    sgtitle("means of differences")
    subplot(2,2,i)
    heatmap(0:23, 0:23, means_diffs_tensor(:,:,i))
    title(seasons(i))
    
    figure(2)
    sgtitle("p-values")
    subplot(2,2,i)
    heatmap(0:23, 0:23, h_tensor(:,:,i))
    title(seasons(i))
end

fprintf("The biggest difference for the rented bikes is between the morning\n" + ...
    "hours and 6 PM. This is likely because 6 pm is a good time for people\n" + ...
    "to go for a ride. An exception to that is 8 AM, where the difference is\n" + ...
    "relatively small compared to the rest of the morning hours. While the\n" + ...
    "morning hours have a small number of rented bikes, the number increases\n" + ...
    "significantly at 8 AM, likely because people are renting bikes to commute to work.\n\n")
fprintf("As for the null hypothesis, assuming that the difference is zero,\n" + ...
    "we cannot discern any discernible pattern between seasons and the hours.\n" + ...
    "For the hours where the null hypothesis has been accepted at a significance\n" + ...
    "level of %.2f, they are possibly random and they have no interest.\n\n", a);
