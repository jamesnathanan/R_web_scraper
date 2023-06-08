library(openxlsx)
library(readxl)
library(rvest)
library(purrr)

# Set the path to your Excel file
excel_file <- "ship_500.xlsx"

# Read the Excel file
ship_data <- read_excel(excel_file)

# Extract the IMO data into a vector
imo_vector <- ship_data$IMO

# Print the IMO vector
print(imo_vector)


scrape_mmsi_number <- function(imo_number) {
  search_url <- paste0("https://www.myshiptracking.com/vessels?side=false&name=", imo_number)
  search_page <- read_html(search_url)
  
  # Extract the MMSI number from the ship search results
  mmsi_number <- search_page %>% html_node(".stick-left-11+ td") %>% html_text() %>% trimws()
  
  return(mmsi_number)
}

# List of IMO numbers
#imo_numbers <- c(8700785, ...)  # Replace ... with other IMO numbers
imo_numbers <- imo_vector  # Replace ... with other IMO numbers

# Scrape MMSI numbers for each ship
# mmsi_numbers <- character(length(imo_numbers))
# for (i in seq_along(imo_numbers)) {
#   mmsi_numbers[i] <- scrape_mmsi_number(imo_numbers[i])
# }

# Print the MMSI numbers
#print(mmsi_numbers)

ship_data$MMSI <- mmsi_numbers

# Set the path for the new Excel file
new_excel_file <- "new_ship_500.xlsx"

# Write the updated data to a new Excel file
write.xlsx(ship_data, new_excel_file, row.names = FALSE)
