library(tidyverse)
library(terra)
library(tidyterra)
library(sf)
theme_set(theme_bw())

glob_temp <- terra::rast("data_notes/global-temperature.tif")

terra::plot(glob_temp)

desert_box <- terra::ext(c(-125, -100, 25, 40))

desert_temp <- terra::crop(glob_temp, desert_box)

terra::plot(desert_temp)

desert_temp_f <- desert_temp * 9/5 + 32

terra::plot(desert_temp_f)

desert_temp_proj <- desert_temp |> 
  terra::project(y = "EPSG:5070")

terra::plot(desert_temp_proj)

ggplot() +
  geom_spatraster(data = desert_temp_proj) +
  scale_fill_gradient2(low = "cornflowerblue", high = "red", na.value = "transparent")

sw_cities_csv <- read_csv("data_notes/sw_cities.csv")

sw_cities <- sf::st_as_sf(sw_cities_csv, coords = c("lon", "lat"), crs = "EPSG:4326")

ggplot() +
  geom_spatraster(data = desert_temp_proj) +
  geom_sf(data = sw_cities) +
  geom_sf_text(data = sw_cities, aes(label = city), nudge_x = 100000, nudge_y = -70000) +
  scale_fill_gradient2(low = "cornflowerblue", high = "red", na.value = "transparent")

glob_prec <- terra::rast("data_notes/global-precipitation.tif")

terra::plot(glob_prec)

desert_box <- terra::ext(c(-125, -100, 25, 40))

desert_prec <- terra::crop(glob_prec, desert_box)

terra::plot(desert_prec)

desert_prec_proj <- desert_prec |> 
  terra::project(y = "EPSG:5070")

terra::plot(desert_prec_proj)

desert_prec_limited <- desert_prec_proj < 250
desert_prec_limited[!desert_prec_limited] <- NA
desert_limited_polygon <- terra::as.polygons(desert_prec_limited)

terra::plot(desert_prec_limited)

ggplot() +
  geom_spatraster(data = desert_temp_proj) +
  geom_spatvector(data = desert_limited_polygon, fill = "transparent", color = "black", linewidth = 0.5) +
  geom_sf(data = sw_cities) +
  geom_sf_text(data = sw_cities, aes(label = city), nudge_x = 100000, nudge_y = -70000) +
  scale_fill_gradient2(low = "cornflowerblue", high = "red", na.value = "transparent")


