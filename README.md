# Seoul Bike Data Analysis

## About This Project

This repository contains all the MATLAB scripts for a university project in the **"Data Analysis and Processing using MATLAB" (Ανάλυση και Επεξεργασία Δεδομένων με χρήση MATLAB)** course.

## The Data

This project analyzes the "Seoul Bike Sharing Demand" dataset, which provides hourly data for the bike-sharing system in Seoul.

The primary variable for prediction and analysis is **Rented Bike Count (Bikes)**. The dataset includes several features used in the analysis:

* **Temporal Features:**
    * Date
    * Hour

* **Meteorological Features:**
    * Temperature
    * Humidity
    * Wind speed
    * Visibility
    * Dew point temperature
    * Solar Radiation
    * Rainfall
    * Snowfall

* **Categorical Features:**
    * Seasons (Encoded as 1:Winter, 2:Spring, 3:Summer, 4:Autumn)
    * Holiday (Encoded as 0:No Holiday, 1:Holiday)

## Project Contents

This repository provides MATLAB solutions for 10 distinct data analysis problems. The primary statistical techniques and methods used across these tasks are:

* **Probability Distribution Fitting:** Finding the best-fitting parametric distributions for the data.
* **Chi-squared ($X^2$) Tests:** Used for evaluating goodness-of-fit and testing if different samples come from the same distribution (homogeneity).
* **Hypothesis Testing:** Specifically, testing for a zero mean on paired sample differences.
* **Bootstrap Confidence Intervals:** Calculating 95% confidence intervals for the median.
* **Correlation Analysis:** Calculating and testing the significance of:
    * **Pearson Correlation** (for linear relationships).
    * **Mutual Information (MIC & GMIC)** (for linear and non-linear relationships).
* **Randomization (Permutation) Testing:** Used to assess the significance of the MIC and GMIC correlation coefficients.
* **Regression Modeling:**
    * Fitting and comparing **Linear and Non-linear models** (e.g., polynomial).
    * **Multiple Linear Regression** (full model).
    * **Stepwise Regression** for feature selection.
* **Time Series Analysis:**
    * Deseasonalization (removing seasonality) from the data.
    * Calculating and plotting the **Autocorrelation Function (ACF)** to find serial correlations.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
