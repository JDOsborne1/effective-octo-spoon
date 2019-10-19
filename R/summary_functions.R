#### Summary Functions ####


# Basic counts ------------------------------------------------------------

summariseEntities <- function(a_tibble){
        a_tibble %>% 
                count(RegulatedEntityName) %>% 
                arrange(desc(n))
}



# Automated counts --------------------------------------------------------


uniquenessCheck <- function(x, uniqueness_threshold = 0.01) length(unique(x))/length(x) < uniqueness_threshold
nestedCounts <-  function(x) count(enframe(x), value)


summariseCategoricals <- function(a_tibble){
        a_tibble %>% 
                select_if(uniquenessCheck) %>% 
                map(nestedCounts) %>% 
                enframe(name = "Variable", value = "Counts")
}


