#install.packages("maptools")
#install.packages("ggplot2")
#install.packages("sf")
#install.packages(c("cowplot", "googleway", "ggplot2", "ggrepel", 
 #                  "ggspatial", "libwgeom", "sf", "rnaturalearth", "rnaturalearthdata"))
#install.packages("ggmap")
#install.packages("mapproj")
#install.packages("readxl")
#install.packages("gpclib")
#install.packages("rgeos")
#install.packages('rgeos', type='source')
#install.packages('rgdal', type='source')
#install.packages("magick")
################################
library(magick)
library(rgdal)
library(rgeos)
library(gpclib)
library(readxl)
library(maps)
library(maptools)
library(ggplot2)
library(sf)
library(ggmap)
library(rgdal)
library(mapproj)
gpclibPermit()

getwd()

censustracts <- readOGR("/Users/stephencranney/Desktop/tl_2019_24_cousub copy", "tl_2019_24_cousub")

#Now merge a new variable with district IDs
#####################################################
#Load an excel file
setwd("/Users/stephencranney/Desktop/ACS_17_5YR_S1601 2")
tractdata<- read.csv("ACS_17_5YR_S1601_with_ann.csv")
tractdata = tractdata[-1,]

tractdata$GEOID= tractdata$GEO.id2

# create a data.frame from our spatial object
DDX <- fortify(censustracts, region= "GEOID")
DDX$GEOID= DDX$id
DF <- merge(DDX , tractdata, by = "GEOID")

DF$Span_perc= as.numeric(as.character(DF$HC02_EST_VC06))

##########################
  #General map
  ggplot(data = DF, aes(long, y=lat, group = group,
                        fill = Span_perc)) +
    geom_polygon()  +
    geom_path(color = "white") +
    scale_fill_gradient(name= "Percent Spanish speaking", limits=c(0,10), low= "white", high="red") +
    coord_equal() +
   coord_map(xlim=c(-76.5, -77.5), ylim=c(38.5, 39.5)) +  
    theme_void()  + 
    theme(legend.position = "bottom",
          panel.background = element_rect(fill = NA, colour = "#cccccc")) +
          geom_polygon(data= DF, fill= NA, color= "black") +
          ggtitle("Percent Spanish speaking") +
          theme(plot.title = element_text(hjust = 0.5))
  ggsave("SpanishSpeakingMap.png")
