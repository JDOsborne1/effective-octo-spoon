#### ML functions ####


# Accuracy testing --------------------------------------------------------

funConfusion <- function(a_tibble){
        a_tibble %>% 
                count(Known = ReducedRegulatedEntityName, Predicted  = .pred_class)
}


funConfusion <- function(a_tibble){
        a_tibble %>% 
                count(Known = ReducedRegulatedEntityName, Predicted  = .pred_class)
}

procVerify <- function(a_tibble){
        "Empty"
}
