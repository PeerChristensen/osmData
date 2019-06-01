# shapefile

library(sf)
library(maps)
library("rnaturalearth")
library("rnaturalearthdata")
library(ggmap)
library(tidyverse)

world <- ne_countries(scale = "medium", returnclass = "sf")

dk <- read_sf("points.shp")
dk <- st_read("points.shp")

#dk <- dk %>% 
#  filter(highway == "bus_stop") 

dk <- dk %>% 
  filter(str_detect(other_tags,"stop_position"))

# plot

#####W#############################################################
# 1

world1 <- sf::st_as_sf(maps::map('world', plot = FALSE, fill = TRUE))

ggplot(data = world1) +
  geom_sf() +
  geom_sf(data = dk) +
  coord_sf(ylim = c(54.7, 57.823), xlim = c(7.843, 15.278), expand = T)

#####W#############################################################
# 2

ggplot() + 
  borders(regions = "Denmark", colour = "gray50", fill = "gray50") + 
  geom_sf(data=dk)

###################################################################
# 3 not working

dk_box <- c(left = 7.8, bottom = 54.7, right = 15.25, top = 57.8)

dk_hires <- get_stamenmap(dk_box, zoom = 8, maptype = "toner-lite")

attr(dk_hires, "bb")$ll.lat <- st_bbox(dk)["ymin"]
attr(dk_hires, "bb")$ll.lon <- st_bbox(dk)["xmin"]
attr(dk_hires, "bb")$ur.lat <- st_bbox(dk)["ymax"]
attr(dk_hires, "bb")$ur.lon <- st_bbox(dk)["xmax"]

ggmap::ggmap(dk_hires) +
  #coord_sf(crs = st_crs(3857)) + # force it to be 3857
  geom_sf(data = dk, inherit.aes = F)

###################################################################
# 4

test_map_dk <- get_map(location = unname(st_bbox(dk)), source = "stamen")

ggmap(test_map_dk) + 
  coord_sf(crs = st_crs(3857)) + # force the ggplot2 map to be in 3857
  geom_sf(data = dk, inherit.aes = FALSE)
###################################################################
# 5

dk2 <- st_transform(dk, 3857)

# Define a function to fix the bbox to be in EPSG:3857
ggmap_bbox <- function(map) {
  if (!inherits(map, "ggmap")) stop("map must be a ggmap object")
  # Extract the bounding box (in lat/lon) from the ggmap to a numeric vector, 
  # and set the names to what sf::st_bbox expects:
  map_bbox <- setNames(unlist(attr(map, "bb")), 
                       c("ymin", "xmin", "ymax", "xmax"))
  
  # Coonvert the bbox to an sf polygon, transform it to 3857, 
  # and convert back to a bbox (convoluted, but it works)
  bbox_3857 <- st_bbox(st_transform(st_as_sfc(st_bbox(map_bbox, crs = 4326)), 3857))
  
  # Overwrite the bbox of the ggmap object with the transformed coordinates 
  attr(map, "bb")$ll.lat <- bbox_3857["ymin"]
  attr(map, "bb")$ll.lon <- bbox_3857["xmin"]
  attr(map, "bb")$ur.lat <- bbox_3857["ymax"]
  attr(map, "bb")$ur.lon <- bbox_3857["xmax"]
  map
}

test_map_dk <- get_map(location = unname(st_bbox(dk)), source = "stamen")

test_map_dk <- ggmap_bbox(test_map_dk)

ggmap(test_map_dk) + 
  coord_sf(crs = st_crs(3857)) + # force the ggplot2 map to be in 3857
  geom_sf(data = dk2, inherit.aes = FALSE)

###################################################################

