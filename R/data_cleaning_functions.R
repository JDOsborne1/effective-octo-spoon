#### Data Cleaning functons ####

# Generic -----------------------------------------------------------------

scrub <- function(a_tibble){
        a_tibble %>% 
                procGetNumberFromMoney() %>% 
                procReduceDoneeNames() %>% 
                procDropMostlyMissing() %>% 
                procReplaceMissing()
}



# Processing the currency element -----------------------------------------

funGetNumberFromMoney <- function(a_monetary_value){
        a_monetary_value %>% 
                stringr::str_replace_all(",", "") %>% 
                stringr::str_match( "^£(\\d*)\\.\\d{2}$") %>% 
                {.[,2]} %>% 
                as.numeric()
}

procGetNumberFromMoney <- function(a_tibble){
        a_tibble %>% 
                mutate(Value_pounds = funGetNumberFromMoney(Value)) %>% 
                select(-Value)
}


# Processing the multiplicity of donees -----------------------------------


funReduceDoneeNames <- function(a_vector_of_donor_names){
        forcats::fct_lump_min(a_vector_of_donor_names, min = 140)
}

procReduceDoneeNames <- function(a_tibble){
        a_tibble %>% 
                mutate(ReducedRegulatedEntityName = funReduceDoneeNames(RegulatedEntityName)) %>% 
                select(-RegulatedEntityName)
}


# Processing the missing data ---------------------------------------------

procDropMostlyMissing <- function(a_tibble, missing_threshold = 0.6){
        a_tibble %>% 
                select_if(function(x) sum(!is.na(x)) > (length(x) * 0.6))
        
}

procReplaceMissing <- function(a_tibble, character_missing = "Unknown", logical_missing = FALSE, numeric_missing = 0) {
        a_tibble %>% 
                mutate_if(is.numeric, replace_na, numeric_missing) %>% 
                mutate_if(is.character, replace_na, character_missing) %>% 
                mutate_if(is.logical, replace_na, logical_missing)  
}
