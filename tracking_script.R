# Load the required packages
library(rvest)
library(purrr)
library(dplyr)
library(writexl)
library(openxlsx)
library(readxl)

# record start timestamp
start_timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

# check if it is new file
new_file <- TRUE

# Set the path to your Excel file
#excel_file <- "new_ship_500_update_test.xlsx"
excel_file <- "new_ship_500_update_test.xlsx"

# Read the existing data from the Excel file
ship_data <- read_excel(excel_file)



# Extract the IMO data into a vector
imo_vector <- ship_data$IMO
mmsi_vector <- ship_data$MMSI
name_vector <- ship_data$name

# Slicing vectors for debugginh
imo_vector <- imo_vector[1:30]
mmsi_vector <- mmsi_vector[1:30]
name_vector <- name_vector[1:30]

print(imo_vector)
print(mmsi_vector)
print(name_vector)
print(data.frame(name_vector, imo_vector, mmsi_vector))

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

# Declare counter to help us track the row number
counter <- 1

# Modify the scrape_ship_details() function
scrape_ship_details <- function(ship_url) {
  Sys.sleep(1)  # Add a delay of 1 second before each request
  print(paste(as.character(counter), "Scraping ship details for:", as.character(ship_url)))
  
  ship_page <- tryCatch({
    read_html(ship_url)
  }, error = function(e) {
    message(paste("Error: Unable to fetch data for", as.character(ship_url)))
    return(NULL)
  })
  
  if (is.null(ship_page)) {
    # Return a data frame with NA values
    ship_details <- data.frame(
      Ship_Name = name_vector[counter],
      IMO = imo_vector[counter],
      Navigational_Status = NA,
      Speed = NA,
      Course = NA,
      Area = NA,
      Timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
    )
  } else {
    latitude <- ship_page %>% html_nodes("#ft-position tr:nth-child(2) td") %>% html_text() %>% trimws()
    longitude <- ship_page %>% html_nodes("#ft-position tr:nth-child(1) td") %>% html_text() %>% trimws()
    navigational_status <- ship_page %>% html_nodes("#ft-position tr:nth-child(3) td") %>% html_text() %>% trimws()
    speed <- ship_page %>% html_nodes("#ft-position tr:nth-child(4) td") %>% html_text() %>% trimws()
    course <- ship_page %>% html_nodes("#ft-position tr:nth-child(5) td") %>% html_text() %>% trimws()
    area <- ship_page %>% html_nodes("#ft-position tr:nth-child(6) td") %>% html_text() %>% trimws()
    
    # Check if the ship details exist in the existing data
    if (any(ship_data$IMO == imo_vector[counter])) {
      # Retrieve the existing ship details
      existing_ship_details <- ship_data[ship_data$IMO == imo_vector[counter], ]
      
      # UPDATED
      # Update the existing ship details with new values
      updated_ship_details <- existing_ship_details %>%
        mutate(
          Navigational_Status = navigational_status,
          Speed = speed,
          Course = course,
          Area = area
        )
      # -- UPDATED
      
      # Append the new Latitude and Longitude as new columns
      #existing_ship_details[[paste0("LAT_", start_timestamp)]] <- latitude
      #existing_ship_details[[paste0("LON_", start_timestamp)]] <- longitude
      
      #ship_details <- existing_ship_details
      updated_ship_details[[paste0("LAT_", start_timestamp)]] <- latitude
      updated_ship_details[[paste0("LON_", start_timestamp)]] <- longitude
      
      ship_details <- updated_ship_details
      
    } else {
      ship_details <- data.frame(
        IMO = imo_vector[counter],
        name = name_vector[counter],
        MMSI = mmsi_vector[counter], 
        Latitude = latitude,
        Longitude = longitude,
        Navigational_Status = navigational_status,
        Speed = speed,
        Course = course,
        Area = area,
        #Timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
      )
    }
  }
  
  print(paste("Completed scraping for:", as.character(ship_url)))
  
  # Increment the counter in the global environment
  counter <<- counter + 1
  
  print(ship_details)
  return(ship_details)
}

while (TRUE) {
  print("Starting scraping process...")
  ship_data <- ship_urls %>% map_df(scrape_ship_details)
  print("Scraping completed. Writing data to file...")
  
  # Write the updated data to the Excel file
  # write_xlsx(ship_data, excel_file)
  write_xlsx(ship_data, "test_tracking.xlsx")
  
  print("Data written to file.")
  print(paste("Next scraping cycle will start in", 900, "seconds."))
  Sys.sleep(900) #use seconds to set timer as 900 seconds is 15 minutes
  counter <<- 1
  start_timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  ship_data <- read_excel("test_tracking.xlsx")
}
