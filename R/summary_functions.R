#### Summary Functions ####


# Basic counts ------------------------------------------------------------

summariseEntities <- function(a_tibble){
        a_tibble %>% 
                count(ReducedRegulatedEntityName) %>% 
                arrange(desc(n))
}



# Automated counts --------------------------------------------------------


uniquenessCheck <- function(x, uniqueness_threshold = 0.01) length(unique(x))/length(x) < uniqueness_threshold
nestedCounts <-  function(x) count(enframe(x), value)
sortAndFactorise <- function(a_tibble) {
        a_tibble %>% 
                arrange(desc(n)) %>% 
                mutate(value = factor(value, levels = unique(value)))
}


summariseCategoricals <- function(a_tibble){
        a_tibble %>% 
                select_if(uniquenessCheck) %>% 
                purrr::map(nestedCounts) %>% 
                enframe(name = "Variable", value = "Counts") %>% 
                mutate(Counts = purrr::map(Counts, sortAndFactorise))
}

