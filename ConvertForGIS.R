#ConvertForGIS.R : A script to convert csv data into shapefiles

#Imports
install.packages("sf")

library(sf)

#Import shapefiles
provinces <- st_read("./gis/Provinces/provinces.shp")
provincesDF <- data.frame(provinces)

#
# Convert total seeded area
#
#Import csv data
seededArea <- read.csv("./data/Converted/Total_Area/Canada_Total_v1.csv")

#Add date column and nitrogen applied in thousands of kgs, a more shapefile-friendly format
seededArea$date <- paste(seededArea$REF_DATE, "-01-01", sep="")
seededArea$Thousands.Nitrogen.Applied <- seededArea$Nitrogen.Applied/1000

#Get list of crops
cropsList <- levels(seededArea$Type.of.crop)

for (crop in cropsList){
  i <- 0  
  
  seededCrop <- seededArea[seededArea$Type.of.crop == crop,]
  provincesList <- unique(seededCrop$GEO)
  
  for (province in provincesList){
    provincialDF <- seededCrop[seededCrop$GEO == province,]
    provincialDF$geometry <- provincesDF[provincesDF$PRENAME == province,]$geometry
   
    if (i==0) {
      outputDF <- provincialDF
    } else {
      outputDF <- rbind(outputDF, provincialDF)
    }
    i <- i+1 
  }
  filename = paste("./gis/SeededArea/", toString(crop), ".shp", sep="")
  cropSF <- st_as_sf(outputDF)
  st_write(cropSF, filename, driver="ESRI Shapefile", append=FALSE)
  
}

#
# Convert interprovincial total exports
#
#Import csv data
interprovincial <- read.csv("./data/Converted/Interprovincial/canada_interprovincial_total_v1.csv")

#Add date column and nitrogen applied in thousands of kgs, a more shapefile-friendly format
interprovincial$date <- paste(interprovincial$REF_DATE, "-01-01", sep="")
interprovincial$Thousands.Nitrogen.Applied <- interprovincial$Nitrogen.Applied/1000

#Get list of crops
crops <- levels(interprovincial$Product)

#Iterate through crops and produce/write shapefiles
for (crop in crops){
  i <- 0  
  
  interprovCrop <- interprovincial[interprovincial$Product == crop,]
  provincesList <- unique(interprovCrop$GEO)
  
  for (province in provincesList){
    provincialDF <- interprovCrop[interprovCrop$GEO == province,]
    provincialDF$geometry <- provincesDF[provincesDF$PRENAME == province,]$geometry
    
    if (i==0) {
      outputDF <- provincialDF
    } else {
      outputDF <- rbind(outputDF, provincialDF)
    }
    i <- i+1 
  }
  filename = paste("./gis/Interprovincial/", str_sub(crop, end=-13), "_interprovincial.shp", sep="")
  cropSF <- st_as_sf(outputDF)
  st_write(cropSF, filename, driver="ESRI Shapefile", append=FALSE)
  
}

#
# Convert international total exports
#
international <- read.csv("./data/Converted/International/canada_total_international.csv")

#Add date column and nitrogen applied in thousands of kgs, a more shapefile-friendly format
international$Thousands.Nitrogen.Applied <- international$Nitrogen.Applied/1000

#Get list of crops
crops <- c("Barley", "Canola (including rapeseed)", "Corn for grain", "Flaxseed", "Oats", "Rye", "Wheat", "Wheat, durum", "Wheat, spring", "Wheat, winter remaining", "Fresh potatoes")

for (crop in crops){
  i <- 0  
  
  if (crop == "Barley"){
    names <- c("Barley, o/t certified organic, o/t seed for sowing", "Barley, except seed", "Barley (Terminated 1998-12)")
  } else if (crop == "Canola (including rapeseed)"){
    names <- c("Rape")
  } else if (crop == "Corn for grain"){
    names <- c("Corn", "corn")
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
  
  internatCrop <- international[interprovincial$Product == crop,]
  provincesList <- unique(interprovCrop$GEO)
  
  for (province in provincesList){
    provincialDF <- interprovCrop[interprovCrop$GEO == province,]
    provincialDF$geometry <- provincesDF[provincesDF$PRENAME == province,]$geometry
    
    if (i==0) {
      outputDF <- provincialDF
    } else {
      outputDF <- rbind(outputDF, provincialDF)
    }
    i <- i+1 
  }
  filename = paste("./gis/Interprovincial/", str_sub(crop, end=-13), "_interprovincial.shp", sep="")
  cropSF <- st_as_sf(outputDF)
  st_write(cropSF, filename, driver="ESRI Shapefile", append=FALSE)
  
}
