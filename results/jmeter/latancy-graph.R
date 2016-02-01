#!/usr/bin/env Rscript

print("building plots for latency of Power and x86 responses")

drawLatencyGraph <- function(set_name, setRaw) {
  columns <- c("V1", "V2")
  set <- setRaw[columns]
  set <- setRaw[order(setRaw$V1),]
  maxX <- length(set$V2)
  maxY <- max(set$V2)
  jpeg(paste(set_name, '.jpg', sep=''))
  plot(c(), c(), type="p", col="red", xlab="Test Index", ylab="Latency (ms)", main="", xlim=c(0,maxX), ylim=c(0,maxY))
  plot(set$V2, type='l', col='blue')
  setSpline = smooth.spline(1:maxX, set$V2, spar=0.2)
  lines(setSpline, col='red', lwd=2)
  print(paste(set_name, ' mean ', mean(set$V2)))
  return(0)
}

read.csv('x86-jmeter.jtl', header = FALSE, sep = '|', as.is = TRUE) -> x86ResultsRaw
read.csv('power-jmeter.jtl', header = FALSE, sep = '|', as.is = TRUE) -> powerResultsRaw
drawLatencyGraph('x86-jmeter', x86ResultsRaw)
drawLatencyGraph('power-jmeter', powerResultsRaw)
