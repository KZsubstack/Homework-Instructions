## load packages ----------------------------------------------------------------
#
library(tidyverse)
library(rvest)
library(here) 
#
## function: scrape_pac ---------------------------------------------------------
#
scrape_pac <- function(url) {
#  
#  # read the page
  page <- read_html(url)
#  
#  # exract the table

  pac <-  page %>%
#    # select node .DataTable (identified using the SelectorGadget)
    html_node(".DataTable-Partial") %>%
#    # parse table at node td into a data frame
#    #   table has a head and empty cells should be filled with NAs
    html_table(header = TRUE, fill = TRUE) %>%
#    # convert to a tibble
    as_tibble()
#  
#  # rename variables
  pac <- pac %>%
#    # rename columns
    rename(
      name = 1 ,
      country_parent = 2,
      total = 3,
      dems = 4,
      repubs = 5
    )
#  
#  # fix name
  pac <- pac %>%
#    # remove extraneous whitespaces from the name column
    mutate(name = str_squish(name))
#  
#  # add year
  pac <- pac %>%
#    # extract last 4 characters of the URL and save as year
    mutate(year = str_extract(url, "\\d{4}"))
#  
#  # return data frame

  pac
#  
}
#
## test function ----------------------------------------------------------------
#
url_2024 <- "hw-06/data/pac-2024.html"
pac_2024 <- scrape_pac(url_2024)

url_2020 <- "hw-06/data/pac-2020.html"
pac_2020 <- scrape_pac(url_2020)

url_2000 <- "hw-06/data/pac-2000.html"
pac_2000 <- scrape_pac(url_2000)
#
## list of urls -----------------------------------------------------------------
#
## first part of url
root <- "hw-06/data/pac-"
year <- seq(from = 2000, to = 2024, by = 2)
urls <- paste0(root, year, ".html")
#
## second part of url (election years as a sequence)
year <- seq(from = 2000, to = 2024, by = 2)
#
## construct urls by pasting first and second parts together
urls <- paste0(root, year, ".html")
#
## map the scrape_pac function over list of urls --------------------------------
#
pac_all <- map_dfr(urls, scrape_pac)
#
## write data -------------------------------------------------------------------
#
write_csv(pac_all, file = "hw-06/data/pac-all.csv")

