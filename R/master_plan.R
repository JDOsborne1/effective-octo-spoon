#### Master Plan Document ####


# Imports -----------------------------------------------------------------


source(here::here("R/import.R"))
source(here::here("R/data_load.R"))
source(here::here("R/data_cleaning_functions.R"), encoding = "UTF-8")
source(here::here("R/summary_functions.R"))
source(here::here("R/ml_functions.R"))


# Plan Definition ---------------------------------------------------------

plan(multiprocess)

task_plan <- drake_plan(
        
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
        
        
        # Putting in some inspection plots from inspectdf
        , type_inspection_plot = inspect_types(origin_clean) %>% show_plot()
        , missing_inspection_plot = inspect_na(origin_clean) %>% show_plot()
        
        # Splitting the data for modelling purposes
        , split_data = initial_split(origin_clean, strata = ReducedRegulatedEntityName)
        , test_data = testing(split_data)
        , training_data = training(split_data)
        
        # Making ML object
        , forest_classifier = rand_forest(mode ="classification", trees = 2000) 
        # Specifying the learner
        , ranger_classifier = set_engine(forest_classifier, "ranger")
        
        # Fitting the data
        , ranger_fit = fit(ranger_classifier, ReducedRegulatedEntityName ~ ., data = training_data)
        
        # Testing data
        , ranger_pred = predict(ranger_fit, test_data)
        , ranger_pred_test = cbind(test_data, ranger_pred)
        , accuracy_score = procVerify(ranger_pred_test)
        , confusion_counts = funConfusion(ranger_pred_test)
        
        
        # Report statistics
        , num_unique_donees = origin %>% pull(RegulatedEntityName) %>% unique() %>% length()
        )


# Looking at configuration ------------------------------------------------

plan_config <- drake_config(task_plan)
 vis_drake_graph(plan_config)

# Plan Execution ----------------------------------------------------------

make(task_plan, parallelism = "future", jobs = 4)


# Output Saving -----------------------------------------------------------


