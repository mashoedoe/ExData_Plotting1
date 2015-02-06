# This assignment uses data from the UC Irvine Machine Learning Repository, 
# a popular repository for machine learning datasets. 
# In particular, we will be using the “Individual household electric power 
# consumption Data Set” which I have made available on the course web site:

# Dataset: Electric power consumption [20Mb]

hpc_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(hpc_url, "exdata-data-household_power_consumption.zip")
unzip("exdata-data-household_power_consumption.zip", "household_power_consumption.txt")

# Description: Measurements of electric power consumption in one household 
# with a one-minute sampling rate over a period of almost 4 years. 
# Different electrical quantities and some sub-metering values are available.

# The following descriptions of the 9 variables in the dataset are taken from 
# the UCI web site:

# Date: Date in format dd/mm/yyyy
# Time: time in format hh:mm:ss
# Global_active_power: household global minute-averaged active power (in kilowatt)
# Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
# Voltage: minute-averaged voltage (in volt)
# Global_intensity: household global minute-averaged current intensity (in ampere)
# Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). 
    # It corresponds to the kitchen, containing mainly a dishwasher, an oven 
    # and a microwave (hot plates are not electric but gas powered).
# Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). 
    # It corresponds to the laundry room, containing a washing-machine, 
    # a tumble-drier, a refrigerator and a light.
# Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). 
    # It corresponds to an electric water-heater and an air-conditioner.

# Loading the data

# When loading the dataset into R, please consider the following:

# The dataset has 2,075,259 rows and 9 columns. First calculate a rough 
# estimate of how much memory the dataset will require in memory before 
# reading into R. 
# Make sure your computer has enough memory (most modern computers should be fine).

# We will only be using data from the dates 2007-02-01 and 2007-02-02. 
# One alternative is to read the data from just those dates rather than 
# reading in the entire dataset and subsetting to those dates.

# You may find it useful to convert the Date and Time variables to Date/Time 
# classes in R using the strptime() and as.Date() functions.

# Note that in this dataset missing values are coded as ?.

df_colClasses = c("character", "character", "numeric",  "numeric", "numeric", 
                  "numeric", "numeric", "numeric", "numeric")
hpc <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", 
                  nrows = 2075259, colClasses = df_colClasses, na.strings = "?")
# object.size(hpc)

hpc_subset <- data.frame(hpc[hpc$Date == "1/2/2007" | hpc$Date == "2/2/2007", ], 
                         row.names = NULL)

hpc_subset$datetime <- paste(hpc_subset$Date, hpc_subset$Time)
hpc_subset$datetime1 <- strptime(hpc_subset$datetime, "%d/%m/%Y %H:%M:%S")
# class(hpc_subset$datetime1)
hpc_subset$datetime <- hpc_subset$datetime1
#hpc_subset$datetime <- weekdays(hpc_subset$datetime1, abbreviate = TRUE

# create a plot of 480 x 480 pixels matching: 
# https://github.com/rdpeng/ExData_Plotting1/blob/master/figure/unnamed-chunk-5.png

png("plot4.png", width = 480, height = 480)
par(bg = "transparent", mfcol = c(2, 2))

with(hpc_subset, plot(datetime, Global_active_power, type = "l", xlab = "", 
                      ylab = "Global Active Power"))

with(hpc_subset, plot(x = c(datetime, datetime, datetime), 
                      y = c(Sub_metering_1, Sub_metering_2, Sub_metering_3), 
                      type = "n", xlab = "", ylab = "Energy sub metering")) 
with(hpc_subset, lines(datetime, Sub_metering_1, col = "black"))
with(hpc_subset, lines(datetime, Sub_metering_2, col = "red"))
with(hpc_subset, lines(datetime, Sub_metering_3, col = "blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=1, col=c("black", "red", "blue"), cex=0.95, bty="n")

with(hpc_subset, plot(x = datetime, Voltage, type = "l"))

with(hpc_subset, plot(x = datetime, Global_reactive_power, type = "l"))
dev.off()

