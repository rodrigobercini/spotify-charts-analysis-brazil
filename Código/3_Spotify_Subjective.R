library(dplyr) # DF manipulation
library(readr) # Fil reading
library(stringr) # For string manpulation
library(spotifyr) # Allows for extracting metadata for songs
library(ggplot2) # Plotting
library(ggdark) # Plotting themes

df <- read.csv('df_final.csv')
# Function to specify decimals
specify_decimal <- function(x, k) trimws(format(round(x, k), nsmall=k))

########################
# Energy
########################

energy <- df %>%
  group_by(uri, track_name.x) %>%
  summarise(Artist=unique(artist_name),
            Energy=unique(energy),
            Total_Streams_Millions= sum(streams)/1000000) %>%
  arrange(desc(Energy))

energy <- energy[,2:5]
pl <- ggplot(energy, aes(y=Total_Streams_Millions, x=Energy)) +
  geom_point() + dark_theme_light() +geom_smooth() +
  labs(x="Energy", y='Streams in Millions', title="There seems to be a shy relation between Energy and Streams")

pl

energy$Total_Streams_Millions <- specify_decimal(energy$Total_Streams_Millions,2)
colnames(energy)[1] <- 'Track_Name'
head(energy, 10)
tail(energy, 10)

########################
# DANCEABILITY
########################

dance <- df %>%
  group_by(uri, track_name.x) %>%
  summarise(Artist=unique(artist_name),
            Danceability=unique(danceability),
            Total_Streams_Millions= sum(streams)/1000000) %>%
  arrange(desc(Danceability))

dance <- dance[,2:5]
pl <- ggplot(tempo, aes(y=Total_Streams_Millions, x=BPM)) +
  geom_point() + dark_theme_light() +geom_smooth() +
  labs(x="BPM", y='Streams in Millions', title="No meaningful relation between BPM and Streams")

dance$Total_Streams_Millions <- specify_decimal(dance$Total_Streams_Millions,2)
colnames(dance)[1] <- 'Track_Name'
head(dance,10)
tail(dance,10)



# No relation whatsoever
pl

########################
# TEMPO (BPM)
########################
tempo <- df %>%
  group_by(uri, track_name.x) %>%
  summarise(Artist=unique(artist_name),
            BPM=unique(tempo),
            Total_Streams_Millions=sum(streams)/1000000) %>%
  arrange(desc(BPM)) 

tempo <- tempo[,2:5]
pl <- ggplot(tempo, aes(y=Total_Streams_Millions, x=BPM)) +
  geom_point() + dark_theme_light() +geom_smooth() +
  labs(x="BPM", y='Streams in Millions', title="No meaningful relation between BPM and Streams")

tempo$Total_Streams_Millions <- specify_decimal(tempo$Total_Streams_Millions,2)
colnames(tempo)[1] <- 'Track_Name'

pl
head(tempo,10)
tail(tempo,10)
########################
# Liveness
########################

liveness <- df %>%
  group_by(uri, track_name.x) %>%
  summarise(Artist=unique(artist_name),
            Live=unique(liveness),
            Total_Streams_Millions=sum(streams)/1000000) %>%
  arrange(desc(Live)) 

liveness <- liveness[,2:5]
# Adjusting column and format
pl <- ggplot(liveness, aes(y=Total_Streams_Millions, x=Live)) +
  geom_point() + dark_theme_light() +geom_smooth() +
  labs(x="Liveness", y='Streams in Millions', title="No clear relation between Liveness and Streams")

# Adjusting column and format
liveness$Total_Streams_Millions <- specify_decimal(liveness$Total_Streams_Millions,2)
colnames(liveness)[1] <- 'Track_Name'

head(liveness, 10)
tail(liveness, 10)
pl

# No relation whatsoever

########################
# INSTRUMENTALNESS
########################

instrument <- df %>%
  group_by(uri, track_name.x) %>%
  summarise(Artist=unique(artist_name),
            Instrumentalness=unique(instrumentalness),
            Total_Streams_Millions=sum(streams)/1000000) %>%
  arrange(desc(Instrumentalness))

instrument <- instrument[,2:5]
pl <- ggplot(instrument, aes(y=Total_Streams_Millions, x=Instrumentalness)) +
  geom_point() + dark_theme_light() +geom_smooth() +
  labs(x="Instrumentalness", y='Streams in Millions', title="Instrumentalness seems to be a glitched feature")

instrument$Total_Streams_Millions <- specify_decimal(instrument$Total_Streams_Millions,2)
colnames(instrument)[1] <- 'Track_Name'

head(instrument, 10)
tail(instrument, 10)
pl
