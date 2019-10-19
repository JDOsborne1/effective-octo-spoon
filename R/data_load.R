#### Data loading functions ####


# Reading in the donation data --------------------------------------------

donationDataLoad <- function(link = "https://query.data.world/s/ulqkkguwliwj4eqr4qfqyklzsxjnqr") {
        vroom::vroom(link)
}

