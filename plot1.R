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
png(file = "plot1.png", 
    bg = "transparent",
    width = 480, 
    height = 480)

# generate histogram
hist(hpc_set$Global_active_power,
     col="red",
     main="Global Active Power",
     xlab="Global Active Power (killowatts)",
     ylab="Frequency")

dev.off()
