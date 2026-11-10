library(tidyverse)
library(sf)
theme_set(theme_bw())

norway_shp <- sf::st_read("data_notes/norway_map.shp")

class(norway_shp)
str(norway_shp)

st_crs(norway_shp)
# WGS84

sweden_shp <- sf::st_read("data_notes/sweden_map.shp")

class(sweden_shp)
str(sweden_shp)

st_crs(sweden_shp)
# SWEREF99 TM 
# this is projected coordinate system

norway_shp |> 
  ggplot() +
  geom_sf()

sweden_shp |> 
  ggplot() +
  geom_sf()
# this one has curved latitude lines

# i think the sweden one is better

norway_better <- norway_shp |> 
  st_transform(crs = st_crs(sweden_shp))

ggplot() +
  geom_sf(data = sweden_shp) +
  geom_sf(data = norway_better)

norway_sweden <- norway_better |> 
  bind_rows(sweden_shp)
  
st_write(norway_sweden, "data_notes/combined_norway_sweden.shp")

