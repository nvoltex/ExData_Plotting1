library(data.table)

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

# Convert Date Column to Date Type

data[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

# Get dates in the desired range

data <- data[(Date >= "2007-02-01") & (Date <= "2007-02-02")]

# Create histogram

png("plot1.png", width=480, height=480)

hist(data[, Global_active_power],
     main="Global Active Power", 
     xlab="Global Active Power (kilowatts)",
     ylab="Frequency",
     col="Red")

dev.off()