library(tidyverse)
library(leaflet)
library(exifr)
library(mapview)
library(leafpop)

files <- list.files(recursive=TRUE, pattern=c("*.JPG|*.jpg"), full.names=TRUE)
exifinfo <- read_exif(files)

#tibble(Foto=files)%>%openxlsx::write.xlsx("Tabelle.xlsx")

Tabelle<-openxlsx::read.xlsx("Tabelle.xlsx")

exifinfo<-exifinfo%>%left_join(Tabelle, by="SourceFile")

exifinfo<-exifinfo%>%mutate(Farbe=case_when(Art=="Plastikmüll"~"orange",
                                            Art=="Restmüll"~"black",
                                            Art=="Metall"~"red",
                                            Art=="Glas"~"blue",
                                            TRUE~"green"))

leaflet() %>%
  addTiles %>%
  addCircleMarkers(
    data = exifinfo,
    lng =  ~ GPSLongitude,
    lat = ~ GPSLatitude, 
    popup = popupImage(exifinfo$SourceFile,src = c("local"),width=600),
    color=~Farbe,
    opacity=0.5)%>%
  addLegend(colors = c("orange", "black", "red", "blue"), labels = c("Plastikmüll","Restmüll","Metall","Glas"))
