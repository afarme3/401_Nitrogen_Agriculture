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
    
    #Get an average price-to-mass in the case of missing values
    priceAvg <- mean(prices_byCrop$Dollars.Per.Metric.Tonne)
    
    #Iterate through years to perform year-by-year conversion, initialize output vector
    years <- provincial_byCrop$REF_DATE
    MetricTonnes <- vector(mode="numeric")
    for (year in years) {
      
      #Get the yearly monetary value and convert to metric tonnes, add to vector
      dollarValue <- provincial_byCrop$VALUE[provincial_byCrop$REF_DATE == year] * 1000
      metricTonValue <- dollarValue / prices_byCrop$Dollars.Per.Metric.Tonne[prices_byCrop$Year == year]
      
      #Replaces empty values with NA if the conversion factor DNE for that year. 
      if(length(metricTonValue) == 0){
        metricTonValue <- dollarValue / priceAvg
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
potatoes <- read.csv("./data/Conversions/kg-ha/potatoes_v2.csv")

#Create a function which converts the weights to seeded area
convertWeightToArea <- function(province, provincialDF){
  
  #Get the conversion factors for the province of interest
  provincialYields <- yields[yields$GEO == province,]
  provincialPotatoes <- potatoes[potatoes$GEO == province,]
  
  #Extract the crops of interest from the data frame
  crops <- str_sub(levels(provincialDF$Product), end=-13)
  
  #Create an index variable
  i <- 0

  #Iterate over the crops of interest
  for (crop in crops){
    #Get data frames with just the crops of interest
    provincial_byCrop <- provincialDF[str_sub(provincialDF$Product, end=-13) == crop,]
    
    #Special case for potatoes, otherwise use provincialYields
    if (crop == "Fresh potatoes"){
      yields_byCrop <- provincialPotatoes
    } else{
    yields_byCrop <- provincialYields[provincialYields$Type.of.crop == crop,]
    }
    
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
    #Special case for potatoes
    if (crop == "Fresh potatoes"){
      averageYield <- mean(yields_byCrop$KG_HA)
    }
    
    #Iterate over years
    years <- provincial_byCrop$REF_DATE
    for (year in years){
      #Get the yearly mass value and convert to seeded area, add to vector
      massValue <- provincial_byCrop$Kilograms[provincial_byCrop$REF_DATE == year]
      areaValue <- massValue / yields_byCrop$VALUE[yields_byCrop$Year == year]
      
      #Special case for potatoes
      if (crop == "Fresh potatoes"){
        areaValue <- massValue / yields_byCrop$KG_HA[yields_byCrop$REF_DATE == year]
      }
      
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

#
# Convert seeded area to nitrogen applied
#
#Import conversion factors, melt into vertical format
applications <- read.csv("./data/Conversions/recommended_fertilizer.csv")
rates <- melt(applications)

#Create a function to convert from seeded area to nitrogen applied
convertAreaToN <- function(province, provincialDF){
  
  #Correct province name if province selected is one of the atlantic provinces or BC
  atlanticProvinces <- c("New Brunswick", "Newfoundland and Labrador", "Nova Scotia", "Prince Edward Island")
  if(any(grepl(province, atlanticProvinces))){
    provinceName <- "Atlantic.provinces"
  } else if(province == "British Columbia"){
    provinceName <- "British.Columbia"
  } else{
    provinceName <- province
  }
  
  #Extract the crops of interest from the data frame
  crops <- str_sub(levels(provincialDF$Product), end=-13)
  
  #Extract only the province of interest from the conversion table
  rates_byProvince <- rates[rates$variable == provinceName,]
  
  #Initialize an index variable
  i <- 0
  
  #Iterate over crops of interest
  for (crop in crops){
    #Get data frames with just the crops of interest
    provincial_byCrop <- provincialDF[str_sub(provincialDF$Product, end=-13) == crop,]
    rate_byCrop <- rates_byProvince[rates_byProvince$Crop == crop,]
    
    #Edge case: use Cereal factor for grains excluding wheat, use flaxseed for oilseeds excluding canola
    if(crop == "Grains (except wheat)"){
      rate_byCrop <- rates_byProvince[rates_byProvince$Crop == "Cereals",]
    }
    if(crop == "Oilseeds (except canola)"){
      rate_byCrop <- rates_byProvince[rates_byProvince$Crop == "Flaxseed",]
    }
    
    #Initialize empty vector to store converted results
    nitrogenApplied <- vector(mode="numeric")
    
    #Iterate over years
    years <- provincial_byCrop$REF_DATE
    for (year in years){
      #Get the yearly mass value and convert to seeded area, add to vector
      areaValue <- provincial_byCrop$Seeded.Area[provincial_byCrop$REF_DATE == year]
      nValue <- areaValue * rate_byCrop$value
      
      #Set missing values to NA
      if (length(nValue) == 0){
        nValue <- NA
      }
      #Append output vector
      nitrogenApplied <- c(nitrogenApplied, nValue)
    }
    
    #Update provincial_byCrop with the seededArea vector
    provincial_byCrop$Nitrogen.Applied <- nitrogenApplied
    
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

albertaConverted_3 <- convertAreaToN("Alberta", albertaConverted_2)
manitobaConverted_3 <- convertAreaToN("Manitoba", manitobaConverted_2)
bcConverted_3 <- convertAreaToN("British Columbia", bcConverted_2)
nbConverted_3 <- convertAreaToN("New Brunswick", nbConverted_2)
nalConverted_3 <- convertAreaToN("Newfoundland and Labrador", nalConverted_2)
nsConverted_3 <- convertAreaToN("Nova Scotia", nsConverted_2)
ontarioConverted_3 <- convertAreaToN("Ontario", ontarioConverted_2)
peiConverted_3 <- convertAreaToN("Prince Edward Island", peiConverted_2)
quebecConverted_3 <- convertAreaToN("Quebec", quebecConverted_2)
saskatchewanConverted_3 <- convertAreaToN("Saskatchewan", saskatchewanConverted_2)

#Output final converted data frames to file
write.csv(albertaConverted_3, "./data/Converted/Interprovincial/alberta_interprovincial_v1.csv")
write.csv(manitobaConverted_3, "./data/Converted/Interprovincial/manitoba_interprovincial_v1.csv")
write.csv(bcConverted_3, "./data/Converted/Interprovincial/bc_interprovincial_v1.csv")
write.csv(nbConverted_3, "./data/Converted/Interprovincial/new_brunswick_interprovincial_v1.csv")
write.csv(nalConverted_3, "./data/Converted/Interprovincial/newfoundland_and_labrador_interprovincial_v1.csv")
write.csv(nsConverted_3, "./data/Converted/Interprovincial/nova_scotia_interprovincial_v1.csv")
write.csv(ontarioConverted_3, "./data/Converted/Interprovincial/ontario_interprovincial_v1.csv")
write.csv(peiConverted_3, "./data/Converted/Interprovincial/pei_interprovincial_v1.csv")
write.csv(quebecConverted_3, "./data/Converted/Interprovincial/quebec_interprovincial_v1.csv")
write.csv(saskatchewanConverted_3, "./data/Converted/Interprovincial/saskatchewan_interprovincial_v1.csv")

#
# Convert international trade data to nitrogen footprint
#
#Import international crop data, convert from metric tonnes to kilos as needed. Extract out just the crops of interest
barley <- read.csv("./data/Raw/international/barley.csv")
barley$Kilograms <- barley$Quantity*1000
corn <- read.csv("./data/Raw/international/corn.csv")
corn$Kilograms <- corn$Quantity*1
oats <- read.csv("./data/Raw/international/oats.csv")
oats$Kilograms <- oats$Quantity*1
oilseeds <- read.csv("./data/Raw/international/oilseeds.csv")
oilseeds$Kilograms <- oilseeds$Quantity*1
cereals <- read.csv("./data/Raw/international/other_cereals.csv")
cereals$Kilograms <- cereals$Quantity*1
potatoes <- read.csv("./data/Raw/international/potatoes.csv")
potatoes$Kilograms <- potatoes$Quantity*1000
rapeseeds <- read.csv("./data/Raw/international/rapeseeds.csv")
rapeseeds$Kilograms <- rapeseeds$Quantity*1
wheat <- read.csv("./data/Raw/international/wheat.csv")
wheat$Kilograms <- wheat$Quantity*1000

#Merge data frames
international <- rbind(barley, corn, oats, oilseeds, cereals, potatoes, rapeseeds, wheat)

#Import conversion factors
yields <- read.csv("./data/Conversions/kg-ha/Full_Yield_v2.csv")
potatoes <- read.csv("./data/Conversions/kg-ha/potatoes_v2.csv")

convertIntlMassToArea <- function(province){
  #Get the provincial dataframe as sliced from the full international
  provincialDF <- international[international$Province == province,]
  
  #Get the conversion factors for the province of interest
  provincialYields <- yields[yields$GEO == province,]
  provincialPotatoes <- potatoes[potatoes$GEO == province,]
  
  #Extract the crops of interest from the yields conversion table
  crops <- c(levels(yields$Type.of.crop), "Fresh potatoes")
  
  #Create an index variable
  i <- 0
  
  #Iterate over the crops of interest
  for (crop in crops){
    #Special case for potatoes and generic corn, otherwise use provincialYields
    if (crop == "Fresh potatoes"){
      yields_byCrop <- provincialPotatoes
    } else{
      yields_byCrop <- provincialYields[provincialYields$Type.of.crop == crop,]
    }
    
    #Setup names vector for grep based on type of crop
    if (crop == "Barley"){
      names <- c("Barley, o/t certified organic, o/t seed for sowing", "Barley, except seed", "Barley (Terminated 1998-12)")
    } else if (crop == "Canola (including rapeseed)"){
      names <- c("Rape")
    } else if (crop == "Corn for grain"){
      names <- c("Corn")
    } else if (crop == "Flaxseed"){
      names <- c("Oil seeds") 
    } else if (crop == "Oats"){
      names <- c("Oats, other than seed for sowing", "Oat, o/t certified organic, o/t seed for sowing", "Oats, except seed")
    } else if (crop == "Rye"){
      names <- c("Wheat and meslin, other than durum wheat, other than seed for sowing", "Wheat, nes and meslin, o/t certified organic, o/t seed for sowing", "Wheat, nes and meslin, other than seed for sowing", "Meslin")
    } else if (crop == "Wheat"){
      names <- c("wheat, exc seed", "Wheat, nes and meslin, o/t certified organic", "Wheat, nes (Terminated 2011-12)", "Wheat nes, except seed")
    } else if (crop == "Wheat, durum"){
      names <- c("Wheat, durum", "Durum wheat, o/t certified organic", "Durum wheat (Terminated 2014-12)", "Durum wheat, other than seed for sowing", "Durum wheat, except seed")
    } else if (crop == "Wheat, spring"){
      names <- c("spring wheat, o/t", "spring wheat, exc", "spring wheat, nes, other than seed for sowing", "spring wheat, grade 2, other than seed for sowing", "spring wheat, other")
    } else if (crop == "Wheat, winter remaining"){
      names <- c("winter wheat, except seed", "winter wheat, other", "winter wheat, o/t", "winter wheat, exc")
    } else if (crop == "Fresh potatoes"){
      names <- c("Potatoes, fresh")
    } else {
      names <- c("NA")
    }
    
    #Get data frames with just the crops of interest by using grepL to 
    provincial_byCrop <- provincialDF[grepl(paste(names, collapse="|"), provincialDF$Commodity),]
    
    #Create an average yield conversion factor in case there are missing values
    averageYield <- 0
    averageYield <- mean(yields_byCrop$VALUE)
    #Special case for potatoes
    if (crop == "Fresh potatoes"){
      averageYield <- mean(yields_byCrop$KG_HA)
    }
    
    #Initialize another counting variable
    j <- 0
    
    #Iterate over years, cut off the January 1st component
    years <- unique(str_sub(provincial_byCrop$Period, end=-7))
    for (year in years){
      #Get the yearly mass value and convert to seeded area, add to vector
      provincial_byYear <- provincial_byCrop[str_sub(provincial_byCrop$Period, end=-7) == year, ]
      areaValues <- provincial_byYear$Kilograms / yields_byCrop$VALUE[yields_byCrop$Year == year]
      
      #Special case for potatoes
      if (crop == "Fresh potatoes"){
        areaValues <- provincial_byYear$Kilograms / yields_byCrop$KG_HA[yields_byCrop$REF_DATE == year]
      }
      
      #Catch missing conversion values by using the conversion by utilizing the overall average
      if (any(is.na(areaValues)) || length(areaValues)==0){
        areaValues <- provincial_byYear$Kilograms / averageYield
      }
      
      #Add area values to the dataframe
      provincial_byYear$Seeded.Area <- areaValues
      
      #Create a new data frame on first run, or merge with existing on later runs
      if (j==0) {
        byCrop_output <- provincial_byYear
      } else {
        byCrop_output <- rbind(byCrop_output, provincial_byYear)
      }
      j <- j+1
    }
    
    #Create a new data frame on first run, or merge with existing on later runs
    if (exists("byCrop_output")){
      if (i==0) {
        outputDF <- byCrop_output
      } else {
        outputDF <- rbind(outputDF, byCrop_output)
      }
      i <- i+1
      rm(byCrop_output)
    }
  }
  
  return(outputDF)
}

#Perform mass-to-area conversions for the international data
albertaIntl <- convertIntlMassToArea("Alberta")
manitobaIntl <- convertIntlMassToArea("Manitoba")
bcIntl <- convertIntlMassToArea("British Columbia")
nbIntl <- convertIntlMassToArea("New Brunswick")
nalIntl <- convertIntlMassToArea("Newfoundland and Labrador")
nsIntl <- convertIntlMassToArea("Nova Scotia")
ontarioIntl <- convertIntlMassToArea("Ontario")
peiIntl <- convertIntlMassToArea("Prince Edward Island")
quebecIntl <- convertIntlMassToArea("Quebec")
saskatchewanIntl <- convertIntlMassToArea("Saskatchewan")

#Import conversion data
applications <- read.csv("./data/Conversions/recommended_fertilizer.csv")
rates <- melt(applications)

#Create a function to perform area-to-nitrogen conversions for international data
convertIntlAreaToN <- function(province, provincialDF){
  #Correct province name if province selected is one of the atlantic provinces or BC
  atlanticProvinces <- c("New Brunswick", "Newfoundland and Labrador", "Nova Scotia", "Prince Edward Island")
  if(any(grepl(province, atlanticProvinces))){
    provinceName <- "Atlantic.provinces"
  } else if(province == "British Columbia"){
    provinceName <- "British.Columbia"
  } else{
    provinceName <- province
  }
  
  #Extract only the province of interest from the conversion table
  rates_byProvince <- rates[rates$variable == provinceName,]
  
  #Extract the crops of interest from the yields conversion table
  crops <- c("Canola (including rapeseed)", "Corn for Grain", "Flaxseed", "Oats", "Cereals", "Fresh potatoes", "Winter wheat", "Spring wheat")
  
  #Create an index variable
  i <- 0
  
  #Iterate over the crops of interest
  for (crop in crops){
    
    #Setup names vector for grep based on type of crop
    if (crop == "Barley"){
        names <- c()
    } else if (crop == "Canola (including rapeseed)"){
      names <- c("Rape")
    } else if (crop == "Corn for grain"){
      names <- c("Corn")
    } else if (crop == "Flaxseed"){
      names <- c("Oil seeds") 
    } else if (crop == "Oats"){
      names <- c("Oats, other than seed for sowing", "Oat, o/t certified organic, o/t seed for sowing", "Oats, except seed")
    } else if (crop == "Cereals"){
      names <- c("Barley, o/t certified organic, o/t seed for sowing", "Barley, except seed", "Barley (Terminated 1998-12)", "Wheat and meslin, other than durum wheat, other than seed for sowing", "Wheat, nes and meslin, o/t certified organic, o/t seed for sowing", "Wheat, nes and meslin, other than seed for sowing", "Meslin")
    } else if (crop == "Wheat"){
      names <- c("Wheat, durum", "Durum wheat, o/t certified organic", "Durum wheat (Terminated 2014-12)", "Durum wheat, other than seed for sowing", "Durum wheat, except seed", "wheat, exc seed", "Wheat, nes and meslin, o/t certified organic", "Wheat, nes (Terminated 2011-12)", "Wheat nes, except seed")
    } else if (crop == "Spring wheat"){
      names <- c("spring wheat, o/t", "spring wheat, exc", "spring wheat, nes, other than seed for sowing", "spring wheat, grade 2, other than seed for sowing", "spring wheat, other")
    } else if (crop == "Winter wheat"){
      names <- c("winter wheat, except seed", "winter wheat, other", "winter wheat, o/t", "winter wheat, exc")
    } else if (crop == "Fresh potatoes"){
      names <- c("Potatoes, fresh")
    } else {
      names <- c("NA")
    }
    
    #Get data frames with just the crops of interest by using grepL to 
    provincial_byCrop <- provincialDF[grepl(paste(names, collapse="|"), provincialDF$Commodity),]
    nValues <- provincial_byCrop$Seeded.Area * rates_byProvince$value[rates_byProvince$Crop == crop]
    
    #Create by crop output df
    byCrop_output <- provincial_byCrop
    byCrop_output$Nitrogen.Applied <- nValues
    
    #Create a new data frame on first run, or merge with existing on later runs
    if (exists("byCrop_output")){
      if (i==0) {
        outputDF <- byCrop_output
      } else {
        outputDF <- rbind(outputDF, byCrop_output)
      }
      i <- i+1
      rm(byCrop_output)
    }
  }
  return(outputDF)
}

#Convert area-to-nitrogen for the international data
albertaIntlConverted <- convertIntlAreaToN("Alberta", albertaIntl)
manitobaIntlConverted <- convertIntlAreaToN("Manitoba", manitobaIntl)
bcIntlConverted <- convertIntlAreaToN("British Columbia", bcIntl)
nbIntlConverted <- convertIntlAreaToN("New Brunswick", nbIntl)
nalIntlConverted <- convertIntlAreaToN("Newfoundland and Labrador", nalIntl)
nsIntlConverted <- convertIntlAreaToN("Nova Scotia", nsIntl)
ontarioIntlConverted <- convertIntlAreaToN("Ontario", ontarioIntl)
peiIntlConverted <- convertIntlAreaToN("Prince Edward Island", peiIntl)
quebecIntlConverted <- convertIntlAreaToN("Quebec", quebecIntl)
saskatchewanIntlConverted <- convertIntlAreaToN("Saskatchewan", saskatchewanIntl)

#Write converted data files
write.csv(albertaIntlConverted, "./data/Converted/International/alberta_international_v1.csv")
write.csv(manitobaIntlConverted, "./data/Converted/International/manitoba_international_v1.csv")
write.csv(bcIntlConverted, "./data/Converted/International/british_columbia_international_v1.csv")
write.csv(nbIntlConverted, "./data/Converted/International/new_brunswick_international_v1.csv")
write.csv(nalIntlConverted, "./data/Converted/International/newfoundland_and_labrador_international_v1.csv")
write.csv(nsIntlConverted, "./data/Converted/International/nova_scotia_international_v1.csv")
write.csv(ontarioIntlConverted, "./data/Converted/International/ontario_international_v1.csv")
write.csv(peiIntlConverted, "./data/Converted/International/pei_international_v1.csv")
write.csv(quebecIntlConverted, "./data/Converted/International/quebec_international_v1.csv")
write.csv(saskatchewanIntlConverted, "./data/Converted/International/saskatchewan_international_v1.csv")





