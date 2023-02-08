from pandas import read_csv
from datetime import datetime
from matplotlib import pyplot
from pandas.plotting import autocorrelation_plot
from pandas import DataFrame
from statsmodels.tsa.arima.model import ARIMA

# load dataset
def parser(x):
    return datetime.strptime('200' + x, '%Y-%m')

series = read_csv("ARIMA/shampoo.csv", header=0, parse_dates=[0], index_col=0, date_parser=parser)

# convert index to datetime
series.index = series.index.to_period("M")
# autocorrelation_plot(series)
# pyplot.show()

# fit model
model = ARIMA(series, order=(5,1,0))
model_fit = model.fit()

#summary of the fit model
print(model_fit.summary())

# line plot of residuals
residuals = DataFrame(model_fit.resid)
residuals.plot()
pyplot.show()

# density plot of residuals
residuals.plot(kind='kde')
pyplot.show()

# summary stats of residuals
print(residuals.describe())