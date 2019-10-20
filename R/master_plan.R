#### Master Plan Document ####


# Imports -----------------------------------------------------------------


source(here::here("R/import.R"))
source(here::here("R/data_load.R"))
source(here::here("R/data_cleaning_functions.R"), encoding = "UTF-8")
source(here::here("R/summary_functions.R"))


# Plan Definition ---------------------------------------------------------

plan <- drake_plan(
        
        # loading the origin data
        origin = donationDataLoad(
                "https://query.data.world/s/ulqkkguwliwj4eqr4qfqyklzsxjnqr"
                )
        
        # Cleaning the origin data
        , origin_clean = scrub(origin)
        
        # Making some basic Summaries for use in the readme
        , entity_summary = summariseEntities(origin_clean)
        , volume_of_donations = sum(entity_summary$n)
        
        , category_summary = summariseCategoricals(origin_clean)
)


# Looking at configuration ------------------------------------------------

plan_config <- drake_config(plan)
 vis_drake_graph(plan_config)

# Plan Execution ----------------------------------------------------------

make(plan)


# Output Saving -----------------------------------------------------------


