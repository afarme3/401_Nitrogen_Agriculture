#SliceCropData.R
#An R script to pull out the relevant crop data from our Stats Canada data
#and output clean .csv files

#Import packages
install.packages("stringr")

library(ggplot2)
library(reshape)
library(stringr)

#Import data for trade
interprovincial <- read.csv("./data/Raw/interprovincial/interprovincial_crops.csv")

#Import Conversion Factors
prices <- read.csv("./data/Conversions/historical_prices.csv")

#Create a function which converts the crop prices/weights for a province
convertPriceToWeight <- function(province){
  #Get the data for just the province supplied
  provincialDF <- interprovincial[interprovincial$GEO == province,]
  provincialDF <- provincialDF[provincialDF$Trade.flow.detail == "Interprovincial exports",]
  provincialPrices <- prices[prices$Province == province,]
  
  #Iterate through crops of interest and generate data frame with price conversions
  crops <- str_sub(levels(provincialDF$Product), end=-13)
  
  #Create index variable
  i <- 0
  for (crop in crops) {
    #Get data frames with just the crops of interest
    provincial_byCrop <- provincialDF[str_sub(provincialDF$Product, end=-13) == crop,]
    prices_byCrop <- provincialPrices[provincialPrices$Crop.Type == crop,]
    #Iterate through years to perform year-by-year conversion
    years <- provincial_byCrop$REF_DATE
    MetricTonnes <- vector(mode="numeric")
    for (year in years) {
      
      #Get the yearly monetary value and convert to metric tonnes, add to vector
      dollarValue <- provincial_byCrop$VALUE[provincial_byCrop$REF_DATE == year] * 1000
      metricTonValue <- dollarValue / prices_byCrop$Dollars.Per.Metric.Tonne[prices_byCrop$Year == year]
      
      #Replaces empty values with NA if the conversion factor DNE for that year. 
      if(length(metricTonValue) == 0){
        metricTonValue <- NA
      }
      #Append the MetricTonnes vector with the MetricTonValue,
      MetricTonnes <- c(MetricTonnes, metricTonValue)
     
    }
    #Update provincial_byCrop with the MetricTonnes vector
    provincial_byCrop$Metric.Tonnes <- MetricTonnes
    
    #Create a new data frame on first run, or merge with existing on later runs
    if (i==0) {
      outputDF <- provincial_byCrop
      print(crop)
    } else {
      outputDF <- rbind(outputDF, provincial_byCrop)
      print(crop)
    }
    i <- i+1
  }
  
  return(outputDF)
  
}

albertaConverted <- convertPriceToWeight("Alberta")
