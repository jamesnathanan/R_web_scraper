#install.packages("rvest")
#install.packages("purrr")
#install.packages("writexl")
#install.packages("dplyr")
#install.packages("openxlsx")
#install.packages("readxl")

library(rvest)
library(purrr)
library(dplyr)
library(writexl)
library(openxlsx)
library(readxl)

# Set the path to your Excel file
excel_file <- "new_ship_500_update.xlsx"

# Read the Excel file
ship_data <- read_excel(excel_file)

# Extract the IMO data into a vector
imo_vector <- ship_data$IMO
mmsi_vector <- ship_data$MMSI
name_vector <- ship_data$name

# Custom function to generate slugs
generate_slug <- function(name) {
  # Convert to lowercase
  slug <- tolower(name)
  
  # Replace spaces with hyphens
  slug <- gsub(" ", "-", slug)
  
  # Remove special characters
  slug <- gsub("[^a-zA-Z0-9-]", "", slug)
  
  return(slug)
}

# Create vector of slugs
slug_vector <- sapply(name_vector, generate_slug)

# Unname it
slug_vector <- unname(slug_vector)

# Construct the search URL
ship_urls <- paste0("https://www.myshiptracking.com/vessels/", slug_vector, "-mmsi-", mmsi_vector, "-imo-", imo_vector)

# Declaer counter to help us track the row number
counter <- 1

scrape_ship_details <- function(ship_url) {
  Sys.sleep(1)  # Add a delay of 1 second before each request
  ship_page <- read_html(ship_url)
  print(paste(as.character(counter)," Scraping ship details for:", as.character(ship_url)))
  
  #name <- ship_page %>% html_nodes(".text-white .mb-0") %>% html_text() %>% trimws()
  latitude <- ship_page %>% html_nodes("#ft-position tr:nth-child(2) td") %>% html_text() %>% trimws()
  longitude <- ship_page %>% html_nodes("#ft-position tr:nth-child(1) td") %>% html_text() %>% trimws()
  navigational_status <- ship_page %>% html_nodes("#ft-position tr:nth-child(3) td") %>% html_text() %>% trimws()
  speed <- ship_page %>% html_nodes("#ft-position tr:nth-child(4) td") %>% html_text() %>% trimws()
  course <- ship_page %>% html_nodes("#ft-position tr:nth-child(5) td") %>% html_text() %>% trimws()
  area <- ship_page %>% html_nodes("#ft-position tr:nth-child(6) td") %>% html_text() %>% trimws()
  
  
  ship_details <- data.frame(
    Ship_Name = name_vector[counter],
    Latitude = latitude,
    Longitude = longitude,
    Navigational_Status = navigational_status,
    Speed = speed,
    Course = course,
    Area = area,
    Timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  )
  
  print(paste("Completed scraping for:", as.character(ship_url)))
  
  # Increment the counter in the global environment
  counter <<- counter + 1
  
  # print ship_details for debugging
  print(ship_details)
  return(ship_details)
}


#scrape_ship_details(my_url)
#output_file <- format(Sys.time(), "%Y-%m-%d %H:%M:%S.xlsx") # "ship_data.xlsx"

while (TRUE) {
  print("Starting scraping process...")
  ship_data <- ship_urls %>% map_df(scrape_ship_details)
  print("Scraping completed. Writing data to file...")
  output_file <- format(Sys.time(), "%Y-%m-%d %H:%M:%S.xlsx") # "ship_data.xlsx"
  write_xlsx(ship_data, output_file)
  print("Data written to file.")
  print(paste("Next scraping cycle will start in", 300, "seconds."))
  Sys.sleep(300) #use seconds to set timer as 900 seconds is 15 minutes
  counter <<- 1
}




