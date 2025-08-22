## Run batch of R scripts
rm(list = ls()) #reset

library(MiMeMo.tools)

#### Batch process scripts ####
len <- length(list.files("./R Scripts/",full.names = T))
scripts <- list.files("./R Scripts/",full.names = T)[2:len] %>% # all except first (this one)
  map(MiMeMo.tools::execute) # Run the scripts