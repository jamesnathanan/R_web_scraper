# Test create URL
library(rvest)
library(purrr)
library(dplyr)
library(writexl)
library(openxlsx)
library(readxl)

# For testing URL
library(httr)

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
search_url <- paste0("https://www.myshiptracking.com/vessels/", slug_vector, "-mmsi-", mmsi_vector, "-imo-", imo_vector)

#print(head(search_url))

# Function to check if URL is valid
check_url_validity <- function(url) {
  response <- tryCatch(GET(url), error = function(e) e)
  if (inherits(response, "error")) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}

# Loop over the URLs and check validity with delay
valid_urls <- vector("logical", length(search_url))
for (i in seq_along(search_url)) {
  valid_urls[i] <- check_url_validity(search_url[i])
  Sys.sleep(1)  # Delay of 1 second between requests
}

# Print the results
for (i in seq_along(search_url)) {
  if (valid_urls[i]) {
    cat("URL", i, "is valid\n")
  } else {
    cat("URL", i, "is not valid\n")
  }
}
