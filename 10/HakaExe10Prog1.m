clear; clc; close all

% import data
T = HakaExe10Fun1(["Hour", "Rented Bike Count", "Seasons", "Holiday"]);
seasons = ["Winter", "Spring", "Summer", "Autumn"];

% initializations
daily_periodicity = 24;
weekly_periodicity = 7*24;

% Seasons
for season=1:4
    T1 = T(T.Seasons == season, [2,1,4]);

    % Continuous days without holidays in between
    RB = HakaExe10Fun2(T1);

    % trend component
    tt = RB(2:end) - RB(1:end-1);

    % periodic component (weekly)
    st_weekly = zeros(height(tt), 1);
    for i=1:weekly_periodicity
        st_weekly(i:weekly_periodicity:end) = mean(tt(i:weekly_periodicity:end));
    end

    % almost residuals
    yt_ = tt - st_weekly;

    % periodic component (daily)
    st_daily = zeros(height(yt_), 1);
    for i=1:daily_periodicity
        st_daily(i:daily_periodicity:end) = mean(yt_(i:daily_periodicity:end));
    end

    % residuals
    yt = yt_ - st_daily;

    % results
    figure(season)
    sgtitle(seasons(season))

    subplot(2,2,1)
    plot(RB)
    xlabel('Hours')
    ylabel('Rented Bike Count')

    subplot(2,2,2)
    plot(tt)
    xlabel('Hours')
    ylabel('First differences')

    subplot(2,2,3)
    plot(yt)
    xlabel('Hour')
    ylabel('residuals')
 
    subplot(2,2,4)
    autocorr(yt, NumLags=300)
end

fprintf("After decomposing the time series and analyzing the results,\n" + ...
          "especially the autocorrelation graph, we can say for sure that\n" + ...
          "there is still information in our residuals for all seasons. \n" + ...
          "As we can see, for small lags, the autocorrelation is significantly\n" + ...
          "outside of the confidence interval, which means that we can \n" + ...
          "extract information from the previous hours.\n\n")
fprintf("More specifically:\n" + ...
        "For all seasons, there seems to be a significant positive correlation\n" + ...
        "with the same hour of the previous day, plus or minus an hour\n" + ...
        "(this may be due to the small sample size of the data). There is\n" + ...
        "another positive correlation for all seasons except Winter, which\n" + ...
        "occurs with an hour before. Between 1 and 24 hours lag, there\n" + ...
        "appear to be some lags with negative correlation. But all of these\n" + ...
        "make some sense. The most unusual thing is that in Autumn and Spring,\n" + ...
        "there is a big positive correlation at a 10-hour lag, which I cannot\n" + ...
        "explain. I would suppose that it is an error, but it looks so strong\n" + ...
        "and it may hide some important information.\n\n")