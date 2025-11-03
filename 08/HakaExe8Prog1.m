clear; clc; close all
warning('off'); % Disable all warnings

% import data
T = HakaExe8Fun1();
T = T(T.Holiday == 0, 2:end-1); % drop data column

% names
seasons = ["Winter", "Spring", "Summer", "Autumn"];
models = ["full model 1", "stepwise model 1", "full model 2", "stepwise model 2"];

% data cleaning
T = HakaExe8Fun2(T);

% initial matrices
pred_vals = zeros(20*24,4);
real_vals = zeros(20*24,1);
RMSE = zeros(4,1);

% Seasons
for season=1:4
    T1 = T(T.Seasons == season,  [2:10 1]);

    % Hours
    for hour=0:23
        T2 = T1(T1.Hour == hour, 2:10);

        % split to training and testing data
        train = T2(1:end-20,:);
        test = T2(end-19:end,:);
        
        % fit linear and stepwise regression model
        % save predictions
        mdl = fitlm(train);
        pred_vals(hour+1:24:20*24, 1) = mdl.predict(test{:,1:end-1});
        mdl = stepwiselm(train);
        pred_vals(hour+1:24:20*24, 2) = mdl.predict(test{:,1:end-1});
    end

    % split to training and testing data
    train = T1(1:end-20*24,:);
    test = T1(end-20*24+1:end,:);

    % fit linear and stepwise regression model
    % save predictions and real values
    mdl = fitlm(train);
    pred_vals(:, 3) = mdl.predict(test{:,1:end-1});
    mdl = stepwiselm(train);    
    pred_vals(:, 4) = mdl.predict(test{:,1:end-1});
    real_vals(:) = test{:,end};
    
    % save Root Mean Square Error
    for i=1:4
        RMSE(i) = sqrt(mean((real_vals(:) - pred_vals(:,i)).^2));
    end

    % results
    fig_1 = figure(1);
    subplot(2,2,season)
    plot([test{:,end}, ...
          pred_vals(:, 1), pred_vals(:, 2), ...
          pred_vals(:, 3), pred_vals(:, 4)])
    title(seasons(season))
    strs = [sprintf("f\\_mdl\\_1 (RMSE = %.0f)", RMSE(1)), ...
            sprintf("sw\\_mdl\\_1 (RMSE = %.0f)", RMSE(2)), ...
            sprintf("f\\_mdl\\_2 (RMSE = %.0f)", RMSE(3)), ...
            sprintf("sw\\_mdl\\_2 (RMSE = %.0f)", RMSE(4))];
    legend(["real\_values", strs(1), strs(2), strs(3), strs(4)], Location='best')
    xticks([])

    fig_x = figure(season + 1);
    for i=1:4
        subplot(2,2,i)
        residuals = (real_vals(:) - pred_vals(:,i))/std(real_vals(:) - pred_vals(:,i));
        plot(residuals, '.')
        ttl = sprintf("%s (RMSE = %.0f)", models(i), RMSE(i));
        title(ttl);
        xticks([])
        yline([-1.96 1.96], 'r')
    end
    han = axes(fig_x, 'visible', 'off');
    han.Title.Visible = 'on';
    han.XLabel.Visible = 'on';
    han.YLabel.Visible = 'on';
    ylabel(han, 'standardized residuals');
    xlabel(han, 'real values');
    title(han, seasons(season));
end

han = axes(fig_1, 'visible', 'off');
han.XLabel.Visible = 'on';
han.YLabel.Visible = 'on';
ylabel(han, 'Rented Bike Count');
xlabel(han, 'independent variables');

fprintf('\n\n')
fprintf("As we can see from the graphs, a perfect model does not exist.\n" + ...
       "The model that performs better depends on the data, and unfortunately,\n" + ...
       "we have no way to know this beforehand. Based on the results,\n" + ...
       "we observe the following:\n\n")
fprintf("Winter: Stepwise model 1 (RMSE = 125)\n" + ...
      "Spring: Full model 1 (RMSE = 508)\n" + ...
      "Summer: Full model 2 (RMSE = 463)\n" + ...
      "Autumn: Full model 1 (RMSE = 355)\n\n")
fprintf("Most of the time, the full model performs better. However, it comes\n" + ...
      "at the cost of having more independent variables, and the increase\n" + ...
      "in performance is not significant. That's why the stepwise models\n" + ...
      "can be more useful. Regarding outlier predictions, they occur only\n" + ...
      "with the full or stepwise model 1. I suspect this happens because\n" + ...
      "these models overestimate the contribution of rainfall and maybe \n" + ...
      "other factors to.\n\n")
