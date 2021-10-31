#SliceCropData.R
#An R script to pull out the relevant crop data from our Stats Canada data
#and output clean .csv files

#Import packages
library(ggplot2)
library(reshape)

#Import data for international trade
cereals <- read.csv("./data/international/cereals.csv")
oilSeeds <- read.csv("./data/international/oil seeds.csv")
veggies <- read.csv("./data/international/vegetables.csv")

barleyOld <- cereals[cereals$Commodity == "1003.00.00 - Barley (Terminated 1998-12)", 1:8]

#Import Data for Fertilizer Seeded Area
quebec <- read.csv("./data/fertilizer/QUEBEC.csv")

ggplot(data=quebec, aes(x=REF_DATE, y=VALUE, color=Type.of.crop))+
  geom_line(size=2)+
  theme_light()+
  xlab("Year")+
  ylab("Crop Seeded Area (Ha)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Crop Seeded Area (Ha) Over Time for Quebec")
