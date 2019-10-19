#### Summary Functions ####


# Baisc counts ------------------------------------------------------------

summariseEntities <- function(a_tibble){
        a_tibble %>% 
                count(RegulatedEntityName) %>% 
                arrange(desc(n))
}
