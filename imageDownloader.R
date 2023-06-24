library(stringr)
library(readr)

# Define the URL pattern and file name format
url_pattern <- "https://www.ord.io/content/"
file_format <- "%d.png"

# Read the CSV file containing hashes
hashes <- read_csv("id.csv")$id

print(hashes)

# Create a directory to save the images
dir.create("images", showWarnings = FALSE)
setwd("images")

# Download images
for (counter in 1:length(hashes)) {
  hash <- hashes[counter]
  url <- str_c(url_pattern, hash)
  file_name <- sprintf(file_format, counter)
  
  download.file(url, file_name, mode = "wb")
  cat("Downloaded", file_name, "\n")
  
  # Add a small delay of 1 second
  Sys.sleep(0.3)
}
