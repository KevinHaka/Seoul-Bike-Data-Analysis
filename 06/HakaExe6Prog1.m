clear; clc; close all

% significance level
a = 0.05; 

% Number of randomized samples
M = 10^3;

% interval boundaries
L = round(M*a/2);
U = round(M*(1-a/2));

% import data
T = HakaExe6Fun1(["Rented Bike Count", "Hour", "Temperature(°C)", "Seasons"]);
seasons = ["Winter", "Spring", "Summer", "Autumn"];

% GMIC and MIC tensor (randomized samples)
GMIC_tensor = zeros(4, 24, M);
MIC_tensor = zeros(4, 24, M);

% GMIC and MIC p-value matrix
GMIC_p_value = zeros(4,24);
MIC_p_value = zeros(4,24);

% GMIC and MIC matrix (original data)
GMIC = zeros(4,24);
MIC = zeros(4,24);

% Seasons
for i=1:4
    T1 = T(T.Seasons == i, ["Rented Bike Count", "Hour", "Temperature(°C)"]);
    
    % Hours
    for j=0:23
        T2 = T1{T1.Hour == j, ["Rented Bike Count", "Temperature(°C)"]};
        size_T2 = length(T2(:,1)); % data size
        
        % Sturges' formula
        nbins = ceil(log2(size_T2)) +1;
        
        % GMIC and MIC
        GMIC(i,j+1) = -0.5*log(1 - corr(T2(:,1),T2(:,2))^2)/log(nbins);
        MIC(i,j+1) = MutualInformationXY(T2(:,1), T2(:,2))/log(nbins);
        
        % Randomizations
        for k=1:M
            T2(:,2) = T2(randperm(size_T2), 2);
            
            % Pearson's correlation coefficient
            r = corr(T2(:,1),T2(:,2));

            % GMIC and MIC
            GMIC_tensor(i,j+1,k) = -0.5*log(1 - r^2)/log(nbins);
            MIC_tensor(i,j+1,k) = MutualInformationXY(T2(:,1), T2(:,2), nbins)/log(nbins);
        end
        
        % GMIC and MIC p-value
        GMIC_a = sum(GMIC_tensor(i,j+1,:) >= GMIC(i,j+1))/M;
        MIC_a = sum(MIC_tensor(i,j+1,:) >= MIC(i,j+1))/M;
        GMIC_p_value(i,j+1) = 2*min(GMIC_a, 1 - GMIC_a);
        MIC_p_value(i,j+1) = 2*min(MIC_a, 1 - MIC_a);
    end
end

% sort of GMIC and MIC
GMIC_tensor = sort(GMIC_tensor,3);
MIC_tensor = sort(MIC_tensor,3);

% results
for i=1:4
    T1 = T(T.Seasons == i, ["Rented Bike Count", "Hour", "Temperature(°C)"]);

    for j=0:23
        T2 = T1{T1.Hour == j, ["Rented Bike Count", "Temperature(°C)"]};

        figure(j+1)
        subplot(2,2,i)
        hold on
        scatter(T2(:,2), T2(:,1),".")
        ylabel("Rented Bike Count")
        xlabel("Temperature (°C)")
        title(seasons(i))
        txt = sprintf(['Hour %d\n' ...
            'Green -> statistically significant\n' ...
            'Black -> not statistically significant'], j);
        sgtitle(txt)
        
        txt = sprintf("I_{GMIC} = %.3f (p-value = %.3f)", GMIC(i,j+1), GMIC_p_value(i,j+1));
        if (GMIC(i,j+1) < GMIC_tensor(i,j+1,L)) || (GMIC(i,j+1) > GMIC_tensor(i,j+1,U))
            text(0.05,0.85,txt,'Color',"g",'Units','normalized')
        else
            text(0.05,0.85,txt,'Units','normalized')
        end
        
        txt = sprintf("I_{MIC} = %.3f (p-value = %.3f)",MIC(i,j+1), MIC_p_value(i,j+1));
        if (MIC(i,j+1) < MIC_tensor(i,j+1,L) ) || (MIC(i,j+1) > MIC_tensor(i,j+1,U))
            text(0.05,0.75,txt,'Color',"g",'Units','normalized');
        else
            text(0.05,0.75,txt,'Units','normalized')
        end
    end

    fprintf("%s : mean_diff_I = %.3f\n", seasons(i), sum(abs(GMIC(i,:) - MIC(i,:)))/24)
end

fprintf("\nThe Summer and Autumn seem to have a difference between the two\n" + ...
        "values (GMIC and MIC) almost all day, except during the very early\n" + ...
        "morning hours. This leads us to believe that their data exhibit a\n" + ... 
        "non-linear relationship after 10 AM. Regarding Summer and Spring,\n" + ... 
        "since their two values are relatively close, we assume a linear\n" + ... 
        "relation. For Summer, the relation appears strong only during\n" + ... 
        "midday hours, while for Spring, it seems strong throughout the day\n" + ... 
        "except in the very morning.\n\n")