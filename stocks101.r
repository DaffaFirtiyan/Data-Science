library(quantmod)
library(PerformanceAnalytics)
library(PortfolioAnalytics)

dt <- "2019-1-1"

# XTS = extensible time series
aapl <- getSymbols.yahoo("AAPL", from=dt, auto.assign = F)
aaplClose <- getSymbols.yahoo("AAPL", from=dt, auto.assign = F)[,6]

aaplRets <- na.omit(dailyReturn(aaplClose, type = "log"))

chartSeries(aapl)

gme <- getSymbols.yahoo("GME", from=dt, auto.assign = F)
gmeClose <- getSymbols.yahoo("GME", from=dt, auto.assign = F)[,6]

gmeRets <- na.omit(dailyReturn(gmeClose, type = "log"))

chartSeries(gme)

##  portfolio analysis
tickers <- c("AAPL", "TSLA", "AMZN", "NFLX")
weights <- c(.25, .25, .25, .25)

portfolioPrices <- NULL

for(ticker in tickers) {
  portfolioPrices <- cbind(portfolioPrices,
                           getSymbols.yahoo(ticker, from = dt, periodicity = "daily", auto.assign = FALSE)[,4])
}
# rate of change - in this case, it's the daily change
portfolioReturns <- na.omit(ROC(portfolioPrices))

# check for missing data
colSums(is.na(portfolioPrices))

# benchmark using sp500
benchmarkPrices <- getSymbols.yahoo("^GSPC", from = dt, periodicity = "daily", auto.assign = FALSE)[,4]
colSums(is.na(benchmarkPrices))

# rate of change
benchmarkReturns <- na.omit(ROC(benchmarkPrices))

# aggregated portfolio returns based on the weights
portfolioReturns <- Return.portfolio(portfolioReturns, weights)

# using CAPM model (check FINA202 notes)
# comparing your investments with an index
# beta market = 1, higher riskier
# sharpe ratio - for every unit of sdv, how many units of return are you achieving
# .035 arbitrary number, 252 num of trading days bc daily
CAPM.beta(portfolioReturns, benchmarkReturns, .035/252)

# risk adjusted performance
CAPM.jensenAlpha(portfolioReturns, benchmarkReturns, .035/252)

SharpeRatio(portfolioReturns, .035/252)

table.AnnualizedReturns(portfolioReturns)
table.CalendarReturns(portfolioReturns)

##  portfolio optimization
tickers <- c("AAPL", "TSLA", "AMZN", "NFLX", "GOOGL", "NVDA", "SQ")

portfolioPrices <- NULL

for(ticker in tickers) {
  portfolioPrices <- cbind(portfolioPrices,
                           getSymbols.yahoo(ticker, from = dt, periodicity = "daily", auto.assign = FALSE)[,4])
}
portfolioReturns <- na.omit(ROC(portfolioPrices))

portf <- portfolio.spec(colnames(portfolioReturns))
portf <- add.constraint(portf, type = "weight_sum", min_sum = 1, max_sum = 1)
portf <- add.constraint(portf, type = "box", min = .10, max = .40)
portf <- add.objective(portf, type = "return", name = "mean")
portf <- add.objective(portf, type = "risk", name = "StdDev")

# using ROI
optPort <- optimize.portfolio(portfolioReturns, portf, optimize_method = "ROI", trace = TRUE)

chart.Weights(optPort)