#####################################################
##Load/install necessary CRAN packages and set options
packages <- c("tidyverse", "tidygeocoder", 
              "tigris", "sf", "crsuggest", "mapview")

##Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

##Attach Packages
invisible(lapply(packages, library, character.only = TRUE))

options(tigris_use_cache = TRUE)

#######################################
##Section 0 - import address data from REDCap or other source
##you will want your input data to eventually be in the same format as the
##provided example data 

df <- read.csv("ADI_Example_Input_Data.csv")

#######################################
##Section 1 - geocode needed addresses

# only keep records with a street address
address_list <- df |> 
  filter(!is.na(street))

##create one field with all address information
address_list$fullAdd <- paste(as.character(address_list$street),
                              as.character(address_list$city),
                              as.character(address_list$state),
                              as.character(address_list$zipcode))


## GeoCode addresses - order of methods to try from my experience is arcgis, census, osm 
##REF: https://jessecambon.github.io/tidygeocoder/reference/geo.html
geolist <- address_list |> 
  geocode(address = fullAdd, 
          lat = latitude, 
          long = longitude, 
          method = 'arcgis', 
          mode='single', 
          limit=1)

##check for uncoded addresses
uncoded <- geo1 |>
  filter(is.na(latitude)) 


########################################################################################
## Section 2 - spatial join address coordinates with ADI census block groups
##Note: From my experience, we can only really do 1 state at a time because of the 
##different projections needed for each state. Depending on accuracy needs, may be acceptable to
##use lower resolution datasets for all states at the same time. 
## Code below only focuses on 1 state at a time (Indiana) with the detailed block data.

##REF: https://walker-data.com/census-r/spatial-analysis-with-us-census-data.html (Section 7.1.1)
##REF: https://rdrr.io/cran/crsuggest/src/R/suggest_crs.R

in_bg <- block_groups("IN")

## use below function once to get suggestion of most appropriate projection 
in_crs <- suggest_crs(in_bg)

in_bg_proj <- st_transform(in_bg, crs=6461) |> 
  mutate(GEOID=as.numeric(GEOID))

##Indiana Addresses
geolist_sf1 <- geolist |> 
  st_as_sf(coords = c("longitude", "latitude"),
           crs = 4326) |> 
  st_transform(6461) |> 
  select(id, state, geometry, fullAdd)

## Note: if you'd like to quickly inspect the geocoding/projection, one option is to use mapview
mapview(
  geolist_sf1
) +
  mapview(
    in_bg_proj,
    col.regions = "darkgreen",
    legend = FALSE
  )

##spatially join our coordinates into block groups
geo_joined <- st_join(
  geolist_sf1,
  in_bg_proj
) |> 
  st_drop_geometry()

##############################################
##Section 3 : join with Neighborhood Atlas Data
##publicly available at https://www.neighborhoodatlas.medicine.wisc.edu/
##using most recent (2022) version

adi <- read.csv("US_2022_ADI_Census_Block_Group_v4_0_1.csv") |> 
  rename(GEOID=FIPS)

#join joined data with WI ADI now that we have our address list in block groups
adi_joined <- geo_joined |> 
  left_join(adi, by=c("GEOID"))


##############################################
##Section 4 : Push data to REDCap
##We have a customized REDCap API token process at IU that won;t be applicable to other users, but we strongly 
##suggest using the redcapAPI package to import/export data from REDCap.


