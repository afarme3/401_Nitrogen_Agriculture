#
#Import Libraries
library(ggplot2)

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


 