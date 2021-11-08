#ConvertCropData.R
#A script to perform the necessary conversions for our crop data

#Import packages
install.packages("ggplot2")
install.packages("reshape")
install.packages("stringr")

library(ggplot2)
library(reshape)
library(stringr)

#
# Convert Interprovincial trade export value to mass
#
#Import data for trade
interprovincial <- read.csv("./data/Raw/interprovincial/interprovincial_crops.csv")

#Import Conversion Factors
prices <- read.csv("./data/Conversions/historical_prices.csv")

#Create a function which converts the crop prices/weights for a province (interprovincial trade)
convertPriceToWeight <- function(province){
  #Get the data for just the province supplied
  provincialDF <- interprovincial[interprovincial$GEO == province,]
  provincialDF <- provincialDF[provincialDF$Trade.flow.detail == "Interprovincial exports",]
  provincialPrices <- prices[prices$Province == province,]
  
  #Create index variable
  i <- 0
  
  #Iterate through crops of interest and generate data frame with price conversions
  crops <- str_sub(levels(provincialDF$Product), end=-13)
  for (crop in crops) {
    #Get data frames with just the crops of interest
    provincial_byCrop <- provincialDF[str_sub(provincialDF$Product, end=-13) == crop,]
    prices_byCrop <- provincialPrices[provincialPrices$Crop.Type == crop,]
    
    #Edge case: for arbitrary grains, use the Rye conversion factor, for oilseeds, use flaxseed
    if(crop == "Grains (except wheat)"){
      prices_byCrop <- provincialPrices[provincialPrices$Crop.Type == "Rye",]
    }
    
    if(crop == "Oilseeds (except canola)"){
      prices_byCrop <- provincialPrices[provincialPrices$Crop.Type == "Flaxseed",]
    }
    
    #Iterate through years to perform year-by-year conversion, initialize output vector
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
    kilograms <- MetricTonnes * 1000
    provincial_byCrop$Kilograms <- kilograms
    
    #Create a new data frame on first run, or merge with existing on later runs
    if (i==0) {
      outputDF <- provincial_byCrop
    } else {
      outputDF <- rbind(outputDF, provincial_byCrop)
    }
    i <- i+1
  }
  
  return(outputDF)
  
}

#Use function to convert interprovincial crop prices to mass
albertaConverted <- convertPriceToWeight("Alberta")
manitobaConverted <- convertPriceToWeight("Manitoba")
bcConverted <- convertPriceToWeight("British Columbia")
nbConverted <- convertPriceToWeight("New Brunswick")
nalConverted <- convertPriceToWeight("Newfoundland and Labrador")
nsConverted <- convertPriceToWeight("Nova Scotia")
ontarioConverted <- convertPriceToWeight("Ontario")
peiConverted <- convertPriceToWeight("Prince Edward Island")
quebecConverted <- convertPriceToWeight("Quebec")
saskatchewanConverted <- convertPriceToWeight("Saskatchewan")

#
# Convert Interprovincial trade export mass to seeded area
#
#Import conversion factors
yields <- read.csv("./data/Conversions/kg-ha/Full_Yield_v2.csv")

#Create a function which converts the weights to seeded area
convertWeightToArea <- function(province, provincialDF){
  
  #Get the conversion factors for the province of interest
  provincialYields <- yields[yields$GEO == province,]
  
  #Extract the crops of interest from the data frame
  crops <- str_sub(levels(provincialDF$Product), end=-13)
  
  #Create an index variable
  i <- 0

  #Iterate over the crops of interest
  for (crop in crops){
    #Get data frames with just the crops of interest
    provincial_byCrop <- provincialDF[str_sub(provincialDF$Product, end=-13) == crop,]
    yields_byCrop <- provincialYields[provincialYields$Type.of.crop == crop,]
    
    #Edge case: use Rye factor for grains excluding wheat, use flaxseed for oilseeds excluding canola
    if(crop == "Grains (except wheat)"){
      yields_byCrop <- provincialYields[provincialYields$Type.of.crop == "Rye",]
    }
    
    if(crop == "Oilseeds (except canola)"){
      yields_byCrop <- provincialYields[provincialYields$Type.of.crop == "Flaxseed",]
    }
    
    #Initialize empty vector to store converted results
    seededArea <- vector(mode="numeric")
    
    #Create an average yield conversion factor in case there are missing values
    averageYield <- mean(yields_byCrop$VALUE)
    
    #Iterate over years
    years <- provincial_byCrop$REF_DATE
    for (year in years){
      #Get the yearly mass value and convert to seeded area, add to vector
      massValue <- provincial_byCrop$Kilograms[provincial_byCrop$REF_DATE == year]
      areaValue <- massValue / yields_byCrop$VALUE[yields_byCrop$Year == year]
      
      #Catch missing conversion values by using the conversion by utilizing the overall average
      if (length(areaValue) == 0){
        areaValue <- massValue / averageYield
      }
      #Append output vector
      seededArea <- c(seededArea, areaValue)
    }
    
    #Update provincial_byCrop with the seededArea vector
    provincial_byCrop$Seeded.Area <- seededArea
    
    #Create a new data frame on first run, or merge with existing on later runs
    if (i==0) {
      outputDF <- provincial_byCrop
    } else {
      outputDF <- rbind(outputDF, provincial_byCrop)
    }
    i <- i+1
  }
  
  return(outputDF)
  
}

#Use the function to convert for each province
albertaConverted_2 <- convertWeightToArea("Alberta", albertaConverted)
manitobaConverted_2 <- convertWeightToArea("Manitoba", manitobaConverted)
bcConverted_2 <- convertWeightToArea("British Columbia", bcConverted)
nbConverted_2 <- convertWeightToArea("New Brunswick", nbConverted)
nalConverted_2 <- convertWeightToArea("Newfoundland and Labrador", nalConverted)
nsConverted_2 <- convertWeightToArea("Nova Scotia", nsConverted)
ontarioConverted_2 <- convertWeightToArea("Ontario", ontarioConverted)
peiConverted_2 <- convertWeightToArea("Prince Edward Island", peiConverted)
quebecConverted_2 <- convertWeightToArea("Quebec", quebecConverted)
saskatchewanConverted_2 <- convertWeightToArea("Saskatchewan", saskatchewanConverted)




