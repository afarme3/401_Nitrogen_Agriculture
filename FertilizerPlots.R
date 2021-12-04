#
#Import Libraries
library(ggplot2)
library(tidyverse)
library(stringr)

#Import Data for Fertilizer Seeded Area
quebec <- read.csv("./data/Raw/fertilizer/QUEBEC.csv")
alberta <- read.csv("./data/Raw/fertilizer/ALBERTA.csv")
bc <- read.csv("./data/Raw/fertilizer/BC.csv")
newBrunswick <- read.csv("./data/Raw/fertilizer/NEW BRUNSWICK.csv")
NaL <- read.csv("./data/Raw/fertilizer/NEWFOUNDLAND AND LABRADOR.csv")
novaScotia <- read.csv("./data/Raw/fertilizer/NOVA SCOTIA.csv")
ontario <- read.csv("./data/Raw/fertilizer/ONTARIO.csv")
pei <- read.csv("./data/Raw/fertilizer/PRINCE EDWARD ISLAND.csv")
manitoba <- read.csv("./data/Raw/fertilizer/MANITOBA.csv")
saskatchewan <- read.csv("./data/Raw/fertilizer/SASKATCHEWAN.csv")

#Create Plots
#Quebec
ggplot(data=quebec, aes(x=REF_DATE, y=VALUE, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Crop Seeded Area (Ha)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Crop Seeded Area (Ha) Over Time for Quebec")

#Alberta
ggplot(data=alberta, aes(x=REF_DATE, y=VALUE, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Crop Seeded Area (Ha)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Crop Seeded Area (Ha) Over Time for Alberta")

#BC
ggplot(data=bc, aes(x=REF_DATE, y=VALUE, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Crop Seeded Area (Ha)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Crop Seeded Area (Ha) Over Time for British Columbia")

#New Brunswick
ggplot(data=newBrunswick, aes(x=REF_DATE, y=VALUE, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Crop Seeded Area (Ha)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Crop Seeded Area (Ha) Over Time for New Brunswick")

#NaL
ggplot(data=NaL, aes(x=REF_DATE, y=VALUE, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Crop Seeded Area (Ha)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Crop Seeded Area (Ha) Over Time for Newfoundland and Labrador")

#Nova Scotia
ggplot(data=novaScotia, aes(x=REF_DATE, y=VALUE, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Crop Seeded Area (Ha)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Crop Seeded Area (Ha) Over Time for Nova Scotia")

#Ontario
ggplot(data=ontario, aes(x=REF_DATE, y=VALUE, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Crop Seeded Area (Ha)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Crop Seeded Area (Ha) Over Time for Ontario")

#PEI
ggplot(data=pei, aes(x=REF_DATE, y=VALUE, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Crop Seeded Area (Ha)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Crop Seeded Area (Ha) Over Time for Prince Edward Island")

#Manitoba
ggplot(data=manitoba, aes(x=REF_DATE, y=VALUE, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Crop Seeded Area (Ha)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Crop Seeded Area (Ha) Over Time for Manitoba")

#Saskatchewan
ggplot(data=saskatchewan, aes(x=REF_DATE, y=VALUE, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Crop Seeded Area (Ha)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Crop Seeded Area (Ha) Over Time for Saskatchewan")

#
# Post-conversion plots
#

#Import Data for Fertilizer Applied
alberta <- read.csv("./data/Converted/Total_Area/Alberta_Total_v1.csv")
bc <- read.csv("./data/Converted/Total_Area/British_Columbia_Total_v1.csv")
manitoba <- read.csv("./data/Converted/Total_Area/Manitoba_Total_v1.csv")
newBrunswick <- read.csv("./data/Converted/Total_Area/New_Brunswick_Total_v1.csv")
NaL <- read.csv("./data/Converted/Total_Area/Newfoundland_and_Labrador_Total_v1.csv")
novaScotia <- read.csv("./data/Converted/Total_Area/Nova_Scotia_Total_v1.csv")
ontario <- read.csv("./data/Converted/Total_Area/Ontario_Total_v1.csv")
pei <- read.csv("./data/Converted/Total_Area/PEI_Total_v1.csv")
quebec <- read.csv("./data/Converted/Total_Area/Quebec_Total_v1.csv")
saskatchewan <- read.csv("./data/Converted/Total_Area/Saskatchewan_Total_v1.csv")

#Create Plots of nitrogen usage over time for different crops
#Quebec
ggplot(data=quebec, aes(x=REF_DATE, y=Nitrogen.Applied, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Nitrogen Applied (kg)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Nitrogen Applied (kg) Over Time for Quebec")

#Alberta
ggplot(data=alberta, aes(x=REF_DATE, y=Nitrogen.Applied, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Nitrogen Applied (kg)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Nitrogen Applied (kg) Over Time for Alberta")

#BC
ggplot(data=bc, aes(x=REF_DATE, y=Nitrogen.Applied, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Nitrogen Applied (kg)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Nitrogen Applied (kg) Over Time for British Columbia")

#New Brunswick
ggplot(data=newBrunswick, aes(x=REF_DATE, y=Nitrogen.Applied, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Nitrogen Applied (kg)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Nitrogen Applied (kg) Over Time for New Brunswick")

#NaL
ggplot(data=NaL, aes(x=REF_DATE, y=Nitrogen.Applied, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Nitrogen Applied (kg)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Nitrogen Applied (kg) Over Time for Newfoundland and Labrador")

#Nova Scotia
ggplot(data=novaScotia, aes(x=REF_DATE, y=Nitrogen.Applied, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Nitrogen Applied (kg)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Nitrogen Applied (kg) Over Time for Nova Scotia")

#Ontario
ggplot(data=ontario, aes(x=REF_DATE, y=Nitrogen.Applied, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Nitrogen Applied (kg)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Nitrogen Applied (kg) Over Time for Ontario")

#PEI
ggplot(data=pei, aes(x=REF_DATE, y=Nitrogen.Applied, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Nitrogen Applied (kg)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Nitrogen Applied (kg) Over Time for Prince Edward Island")

#Manitoba
ggplot(data=manitoba, aes(x=REF_DATE, y=Nitrogen.Applied, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Nitrogen Applied (kg)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Nitrogen Applied (kg) Over Time for Manitoba")

#Saskatchewan
ggplot(data=saskatchewan, aes(x=REF_DATE, y=Nitrogen.Applied, color=Type.of.crop))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Nitrogen Applied (kg)")+
  guides(color=guide_legend("Crop Type"))+
  ggtitle("Nitrogen Applied (kg) Over Time for Saskatchewan")

#
# Create Plots for International data
#
#read data
international <- read.csv("./data/Converted/International/canada_total_international_v3.csv")

#Get General Crop Totals for each  province
generalTotals <- data.frame(Period=character(), Province=character(), Crop=character(), Nitrogen.Applied=double())

#Iterate through everything and add to data frame
dfCreated <- FALSE
provinces <- levels(international$Province)
for (province in provinces){
  provincialDF <- international[international$Province == province,]
  crops <- unique(provincialDF$General.Crop)
  for (crop in crops){
    byCropDF <- provincialDF[provincialDF$General.Crop == crop,]
    years <- unique(byCropDF$Period)
    for (year in years){
      yearlyDF <- byCropDF[byCropDF$Period == year,]
      yearlyNtotal = sum(yearlyDF$Nitrogen.Applied, na.rm=TRUE)
      if (dfCreated == FALSE){
        generalTotals <- data.frame(Period=c(year), Province=c(province), Crop=c(crop), Nitrogen.Applied=c(yearlyNtotal), stringsAsFactors = FALSE)
        dfCreated <- TRUE
      } else {
        generalTotals[nrow(generalTotals)+1,] = list(year, province, crop, yearlyNtotal)
      }
    }
  }
}

interprovincial <- read.csv("./data/Converted/Interprovincial/canada_interprovincial_total_v1.csv")
totals <- read.csv("./data/Converted/Total_Area/Canada_Total_v1.csv")

internationalCrops <- unique(generalTotals$Crop)
interprovincialCrops <- unique(str_sub(interprovincial$Product, end=-13))
allCrops <- unique(totals$Type.of.crop)

canolaIntl <- generalTotals[generalTotals$Crop == "Canola (including rapeseed)",]
canolaInpr <- interprovincial[interprovincial$Product == "Canola (including rapeseed) [MPG111A01]",]
canolaTotal <- totals[totals$Type.of.crop == "Canola (rapeseed)",]

provinces <- unique(canolaTotal$GEO)
dfCreated <- FALSE
for (province in provinces){
  provincialCanola <- canolaTotal[canolaTotal$GEO == province,]
  provincialIntl <- canolaIntl[canolaIntl$Province == province,]
  provincialInpr <- canolaInpr[canolaInpr$GEO == province,]
  years <- unique(provincialCanola$REF_DATE)
  for (year in years){
    intlPercent <- 100*(provincialIntl[str_sub(provincialIntl$Period, end=-7) ==year,]$Nitrogen.Applied / provincialCanola[provincialCanola$REF_DATE == year,]$Nitrogen.Applied)
    inprPercent <- 100*(provincialInpr[provincialInpr$REF_DATE == year,]$Nitrogen.Applied / provincialCanola[provincialCanola$REF_DATE == year,]$Nitrogen.Applied)
    
    if (length(intlPercent) == 0){
      intlPercent <- NA
    }
    if (length(inprPercent) == 0){
      inprPercent <- NA 
    }
    
    if (dfCreated == FALSE){
      canolaPercents <- data.frame(Period=c(year), Province=c(province), Intl.Percent=c(intlPercent), Intpvl.Percent=c(inprPercent), stringsAsFactors = FALSE)
      dfCreated <- TRUE
    } else {
      canolaPercents[nrow(canolaPercents)+1,] = list(year, province, intlPercent, inprPercent)
    }
    }
}

#Plot percentage for export 
ggplot(data=canolaPercents[canolaPercents$Period > 1987,], aes(x=Period, y=Intl.Percent, color=Province))+
  geom_line(size=1.5)+
  theme_light()+
  xlab("Year")+
  ylab("Percentage")+
  guides(color=guide_legend("Province"), size=guide_legend("Province"))+
  ggtitle("Percentage Nitrogen Applied for Internationally Exported Canola")
