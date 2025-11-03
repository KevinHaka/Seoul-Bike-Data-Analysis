clear; clc; close all

% Initialize parallel pool
if isempty(gcp('nocreate'))
    parpool('local');
end

tic % timer start

% import data
T = HakaExe9Fun1();
T = T(T.Holiday == 0, 2:end-1);
seasons = ["Winter", "Spring", "Summer", "Autumn"];

% data cleaning
T = HakaExe9Fun2(T);

% initialisation of lag values
lags = 1:24;

% initial matrix
data = zeros(4,24,length(lags));

fprintf('lag = ')
for lag=1:length(lags) % lags
    fprintf('%d ', lags(lag))

    for season=1:4 % Seasons
        T1 = T(T.Seasons == season,  1:end-1);

        % preparing the fitting data table
        T2_len = height(T1)-lags(lag);
        var_types = arrayfun(@(x) {'double'}, 1:2+lags(lag)*8);
        T2 = table('size',[T2_len 2+lags(lag)*8], 'VariableTypes', var_types);
        T2(:,1:2) = T1(lags(lag)+1:end, 1:2);
        T2.Properties.VariableNames(:,1:2) = ["Rented Bike Count", "Hour"];

        for i=1:lags(lag)
            colnames = ["T(-%d)", "H(-%d)", "WS(-%d)", "V(-%d)", ...
                        "DPT(-%d)", "SR(-%d)", "R(-%d)", "S(-%d)"];
            colnames = arrayfun(@(x) sprintf(x, i), colnames);

            T2(:, 3+8*(i-1):2+8*i) = T1(lags(lag)+1-i:end-i, 3:end);
            T2.Properties.VariableNames(:, 3+8*(i-1):2+8*i) = colnames;
        end

        % parallel section
        T2 = T2(:,[2:end 1]);
        parfor (hour=0:23) % Hours
            T3 = T2(T2.Hour==hour, 2:end);
            mdl = stepwiselm(T3, 'Upper', 'linear', 'Verbose', 0);
            data(season, hour+1, lag) = mdl.Rsquared.Ordinary;
        end
    end
end

% results
for season=1:4
    figure(season)
    h = heatmap(squeeze(data(season, :, :)).');
    h.Title = seasons(season)+" (Ordinary R-squared)";
    h.XLabel = 'Hour';
    h.YLabel = 'Lag';
    h.XDisplayLabels = 0:23;
    h.YDisplayLabels = lags;
end

fprintf('\n')
toc % timer stop

fprintf("\nAs we can see from the figures, for most hours of the day, we can\n" + ...
        "predict the number of rented bikes from the data of the past hours.\n" + ...
        "The best predictions are for hours after 9 am. During the very early\n" + ...
        "hours, the predictions are generally weak, with the weakest predictions\n" + ...
        "occurring around 7 am, where the amount of data that can be explained\n" + ...
        "by the model is less than 20%%. Regarding the lag, we cannot say that\n" + ...
        "there is a perfect lag, but we can clearly see a trend of better\n" + ...
        "performance for larger lags, which is expected because the models\n" + ...
        "initially investigated in this context are more powerful.\n\n")