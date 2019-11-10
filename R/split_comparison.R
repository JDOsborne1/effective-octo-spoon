split_comparison_plan <- drake_plan(
        # Splitting the data for modelling purposes
        split_data = target(
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
)