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

convertPriceToWeight <- function(province){
  provincialDF <- interprovincial[interprovincial$GEO == province,]
  provincialPrices <- prices[prices$Province == province,]
  
  crops <- str_sub(levels(provincialDF$Product), end=-13)
  cropPrices <- levels(prices$Crop.Type)
}

convertPriceToWeight("Alberta")
