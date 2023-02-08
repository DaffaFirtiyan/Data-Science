from pandas import read_csv
from datetime import datetime
from matplotlib import pyplot
# from pandas.plotting import autocorrelation_plot
from pandas import DataFrame
from sklearn.metrics import mean_squared_error
from math import sqrt
from statsmodels.tsa.arima.model import ARIMA

# load dataset
def parser(x):
    return datetime.strptime('200' + x, '%Y-%m')

series = read_csv("ARIMA/shampoo.csv", header=0, parse_dates=[0], index_col=0, date_parser=parser)

# convert index to datetime
series.index = series.index.to_period("M")

# split into train and test sets
X = series.values
size = int(len(X)*0.66)
train, test = X[0:size], X[size:len(X)]
history = [x for x in train]
predictions = list()

# walk forward validatoin
for t in range(len(test)):
    model = ARIMA(history, order=(5,1,1))
    model_fit = model.fit()
    output = model_fit.forecast()
    yHat = output[0]
    predictions.append(yHat)
    obs = test[t]
    history.append(obs)
    print('predicted=%f, expected=%f' % (yHat, obs))

# evaluate forecasts
rmse = sqrt(mean_squared_error(test, predictions))
print('Test RMSE: %.3f' % rmse)

# plot forecasts against actual outcomes
pyplot.plot(test)
pyplot.plot(predictions, color='red')
pyplot.show()

# autocorrelation_plot(series)
# pyplot.show()

# # fit model
# model = ARIMA(series, order=(5,1,0))
# model_fit = model.fit()

# #summary of the fit model
# print(model_fit.summary())

# # line plot of residuals
# residuals = DataFrame(model_fit.resid)
# residuals.plot()
# pyplot.show()

# # density plot of residuals
# residuals.plot(kind='kde')
# pyplot.show()

# # summary stats of residuals
# print(residuals.describe())