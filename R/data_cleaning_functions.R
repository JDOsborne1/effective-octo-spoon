#### Data Cleaning functons ####

# Generic -----------------------------------------------------------------

scrub <- function(a_tibble){
        a_tibble %>% 
                mutate(Value_pounds = procGetNumberFromMoney(Value)) %>% 
                select(-Value) %>% 
                mutate(ReducedRegulatedEntityName = procReduceDoneeNames(RegulatedEntityName)) %>% 
                select(-RegulatedEntityName)
}



# Processing the currency element -----------------------------------------

procGetNumberFromMoney <- function(a_monetary_value){
        a_monetary_value %>% 
                stringr::str_replace_all(",", "") %>% 
                stringr::str_match( "^£(\\d*)\\.\\d{2}$") %>% 
                {.[,2]} %>% 
                as.numeric()
}

procReduceDoneeNames <- function(a_vector_of_donor_names){
        forcats::fct_lump_min(a_vector_of_donor_names, min = 140)
}