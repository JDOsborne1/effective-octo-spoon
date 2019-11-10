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
        
        
        # Report statistics
        , num_unique_donees = origin %>% pull(RegulatedEntityName) %>% unique() %>% length()
        
        #, max_expand = 3
)
