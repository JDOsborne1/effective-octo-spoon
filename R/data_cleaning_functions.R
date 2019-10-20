#### Data Cleaning functons ####

# Generic -----------------------------------------------------------------

scrub <- function(a_tibble){
        a_tibble %>% 
                mutate(Value_pounds = procGetNumberFromMoney(Value)) %>% 
                select(-Value)
}



# Processing the currency element -----------------------------------------

procGetNumberFromMoney <- function(a_monetary_value){
        a_monetary_value %>% 
                stringr::str_replace_all(",", "") %>% 
                stringr::str_match( "^£(\\d*)\\.\\d{2}$") %>% 
                {.[,2]} %>% 
                as.numeric()
}
