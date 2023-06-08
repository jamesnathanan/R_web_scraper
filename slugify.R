# Ship names vector
name_vector <- c("STENA GOTHICA",
                 "CELESTYAL CRYSTAL",
                 "STENA EUROPE",
                 "CELESTYAL OLYMPIA",
                 "ARTANIA",
                 "GNV ALLEGRA",
                 "WIND SURF",
                 "TOM SAWYER",
                 "SILJA SERENADE",
                 "POLARIS VG",
                 "GREEN SELJE",
                 "GREEN BODO",
                 "GREEN EGERSUND",
                 "GREEN MALOY")

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

# Print the slug vector
print(slug_vector)
