#
#Import Libraries
library(ggplot2)

#Import Data for Fertilizer Seeded Area
quebec <- read.csv("./data/fertilizer/QUEBEC.csv")
alberta <- read.csv("./data/fertilizer/ALBERTA.csv")
bc <- read.csv("./data/fertilizer/BC.csv")
newBrunswick <- read.csv("./data/fertilizer/NEW BRUNSWICK.csv")
NaL <- read.csv("./data/fertilizer/NEWFOUNDLAND AND LABRADOR.csv")
novaScotia <- read.csv("./data/fertilizer/NOVA SCOTIA.csv")
ontario <- read.csv("./data/fertilizer/ONTARIO.csv")
pei <- read.csv("./data/fertilizer/PRINCE EDWARD ISLAND.csv")
manitoba <- read.csv("./data/fertilizer/MANITOBA.csv")
saskatchewan <- read.csv("./data/fertilizer/SASKATCHEWAN.csv")

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
