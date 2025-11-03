clear; clc; close all

% import data
T = HakaExe1Fun1(["Rented Bike Count", "Seasons"]);
seasons = ["Winter", "Spring", "Summer", "Autumn"];

% distributions for testing
testing_distributions = ["BirnbaumSaunders", "Exponential", ...
                         "Extreme Value", "Gamma", ...
                         "Generalized Extreme Value", ...
                         "Generalized Pareto", "Half Normal", ...
                         "InverseGaussian", "Kernel", "Logistic", ...
                         "Loglogistic", "Lognormal", "Nakagami", ...
                         "Negative Binomial", "Normal", "Poisson", ...
                         "Rayleigh", "Rician", ...
                         "tLocationScale", "Weibull"];

fprintf("The best distribution for our data in each season is the follows:\n\n")

% for each season
for i=1:4
    nll = -1;
    t = T{T.Seasons == i, "Rented Bike Count"};

    % for each distribution
    for distribution = testing_distributions
        model = fitdist(t, distribution);

        % condition
        if (model.negloglik < nll) || (nll < 0)
            best_distribution = distribution;
            nll = model.negloglik;
        end 
    end
    
    % results and plots
    subplot(2,2,i)
    model = fitdist(T{T.Seasons == i, "Rented Bike Count"}, best_distribution);
    model.plot

    title(seasons(i))
    xlabel("Rented Bike Count")
    legend('',best_distribution)

    fprintf("For %s is %s.\n", seasons(i), best_distribution)
end

fprintf("\nAccording to the results, the distributions by season differ \n" + ...
    "slightly, with the largest difference observed in spring, \n" + ...
    "which has a decreasing trend as the number of rental bikes increases.\n\n")