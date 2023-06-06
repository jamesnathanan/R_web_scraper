#install.packages("rvest")
#install.packages("purrr")
#install.packages("writexl")

library(rvest)
library(purrr)
library(dplyr)
library(writexl)

ship_urls <- c("https://www.myshiptracking.com/vessels/ugle-duckling-mmsi-338158987-imo-",
               "https://www.myshiptracking.com/vessels/alice-c-mmsi-367309390-imo-7047708",
               "https://www.myshiptracking.com/vessels/joy-mmsi-271049712-imo-",
               "https://www.myshiptracking.com/vessels/nsu-katsura-mmsi-431775000-imo-9379260",
               "https://www.myshiptracking.com/vessels/knurrhahn-mmsi-211399890-imo-0",
               "https://www.myshiptracking.com/vessels/c-force-mmsi-538006220-imo-9710543",
               "https://www.myshiptracking.com/vessels/bremanger-mmsi-244102434-imo-0",
               "https://www.myshiptracking.com/vessels/winston-01-mmsi-525201830-imo-9570319",
               "https://www.myshiptracking.com/vessels/eendracht-mmsi-244870557-imo-",
               "https://www.myshiptracking.com/vessels/christina-mmsi-241472000-imo-0",
               "https://www.myshiptracking.com/vessels/hafnia-guangzhou-mmsi-248962000-imo-9856622")

scrape_ship_details <- function(ship_url) {
  ship_page <- read_html(ship_url)
  
  name <- ship_page %>% html_nodes(".text-white .mb-0") %>% html_text() %>% trimws()
  latitude <- ship_page %>% html_nodes("#ft-position tr:nth-child(2) td") %>% html_text() %>% trimws()
  longitude <- ship_page %>% html_nodes("#ft-position tr:nth-child(1) td") %>% html_text() %>% trimws()
  navigational_status <- ship_page %>% html_nodes("#ft-position tr:nth-child(3) td") %>% html_text() %>% trimws()
  speed <- ship_page %>% html_nodes("#ft-position tr:nth-child(4) td") %>% html_text() %>% trimws()
  course <- ship_page %>% html_nodes("#ft-position tr:nth-child(5) td") %>% html_text() %>% trimws()
  area <- ship_page %>% html_nodes("#ft-position tr:nth-child(6) td") %>% html_text() %>% trimws()
  
  #print(latitude)
  #print(longitude)
  #print(navigational_status)
  #print(speed)
  #print(course)
  #print(area)
  
  ship_details <- data.frame(
    Ship_Name = name,
    Latitude = latitude,
    Longitude = longitude,
    Navigational_Status = navigational_status,
    Speed = speed,
    Course = course,
    Area = area,
    Timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  )
  
  return(ship_details)
}

#my_url <- "https://www.myshiptracking.com/vessels/marusumi-maru-no11-mmsi-431501619-imo-8954532"
#my_url <- "https://www.myshiptracking.com/vessels/antaria-mmsi-244820889-imo-"


#scrape_ship_details(my_url)
#output_file <- format(Sys.time(), "%Y-%m-%d %H:%M:%S.xlsx") # "ship_data.xlsx"

while (TRUE) {
  ship_data <- ship_urls %>% map_df(scrape_ship_details)
  output_file <- format(Sys.time(), "%Y-%m-%d %H:%M:%S.xlsx") # "ship_data.xlsx"
  write_xlsx(ship_data, output_file)
  Sys.sleep(10) #use seconds to set timer as 900 seconds is 15 minutes
}




