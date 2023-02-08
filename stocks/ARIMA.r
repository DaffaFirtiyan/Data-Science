library(quantmod)
library(prophet)
library(forecast)
library(lubridate)

date <- "2020-1-1"
getSymbols("GME", src = "yahoo", from = date)
getSymbols("SBI", src = "yahoo", from = date)

df <- data.frame(ds = index(GME), y = as.numeric(GME[,"GME.Close"]))
df <- data.frame(ds = index(SBI), y = as.numeric(SBI[,'SBI.Close']))

prediction = prophet(df)
futurePrice = make_future_dataframe(prediction, periods = 30)
forecastGME = predict(prediction, futurePrice)

