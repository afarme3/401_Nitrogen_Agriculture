## 401_Nitrogen_Agriculture
#### ENVR 401, Fall 2021
Adam Farmer, Jennah Landgraf, Megan L'Heureux, Meaghan Morter, Viva Noronha, Anouk Rohde, and Clare Shuley.

Prof. Fiona Soper, Advisor

Sibeal McCourt, Client

##### What is included
This project involved the production of a data product reflecting the estimated nitrogen applied for different crops and provinces in Canada. 
There is data for the Total Nitrogen Applied (for all agricultural production), Internationally Traded Crops, and Interprovincially Traded Crops. 

This repository is structured as follows:

###### *./data*
This folder contains all the data used over the course of the project. 

###### *./data/Conversions/*
This folder contains the tables used as conversion factors in the project. 

###### *./data/Converted/*
This folder contains the output data, after having undergone conversions. It is split into International, Interprovincial, and Total_Area for each of the three data types.

###### *./data/Raw/*
This folder contains the raw data as obtained from Statistics Canada. It is also split into International, Interprovincial, and 'fertilizer' (Total Seeded Area).

###### *./gis/*
This folder contains the assets used in the creation of our animated maps. Here, it onl contains a QGIS project. 

###### *ConvertCropData.R*
This script is where all of the conversions were performed. For each conversion step applied to each kind of data, there is a function which performs that specific conversion. This script takes the raw data, applies the conversion factors, and then writes the resulting data.

###### *ConvertForGIS.R*
This script takes some of the converted data and merges it with the spatial polygons of each province to produce shapefiles, containing a time-series of the data bound to the provinces. These shapefiles are output to the ./gis/ folder. 

###### *FertilizerPlots.R*
This script uses ggplot2 to create graphs of various datasets obtained. 

