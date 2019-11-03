plan(multiprocess)

splits <- seq(0.1,0.9, by = 0.05)

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
        , split_data = target(
                initial_split(origin_clean, prop = 0.8, strata = ReducedRegulatedEntityName)
                , transform = map(prop = !!splits)
        )
        , test_data = target(
                testing(split_data)
                , transform = cross(split_data)
        )
        , training_data = target(
                training(split_data)
                , transform = cross(split_data)
        )
        # Making ML object
        , forest_classifier = rand_forest(mode ="classification", trees = 200) 
        # Specifying the learner
        , ranger_classifier = set_engine(forest_classifier, "ranger")
        
        # Fitting the data
        , ranger_fit = target(
                fit(ranger_classifier, ReducedRegulatedEntityName ~ ., data = training_data)
                , transform = cross(training_data)
        )
        
        # Testing data
        , ranger_pred = target(
                predict(ranger_fit, test_data)
                , transform = map(ranger_fit, test_data)
                )
        , ranger_pred_test = target(
                cbind(test_data, ranger_pred)
                , transform = map(test_data, ranger_pred)
        )
        , accuracy_score = target(
                procVerify(ranger_pred_test)
                , transform = map(ranger_pred_test)        
        )       
        , confusion_counts = target(
                funConfusion(ranger_pred_test)
                , transform = map(ranger_pred_test)
        )
        
        , full_score = target(
                c(accuracy_score)
                , transform =  combine(accuracy_score)
        )
        
        , full_score_tibble = tibble(full_score, split.size = !!splits)
        
        , score_variance_plot = ggplot(data = full_score_tibble, aes(x = split.size, y = full_score)) +
                geom_line(group = 1) +
                geom_point()
        # Report statistics
        , num_unique_donees = origin %>% pull(RegulatedEntityName) %>% unique() %>% length()
        
        #, max_expand = 3
)
