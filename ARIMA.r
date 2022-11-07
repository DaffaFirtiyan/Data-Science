library(quantmod)
gme <- getSymbols(Symbols = "GME", src = "yahoo", auto.assign = FALSE)
chartSeries(gme)
add_SMA(n = 100, on = 1, col = "red")
add_SMA(n = 20, on = 1, col = "black")
add_RSI(n = 14, maType = "SMA")
add_BBands(n = 20, maType = "SMA", sd = 1, on = -1)
add_MACD(fast = 12, slow = 26, signal, 9, maType = "SMA", histogram = TRUE)
