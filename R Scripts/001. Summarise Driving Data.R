## Script to extract and calculate means of each point within the domain
## using already extracted data for the West Greenland Implementation

rm(list = ls()) # reset
library(MiMeMo.tools) # Most of what I need
library(furrr)

tic()
plan(multisession,workers = (availableCores() - 2)) # leave me with a few cores

NE_chem <- list.files("../../24-25/West_Greenland_Implementation/Objects/NEMO RAW/NE_Days", full.names = TRUE) %>% 
  future_map(.,.f = readRDS) %>%  #read in files - each element is its own month
  bind_rows() %>% 
  group_by(longitude,latitude,Year,Month,Forcing,SSP) %>% 
  summarise(NO3 = mean(NO3,na.rm = TRUE),
            NH4 = mean(NH4,na.rm = TRUE),
            Diatoms = mean(Diatoms,na.rm = TRUE),
            Other_phytoplankton = mean(Other_phytoplankton,na.rm = TRUE),
            Detritus = mean(Detritus,na.rm = TRUE),
            Bathymetry = mean(Bathymetry,na.rm = TRUE)) %>%  #sorts slab_layer calculation
  ungroup() %>% 
  group_by(Year,Month) %>% 
  st_as_sf(coords = c("longitude","latitude"),crs = 4326) %>% 
  st_transform(crs = 3035)
saveRDS(NE_chem,"./Objects/Driving/NE_chem.RDS")

NE_phys <- list.files("../../24-25/West_Greenland_Implementation/Objects/NEMO RAW/NE_Months", full.names = TRUE) %>% 
  future_map(.,.f = readRDS) %>%  #read in files - each element is its own month
  bind_rows() %>% 
  group_by(longitude,latitude,Year,Month,Forcing,SSP) %>% 
  summarise(Temperature = mean(Temperature,na.rm = TRUE),
            Bathymetry = mean(Bathymetry,na.rm = TRUE)) %>%  #sorts slab_layer calculation
  ungroup() %>% 
  group_by(Year,Month) %>% 
  st_as_sf(coords = c("longitude","latitude"),crs = 4326) %>% 
  st_transform(crs = 3035)
saveRDS(NE_phys,"./Objects/Driving/NE_phys.RDS")

## Code to summarise Ice variables here

toc()