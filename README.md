# Data Science
 
shampoo.py
I attempt to apply the ARIMA model to this time series data of monthly shampoo sales over a 3 year period.

TLDR: This code uses the ARIMA model to predict future values of a given dataset. It first loads the dataset, splits it into a train and test set, and then uses the ARIMA model to make predictions on the test set. It then evaluates the forecasts using root mean squared error (RMSE) and plots the results against the actual outcomes.

After parsing through the data, we can see a clear trend. This suggests t aht time series is not stationary and will required differencing to make it stationary, at least a difference order of 1.

After taking a quick look at an autocorrelation plot of the time seires, we can see that the plot shows a positive correlation with the first 10-12 lags, the correlation is particularlong strong for the first 5 lags. This means that we 5 for "p" (autoregression) might be a good starting point.

Running 'model_fit.summary()' output the fitted SARIMAX model. 
                               SARIMAX Results
==============================================================================
Dep. Variable:                  Sales   No. Observations:                   36
Model:                 ARIMA(5, 1, 0)   Log Likelihood                -198.485
Date:                Wed, 08 Feb 2023   AIC                            408.969
Time:                        18:33:06   BIC                            418.301
Sample:                    01-31-2001   HQIC                           412.191
                         - 12-31-2003
Covariance Type:                  opg
==============================================================================
                 coef    std err          z      P>|z|      [0.025      0.975]
------------------------------------------------------------------------------
ar.L1         -0.9014      0.247     -3.647      0.000      -1.386      -0.417
ar.L2         -0.2284      0.268     -0.851      0.395      -0.754       0.298
ar.L3          0.0747      0.291      0.256      0.798      -0.497       0.646
ar.L4          0.2519      0.340      0.742      0.458      -0.414       0.918
ar.L5          0.3344      0.210      1.593      0.111      -0.077       0.746
sigma2      4728.9608   1316.021      3.593      0.000    2149.607    7308.314
===================================================================================
Ljung-Box (L1) (Q):                   0.61   Jarque-Bera (JB):                 0.96
Prob(Q):                              0.44   Prob(JB):                         0.62
Heteroskedasticity (H):               1.07   Skew:                             0.28
Prob(H) (two-sided):                  0.90   Kurtosis:                         2.41
===================================================================================

The line plot of the residuals errors whos that the current model may not have captured all the trend information in the data. This means that there are still some patterns or underlying trends in teh data that have not been captured by the ARIMA model.

From the density plot of residuals we see that they have a Gaussian distribution but doesn't have a mean of 0, or are not centered around zero. This shows that the residual errors are biassed, meaning that on average, the eerrors are either over or under estimating the actual values.

Now we use the ARIMA model to forecast future time steps.

We print the prediction and the actual value for each iteration and the final RMSE is calculated to compare the accuracy of the model's predictions which is 89.021.

A line plot is created to visualise the expected values (in blue) vs. the rolling forecast predictions (in red), showing that the model captures some trends and is in the correct scale. 

There is potentitial for furether improvement by adjusting the p, d, q param of the model.