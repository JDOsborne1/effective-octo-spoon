#### Master Plan Document ####


# Imports -----------------------------------------------------------------


source(here::here("R/import.R"))
source(here::here("R/data_load.R"))
source(here::here("R/data_cleaning_functions.R"), encoding = "UTF-8")
source(here::here("R/summary_functions.R"))
source(here::here("R/ml_functions.R"))


# Plan Definition ---------------------------------------------------------

source(here::here("R/plan.R"))
source(here::here("R/split_comparison.R"))
source(here::here("R/clustering_plan.R"))

full_plan <- drake::bind_plans(
        task_plan
        #, split_comparison_plan
        , clustering_plan
        )
# Looking at configuration ------------------------------------------------

plan_config <- drake_config(full_plan)
 vis_drake_graph(plan_config)

# Plan Execution ----------------------------------------------------------

make(full_plan, parallelism = "future", jobs = 4)


# Output Saving -----------------------------------------------------------


