library(data.table)
library(lubridate)

# Get the data for the project from the provided link

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filePath <- getwd()
fileName <- "projectData.zip"
download.file(url, file.path(filePath, fileName))
unzipedFile <- unzip(zipfile = fileName)

# Get the path for the downloaded file

startOfPathToRemove <- "^\\./"
dataFilePath <- file.path(filePath,
                          gsub(startOfPathToRemove, "", unzipedFile[grep("household_power_consumption.txt$", unzipedFile)]))

# Get the data from the downloaded file

data <- fread(dataFilePath, na.strings = "?")

# Set global active power as numeric

data[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

# Use lubridate to convert date and time to final date

data[, dateTime := dmy_hms(paste(Date, Time))]

# Get dates in the desired range

data <- data[(dateTime >= "2007-02-01") & (dateTime < "2007-02-03")]

png("plot2.png", width=480, height=480)

# Create plot

plot(x = data[, dateTime],
     y = data[, Global_active_power],
     type="l",
     xlab="",
     ylab="Global Active Power (kilowatts)")

dev.off()