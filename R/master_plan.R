#### Master Plan Document ####


# Imports -----------------------------------------------------------------

library(drake)
library(dplyr)

source(here::here("R/data_load.R"))
source(here::here("R/summary_functions.R"))

# Plan Definition ---------------------------------------------------------

plan <- drake_plan(
        origin = donationDataLoad()
        , entity_summary = summariseEntities(origin)
        , volume_of_donations = sum(entity_summary$n)
)





# Plan Execution ----------------------------------------------------------

make(plan)


# Output Saving -----------------------------------------------------------


