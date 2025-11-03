clear; clc; close all

% significance level
a = 0.05; 

% import data
T = HakaExe5Fun1(["Rented Bike Count", "Hour", "Temperature(°C)", "Seasons"]);
seasons = ["Winter", "Spring", "Summer", "Autumn"];

% pearson coefficients, p-value and h matrix
pearson_matrix = zeros(4,24);
p_value_matrix = zeros(4,24);
h_matrix = zeros(4,24,3);

% Seasons
for i=1:4
    T1 = T(T.Seasons == i, ["Rented Bike Count", "Hour", "Temperature(°C)"]);

    % Hours
    for j=0:23
        T2 = T1{T1.Hour == j, ["Rented Bike Count", "Temperature(°C)"]};
        
        [pearson, p_value] = corrcoef(T2(:,1),T2(:,2));
        pearson_matrix(i,j+1) = pearson(1,2);
        p_value_matrix(i,j+1) = p_value(1,2);

        if p_value(1,2) < a, h_matrix(i,j+1,:) = [1 0 0];
        else; h_matrix(i,j+1,:) = [0 0 1]; end
    end  
end

% transformation, normalization and upscale [10,100]
p_value_matrix = 90*log(p_value_matrix)/min(log(p_value_matrix)+10, [], "all");

% results
sgtitle("biggest size -> smaller p-value")
for i=1:4
    subplot(2,2,i)
    hold on
    scatter(1:24, pearson_matrix(i,:), p_value_matrix(i,:), squeeze(h_matrix(i,:,:)), "*", DisplayName="D")
    plot(nan, nan,'*b')
    ylabel("Pearson's correlation coefficient")
    xlabel("Hour")
    title(seasons(i))
    legend("statistically significant", "not statistically significant", 'Location',"southeast")
end

fprintf("The results appear magnificent. There is a positive correlation\n" + ...
        "between rented bikes and the temperature. This behavior holds true\n" + ...
        "for all seasons except summer. Summer presents a unique case\n" + ...
        "because, as we can observe, the values ​​are not statistically\n" + ...
        "significant almost nowhere. At times when prices are statistically\n" + ...
        "significant, there appears to be negatively correlated, particularly\n" + ... 
        "around midday. This phenomenon could potentially be explained by\n" + ...
        "the high temperatures at that time, which discourage people from\n" + ... 
        "venturing outdoors. For the other three seasons, the only anomaly\n" + ... 
        "in the positive correlation occurs around 8 am. This observation\n" + ... 
        "reinforces the hypothesis that I proposed in the previous questions.\n" + ... 
        "According to this hypothesis, the increased number of rented bikes\n" + ... 
        "at 8 am is due to citizens using them to commute to their jobs.\n" + ... 
        "The temperature does not prevent people from going to work, which\n" + ... 
        "is why the correlation is not strong.\n\n")