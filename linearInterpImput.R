## Time Series fill script for MFL time series
require(tcltk) # open prompt for writing .csv file with filled data
require(zoo) # time series fill functions

stationData <- read.csv(file.choose(), stringsAsFactors = FALSE)
zooStationData <- zoo(stationData[2:length(stationData[1,])],as.Date(stationData$date, format = "%m/%d/%Y")) # must create zoo obect for filling algorith
filledZoo = na.approx(zooStationData, maxgap = 90, na.rm = FALSE) # fill in data with linear interpolation
filledZoo = na.locf(filledZoo, maxgap = 10, fromLast = TRUE) # fill in data with nearest real value from back to forward to fill values at beggining
filledZoo = na.locf(filledZoo, maxgap = 10, fromLast = FALSE) # fill in data with nearest real value forward to fill in end values
filledDF = data.frame(filledZoo) # convert back to dataframe from zoo
filledDF = data.frame(data.frame(row.names(filledDF)), filledDF) # add date column to filledDF
colnames(filledDF)[1] = c("date")
filledDF = filledDF[order(filledDF$date),] # Sort df.filled by date
write.csv(filledDF, file = paste0(tclvalue(tcl("tk_getSaveFile")),".csv"), row.names = FALSE)