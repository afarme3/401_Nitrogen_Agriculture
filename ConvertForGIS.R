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
