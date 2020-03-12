Sys.setenv(SPOTIFY_CLIENT_ID = 'YOUR_KEY')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'YOUR_CLIENT_SECRET')

library(dplyr) # DF manipulation
library(readr) # Fil reading
library(stringr) # For string manpulation
library(spotifyr) # Allows for extracting metadata for songs
library(ggplot2) # Plotting
library(ggdark) # Plotting themes


# Get start and end date
start_date <- as.Date("2019/01/01")
end_date <- as.Date("2019/12/31")

# Target URL prefix and suffix
url_prefix <- 'https://spotifycharts.com/regional/br/daily/'
url_suffix <- '/download'


# List of Column Names that should exist in the dataframe
col_names = c("Position","`Track Name`","Artist","Streams","URL")

# This pulls data from a certain date
pull_top200 <- function(date) {
  # Create the URL target
  url <- str_c(url_prefix,format.Date(date),url_suffix)
  # Pull data from Spotify
  top200_df <- read_csv(url, skip=1)
  # There are sometimes file that do not exist, this handles the exception
  #ifelse(all(colnames(top200_df) %in% col_names),
  top200_df <- top200_df %>% mutate(Date = date) # Create a date attribute
  #top200_df <- data.frame()) # Return an empty data frame if invalid
  top200_df
}

date <- start_date # set data counter
top200_df <- data.frame() # initialize empty df

# Iterate every date from start to end
# And get top 200 songs
while (date <= end_date) {
  print(str_c("Processing ", date))
  # Concat the current data frame with new data
  top200_df <- top200_df %>%
    rbind(pull_top200(date))
  date <- date + 1
}

# Rename columns for consistency

top200_df <- rename(top200_df, position = Position,
                    track_name = `Track Name`,
                    artist_name = Artist,
                    streams = Streams,
                    url = URL,
                    date = Date)


# Extracts uri from URL
top200_df$uri <-  lapply(top200_df[,'url'], function(x) str_sub(as.character(x), -22, -1))


top200_df = data.frame(lapply(top200_df, as.character), stringsAsFactors=FALSE)

# Checkpoint

write.csv(top200_df, 'top200_brazil.csv', row.names=FALSE)


######################
# Getting features from songs that were in top200 in any day of 2019
# This has to be done because scraping 73k rows would exceed the API limit and the connection would be blocked
######################

# Creates a "simple" df with trackname and URI for scraping 
simple <- top200_df[,c('track_name','uri')]

# Convert from factor to character
simple$track_name <- as.character(simple$track_name)
simple$uri <- as.character(simple$uri)

# Gets unique rows for later scraping
simple_unique <- unique(simple)

# Test the function and scrapes the first row
# Besides testing the API, this is also important to store the labels as "names"
test <- get_track_audio_features(simple_unique[1, 2])
values <- unlist(test, use.names=FALSE)
# Store the labels
names <- colnames(test)
names

### Iterates over rows to get audio features
# This had to be done via For loop because the function doesn't allow more than 100 IDs per request
# simple_unique[,names] %>% lapply(function(x) get_track_audio_features(sample_unique[x,2]))
for (i in 1:1095){
  simple_unique[i,names] <- get_track_audio_features(simple_unique[i,2])
  print(i)
}


# Checkpoint
write.csv(simple_unique, 'tracks_analysis.csv', row.names=FALSE)

# Final df with all tracks, days and features
df <- merge(x=top200_df, y=tracks_analysis, by.x = 'uri', by.y='id')
df$track_name.y <- NULL

# Creating a key_name column
index <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
values <- c("C", "C#", "D", "D#", "E", "F", 'F#', 'G', 'G#', 'A', 'A#', 'B')
df$key_name<- values[match(df$key, index)]

# Creating a mode_name column
index_mode <- c(0, 1)
values_mode <- c("minor", "major")
df$mode_name <- values_mode[match(df$mode, index_mode)]

# Creating a key + mode column
df$key_mode <- paste(df$key_name, df$mode_name)

# Final Checkpoint
write.csv(df, 'df_final.csv', row.names=FALSE)
