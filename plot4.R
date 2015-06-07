library("tidyr")
library("dplyr")
library("lubridate")
library(data.table)

if (!file.exists("household_power_consumption.txt")) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile="HPC.zip", mode="wb")
    unzip("HPC.zip","household_power_consumption.txt")
}

hpc <- suppressWarnings(fread("household_power_consumption.txt", sep=";", header=TRUE, na.strings="?"))

# create date-time column
hpc$date_time <- dmy_hms(paste(hpc$Date,hpc$Time))

# force data columns to be numberc
convcols <- colnames(hpc)[3:9]  
hpc[,convcols] <- hpc[,lapply(.SD,as.numeric),.SDcols=convcols]

setkey(hpc,date_time)

# select data 2007-02-01 through 2007-02-02
hpc_set <- hpc[date_time>=ymd_hms("2007-02-01 00:00:00")][date_time<ymd_hms("2007-02-03 00:00:00")]

# open png graphics device
png(file = "plot4.png", 
    bg = "transparent",
    width = 480, 
    height = 480)

par(mfcol = c(2, 2),
    cex = 0.8,
    mar = c(4,5,3,1))

# generate plots

# plot 1
plot(hpc_set$date_time, hpc_set$Global_active_power, 
     xlab="",
     ylab="Global Active Power",
     type = "l")

# plot 2
plot(hpc_set$date_time, hpc_set$Sub_metering_1, 
     xlab="",
     ylab="Energy sub meetering",
     type = "l")

lines(hpc_set$date_time,hpc_set$Sub_metering_2, col = "red" ,type = 'l')
lines(hpc_set$date_time,hpc_set$Sub_metering_3, col = "blue" ,type = 'l')
legend("topright", 
       legend=colnames(hpc_set)[7:9],
       lty=c(1,1),                    # gives the legend appropriate symbols (lines) and color 
       col=c("black","red","blue"),
       bty = "n")                     # remove legend boarder

# plot 3
plot(hpc_set$date_time, hpc_set$Voltage, 
     xlab="datetime",
     ylab="Voltage",
     type = "l")

# plot 4
plot(hpc_set$date_time, hpc_set$Global_reactive_power, 
     xlab="datetime",
     ylab="Global_reactive_power",
     type = "l")

dev.off()