## Create plot3.png using this R script plot3.R 

# This assignment uses data from the UC Irvine Machine Learning Repository, 
# a popular repository for machine learning datasets. 
# In particular, we will be using the “Individual household electric power 
# consumption Data Set” 

## Download & unzip the data:

hpc_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(hpc_url, "exdata-data-household_power_consumption.zip")
unzip("exdata-data-household_power_consumption.zip", "household_power_consumption.txt")

# Description: Measurements of electric power consumption in one household 
# with a one-minute sampling rate over a period of almost 4 years. 
# Different electrical quantities and some sub-metering values are available.

# Descriptions of the 9 variables in the dataset:

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

## Load the data:
 
# Pass these column classes to read.table
df_colClasses = c("character", "character", "numeric",  "numeric", "numeric", 
                  "numeric", "numeric", "numeric", "numeric")
# Pass these column names to read.table
df_colnames = c( "Date", "Time", "Global_active_power", "Global_reactive_power",
                 "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2",       
                 "Sub_metering_3")
# call read.table, reading only data from 2007-02-01 and 2007-02-02 &  
# identifying missing values as "?"
hpc <- read.table("household_power_consumption.txt", header = FALSE, sep = ";", 
                  skip = 66637, nrows = 2880, colClasses = df_colClasses, 
                  col.names = df_colnames, na.strings = "?")

# concatenate data in Date and Time columns into a single column called "datetime" and 
# convert it to Date/Time class in R using the strptime() function
hpc$datetime <- paste(hpc$Date, hpc$Time)
hpc$datetime <- strptime(hpc$datetime, "%d/%m/%Y %H:%M:%S")

## create a plot of 480 x 480 pixels that matches the following:
# https://github.com/rdpeng/ExData_Plotting1/blob/master/figure/unnamed-chunk-4.png

# call the png graphics device, passing it the desired the plot size
png("plot3.png", width = 480, height = 480)
# If you uncomment the next line the plot background will be transparent
# par(bg = "transparent") 

# create an empty plot
with(hpc, plot(x = c(datetime, datetime, datetime), 
                      y = c(Sub_metering_1, Sub_metering_2, Sub_metering_3), 
                      type = "n", xlab = "", ylab = "Energy sub metering"))
# add the 3 lines representing the 3 submetering columns (by date)
with(hpc, lines(datetime, Sub_metering_1, col = "black"))
with(hpc, lines(datetime, Sub_metering_2, col = "red"))
with(hpc, lines(datetime, Sub_metering_3, col = "blue"))
# add the legend
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=1, col=c("black", "red", "blue"), cex=0.95, box.col=1)

# turn the png graphics device off
dev.off()
