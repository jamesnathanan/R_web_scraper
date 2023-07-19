# Load the required libraries
library(httr)
library(jsonlite)

teams <- c('ARI', 'ATL', 'BAL', 'BOS', 'CHC','CIN', 'CLE', 'COL', 'CWS', 'DET',
           'HOU', 'KC', 'LAA', 'LAD', 'MIA', 'MIL', 'MIN', 'NYM', 'NYY', 'OAK',
           'PHI', 'PIT', 'SD', 'SEA', 'SF', 'STL', 'TB', 'TEX', 'TOR', 'WAS')

names <- c('Arizona Diamondbacks', 'Atlanta Braves', 'Baltimore Orioles', 'Boston Red Sox', 'Chicago Cubs', 
           'Cincinnati Reds', 'Cleveland Guardians', 'Colorado Rockies', 'Chicago White Sox', 'Detroit Tigers',
           'Houston Astros', 'Kansas City Royals', 'Los Angeles Angels', 'Los Angeles Dodgers', 'Miami Marlins',
           'Milwaukee Brewers', 'Minnesota Twins', 'New York Mets', 'New York Yankees', 'Oakland Athletics',
           'Philadelphia Phillies', 'Pittsburgh Pirates', 'San Diego Padres', 'Seattle Mariners', 'San Francisco Giants',
           'St. Louis Cardinals', 'Tampa Bay Rays', 'Texas Rangers', 'Toronto Blue Jays', 'Washington Nationals')

names.short <- c('Diamondbacks', 'Braves', 'Orioles', 'Red Sox', 'Cubs', 
           'Reds', 'Guardians', 'Rockies', 'White Sox', 'Tigers',
           'Astros', 'Royals', 'Angels', 'Dodgers', 'Marlins',
           'Brewers', 'Twins', 'Mets', 'Yankees', 'Athletics',
           'Phillies', 'Pirates', 'Padres', 'Mariners', 'Giants',
           'Cardinals', 'Rays', 'Rangers', 'Blue Jays', 'Nationals')

# URL of the API
url <- "https://www.rotowire.com/baseball/tables/bullpen-usage.php?team=WAS"

# Make the HTTP GET request
response <- GET(url)

# Check the HTTP status code
if (status_code(response) == 200) {
  # Parse the JSON content
  data <- fromJSON(content(response, "text"))
  
  # 'data' now contains the JSON response as an R data frame or list
  # You can now work with the data as needed
  print(data)
} else {
  # If the status code is not 200, there was an error
  cat("Error: Failed to get data from the API.")
}
