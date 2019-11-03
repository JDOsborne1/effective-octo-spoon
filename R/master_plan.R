#### Master Plan Document ####


# Imports -----------------------------------------------------------------


source(here::here("R/import.R"))
source(here::here("R/data_load.R"))
source(here::here("R/data_cleaning_functions.R"), encoding = "UTF-8")
source(here::here("R/summary_functions.R"))
source(here::here("R/ml_functions.R"))


# Plan Definition ---------------------------------------------------------

source(here::here("R/plan.R"))


# Looking at configuration ------------------------------------------------

plan_config <- drake_config(task_plan)
 vis_drake_graph(plan_config)

# Plan Execution ----------------------------------------------------------

make(task_plan, parallelism = "future", jobs = 4)


# Output Saving -----------------------------------------------------------


