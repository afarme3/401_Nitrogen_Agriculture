#ConvertForGIS.R : A script to convert csv data into shapefiles

#Imports
install.packages("sf")

library(sf)

#Import shapefiles
provinces <- st_read("./gis/Provinces/provinces.shp")
provincesDF <- data.frame(provinces)

#Import csv data
seededArea <- read.csv("./data/Converted/Total_Area/Canada_Total_v1.csv")
seededArea$date <- paste(seededArea$REF_DATE, "-01-01", sep="")
seededArea$Thousands.Nitrogen.Applied <- seededArea$Nitrogen.Applied/1000
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
