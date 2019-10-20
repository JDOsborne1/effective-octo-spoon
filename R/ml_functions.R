#### ML functions ####


# Accuracy testing --------------------------------------------------------

funCorrectness <- function(a_tibble){
        a_tibble %>% 
                rename(Known = ReducedRegulatedEntityName, Predicted  = .pred_class) %>% 
                group_by(Known) %>% 
                summarise(Correct = sum(Known == Predicted), Incorrect = sum(Known != Predicted))
}

funPropCorrect <- function(a_tibble){
        a_tibble  %>% 
                gather(key = "Prediction", value = "Volume", -Known) %>% 
                group_by(Known) %>% 
                mutate(prop.correct = Volume/sum(Volume)) %>% 
                filter(Prediction == "Correct") %>% 
                select(-Prediction)
}

funGetWeightedAvgCorrectness <- function(a_tibble){
        a_tibble %>% 
                with(
                        weighted.mean(
                                prop.correct
                                , Volume
                        )
                )
}


funConfusion <- function(a_tibble){
        a_tibble %>% 
                
                rename(Known = ReducedRegulatedEntityName, Predicted  = .pred_class) %>% 
                count(Known, Predicted)
}

procVerify <- function(a_tibble){
        a_tibble %>% 
                funCorrectness() %>% 
                funPropCorrect() %>% 
                funGetWeightedAvgCorrectness()
}
