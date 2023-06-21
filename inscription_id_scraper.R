library(httr)
library(jsonlite)

inscription_ids <- c()

for (counter in 0:2242) {
  url <- paste0("https://ordiscan.com/api/trpc/inscription.listFromAddress?batch=1&input=%7B%220%22%3A%7B%22json%22%3A%7B%22address%22%3A%22bc1qgpw45jt6anfs8ayqw4u2ywjae7fqxsnau7r973%22%2C%22limit%22%3A1%2C%22cursor%22%3A", counter, "%7D%7D%7D")
  
  response <- GET(url)
  data <- content(response, as = "text")
  #print(data)
  parsed_data <- fromJSON(data, flatten = FALSE)
  #print(parsed_data)
  
  #inscription_id <- parsed_data[[1]]$result$data$json[[1]]$inscription_id
  inscription_id <- parsed_data$result$data$json[[1]]$inscription_id
  #inscription_id <- parsed_data[[1]][[1]])[[1]][[1]]$inscription_id
  print(inscription_id)
  inscription_ids <- c(inscription_ids, inscription_id)
  
  # Add a delay of 1 second between API requests
  Sys.sleep(0.1)
}

# Create a data frame to store the inscription_ids
df <- data.frame(inscription_id = inscription_ids)

# Save the data frame as JSON
json_output <- toJSON(df)

# Save JSON to a file
write(json_output, file = "inscription_ids.json")

# Save inscription_ids as a list
inscription_list <- list(inscription_ids = inscription_ids)

# Save the list as JSON
json_output <- toJSON(inscription_list)

# Save JSON to a file
write(json_output, file = "inscription_ids.json")
