#### Plotting Functions ####



# Basic Frequency Plots ---------------------------------------------------

makeFreqGraph <- function(a_counts_tibble, count_name){
        a_counts_tibble %>% 
                ggplot(aes(x = value, y = n)) +
                geom_col() +
                labs(
                        title = count_name
                ) +
                coord_flip()
}
