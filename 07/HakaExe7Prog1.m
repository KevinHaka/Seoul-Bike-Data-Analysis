clear; clc; close all
warning('off'); % Disable all warnings

% import data
T = HakaExe7Fun1(["Rented Bike Count", "Hour", "Temperature(°C)", "Seasons"]);
seasons = ["Winter", "Spring", "Summer", "Autumn"];
funcs = ["y = b0 + b1*log(x)", "log(y) = b0 + b1*x", "log(y) = b0 + b1*log(x)", ...
         "y = b0 + b1/x", "1/y = b0 + b1*x", "1/y = b0 + b1/x", "y = b0 + b1*x", ...
         "y = b0 + b1*x + b2*x^2", "y = b0 + b1*x + b2*x^2 + b3*x^3", ...
         "y = b0 + b1*x + b2*x^2 + b3*x^3 + b4*x^4"];

% initial matrices
Rs = zeros(4,24);
fw = zeros(4,24);
fn = strings(4,24);

% Seasons
for season=1:4
    T1 = T(T.Seasons == season, 1:end-1);

    % Hours
    for hour=0:23
        T2 = T1(T1.Hour == hour, [3 1]);
        T2.Properties.VariableNames = ["x", "y"];

        [Rs(season,hour+1), fw(season,hour+1), fn(season,hour+1)] = HakaExe7Fun2(T2);
    end 
end

% results
imagesc(fw);
hold on
colormap(hsv(length(funcs)));
cb = colorbar;
cb.Ticks = 0.5:9.5;
cb.TickLabels = funcs;
title('Adjusted R-squared')
xlabel('Hour');
ylabel('Season');
set(gca, 'XTick', 1:24, 'XTickLabel', 0:23);
set(gca, 'YTick', 1:4, 'YTickLabel', seasons);
mesh(0.5:24.5,0.5:4.5, zeros(5,25), 'FaceColor', 'none', 'EdgeColor', 'k');
pos = get(gca, 'Position');
pos(1) = pos(1) - 0.025;
set(gca, 'Position', pos);

for i = 1:4 % seasons
    for j = 1:24 % hours
        value = Rs(i, j);
        textStr = num2str(value, '%.3f');
        text(j, i, textStr, 'HorizontalAlignment', 'center', 'Color', 'k');
    end
end

fprintf("As we can see from the results for all hours and all seasons, the\n" + ...
        "relationship between rented bikes and temperature appears to be\n" + ...
        "non-linear. The best model for most hours seems to be a polynomial\n" + ...
        "of the fourth degree. The adjusted R-squared is generally low,\n" + ...
        "especially in summer during very early hours, where the best model\n" + ...
        "explains almost nothing. The conclusion is that temperature alone\n" + ...
        "cannot explain the variance in the data, more variables are needed\n" + ...
        "to fit a better model.\n\n")