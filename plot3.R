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
png(file = "plot2.png", 
    bg = "transparent",
    width = 480, 
    height = 480)

# generate plot
plot(hpc_set$date_time, hpc_set$Global_active_power, 
     xlab="",
     ylab="Global Active Power (killowatts)",
     type = "l")

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
png(file = "plot3.png", 
    bg = "transparent",
    width = 480, 
    height = 480)

# generate plot
plot(hpc_set$date_time, hpc_set$Sub_metering_1, 
     xlab="",
     ylab="Energy sub meetering",
     type = "l")

lines(hpc_set$date_time,hpc_set$Sub_metering_2, col = "red" ,type = 'l')
lines(hpc_set$date_time,hpc_set$Sub_metering_3, col = "blue" ,type = 'l')
legend("topright", 
       legend=colnames(hpc_set)[7:9],
       lty=c(1,1),
       col=c("black","red","blue"))           # gives the legend appropriate symbols (lines) and color 
       
dev.off()