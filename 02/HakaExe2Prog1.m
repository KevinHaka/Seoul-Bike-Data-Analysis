clear; clc; close all

M = 10^4; % number of repetitions
ss = 100; % sample size
a = 0.05; % significance level
nbins = ceil(log2(ss)) +1; % Sturges' formula

% import data
T = HakaExe2Fun1(["Rented Bike Count", "Seasons"]);
seasons = ["Winter", "Spring", "Summer", "Autumn"];

% initial values
p = zeros(1,6);
counter = 0;

% seasons A
for i=1:3
    % season A data and data size
    season_A = T{T.Seasons == i, "Rented Bike Count"}; 
    A_size = length(season_A);
    
    % seasons B
    for j=i+1:4
        % season B data and data size
        season_B = T{T.Seasons == j, "Rented Bike Count"};
        B_size = length(season_B);

        counter = counter +1;

        % repetitions
        for k=1:M
            % Progress bar
            if mod(k, int32(M)) == 1; fprintf("%d | ", counter)
            elseif mod(k, int32(M)) == 0; fprintf("%1.e\n",k)
            elseif mod(k, int32(M/10)) == 0; fprintf(".")
            end
            
            % samples
            sample_A = season_A(randperm(A_size, ss));
            sample_B = season_B(randperm(B_size, ss));

            % heights of bins
            N_A = histcounts(sample_A, nbins);
            N_B = histcounts(sample_B, nbins);

            % χ^2 two-tailed test and p_value
            chi_sq = sum((N_A - N_B).^2./N_B);
            p_value = min(chi2cdf(chi_sq, nbins-1), 1-chi2cdf(chi_sq, nbins-1));

            if p_value > a; p(counter) = p(counter) +1; end
        end
    end
end

fprintf("\n");

% results
counter = 0;
for i=1:3
    for j=i+1:4
        counter = counter +1;
        fprintf("%s - %s   %.2f%%\n", seasons(i), seasons(j), p(counter)*100/M)
    end  
end

fprintf("\nFor a sample size of 100 and a significance level of 5%%, it turns out that,\n" + ...
          "it is possible that the Winter, Summer, and Autumn seasons have\n" + ...
          "the same distribution, with a probability close to 23%%. However,\n" + ...
          "when compared to Spring, the probability drops below 13%%, suggesting\n" + ...
          "that Spring might exhibit a different distribution.\n\n")

fprintf("Postscript\n")
fprintf("Because the above results have been based on the χ^2 statistic, the order of\n" + ...
        "the seasons (which is first and which is second) has an impact on the result.\n" + ...
        "Perhaps a better statistic should have been used for this job.\n\n")
