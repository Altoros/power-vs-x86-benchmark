#!/usr/bin/env Rscript

options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

powerResultsCSVFile <- args[1]
x86ResultsCSVFile   <- args[2]

print(powerResultsCSVFile)

read.csv(powerResultsCSVFile, header = FALSE) -> powerResults
read.csv(x86ResultsCSVFile,   header = FALSE) -> x86Results

maxX <- min(tail(powerResults$V1,n=1),tail(x86Results$V1,n=1))
maxY <- max(tail(powerResults$V2,n=1),tail(x86Results$V2,n=1))

powerSpline = smooth.spline(powerResults$V1, powerResults$V2, spar=0.5)
x86Spline = smooth.spline(x86Results$V1, x86Results$V2, spar=0.5)

jpeg('rplot.jpg')
plot(c(), c(), type="p", col="red", xlab="Time(sec)", ylab="Instance Count", main="Instance Count Under Increased Load", xlim=c(0,maxX), ylim=c(0,maxY))
lines(powerSpline, col='#F9A6AC', lwd=2)
par(new = TRUE)
plot(powerResults$V1, powerResults$V2, type="p", col="red", xlab="Time(sec)", ylab="Instance Count", main="Instance Count Under Increased Load", xlim=c(0,maxX), ylim=c(0,maxY))
par(new = TRUE)
lines(x86Spline, col='#AAA7FF', lwd=2)
par(new = TRUE)
plot(x86Results$V1, x86Results$V2, type="p", col="blue", axes=F, xlab="", ylab="",xlim=c(0,maxX), ylim=c(0,maxY))

legend(5,15.5,          # places a legend at the appropriate place
c("IBM Power", "x86"), # puts text in the legend
lty=c(1,1),            # gives the legend appropriate symbols (lines)
lwd=c(2.5,2.5), col=c("red","blue")) # gives the legend lines the correct color and width