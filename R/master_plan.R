#### Master Plan Document ####


# Imports -----------------------------------------------------------------



source(here::here("R/import.R"))
source(here::here("R/data_load.R"))
source(here::here("R/summary_functions.R"))

# Plan Definition ---------------------------------------------------------

plan <- drake_plan(
        
        # loading the origin data
        origin = donationDataLoad("https://query.data.world/s/ulqkkguwliwj4eqr4qfqyklzsxjnqr")
        
        # Making some basic Summaries for use in the readme
        , entity_summary = summariseEntities(origin)
        , volume_of_donations = sum(entity_summary$n)
        
        , category_summary = summariseCategoricals(origin)
)


# Looking at configuration ------------------------------------------------

plan_config <- drake_config(plan)
 vis_drake_graph(plan_config)

# Plan Execution ----------------------------------------------------------

make(plan)


# Output Saving -----------------------------------------------------------


