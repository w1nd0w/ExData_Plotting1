#skipping rows requires naming columns.
pwr <- read.csv("household_power_consumption.txt", header=F,
        sep=";", skip=(1440*46), nrows=(1440*3), na.strings="?",
        col.names = c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"),
        colClasses = c(rep("character",2),rep("numeric",7)) )

#clean up, subset
pwr <- subset(pwr, pwr$Date == "1/2/2007" | pwr$Date == "2/2/2007")
row.names(pwr) <- seq(nrow(pwr))

#convert chr to Date, POSIXct
pwr$Time <- strptime(paste(pwr$Date,pwr$Time), "%d/%m/%Y %H:%M:%S")

#Date not actually reqd
pwr$Date <- NULL
names(pwr)[1] <- "datetime"

#open image device
png(file="plot4.png", width=480, height=480, units="px", bg="white") # Open image device

#prepare for plot x 4
op <- par(mfrow = c(2, 2))

plot(pwr$datetime, pwr$Global_active_power, type="l",
     ylab="Global Active Power", xlab="")

with(pwr, plot(datetime, Voltage, type="l") )

plot(pwr$datetime, pwr$Sub_metering_1, type="l",
     ylab="Energy sub metering", xlab="")
lines(pwr$datetime, pwr$Sub_metering_2, col="red")
lines(pwr$datetime, pwr$Sub_metering_3, col="blue")
legend("topright", col=c("black","red","blue"), lty=1, bty="n", cex=0.8,
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

with(pwr, plot(datetime, Global_reactive_power, type="l") )

#restore
par(op)

#copy to image?
#dev.copy(png, file = "plot4.png")
dev.off()      # close
