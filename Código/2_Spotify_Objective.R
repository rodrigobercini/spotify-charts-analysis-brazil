df <- read.csv('df_final.csv')

library(dplyr) # DF manipulation
library(readr) # Fil reading
library(stringr) # For string manpulation
library(spotifyr) # Allows for extracting metadata for songs
library(ggplot2) # Plotting
library(ggdark) # Plotting themes


######################
# Top 20 songs
######################

# Function to specify decimals
specify_decimal <- function(x, k) trimws(format(round(x, k), nsmall=k))

# Filtering final df for unique songs
top_songs <- df %>%
  group_by(uri, track_name.x) %>%
  summarise(artist=unique(artist_name),
            count= n(),
            total_streams_millions= sum(streams)/1000000) %>%
  arrange(desc(total_streams_millions))

# Top 20 songs in 2019 by total streams
top_20 <- head(top_songs, 20)
top_20$total_streams_millions <- specify_decimal(top_20$total_streams_millions,2)
top_20 <- top_20[,c(2,3,5)]
colnames(top_20) <- c("Track_Name", "Artist", "Total_Streams_Millions")
top_20
View(top_20)

# Songs that were the entire year (365 days) in the top 200
top_entire_year <- top_songs[top_songs$count == 365,c(2,3,5)]
colnames(top_entire_year) <- c("Track_Name", "Artist", "Total_Streams_Millions")
top_entire_year


######################
# POSITION ANALYSIS
######################

# Songs that were the TOP 1 for most days

top1_songs <- df %>%
  filter(position == 1) %>%
  group_by(uri, track_name.x) %>%
  summarise(artist=unique(artist_name),
            count= n(),
            key_name=unique(key_name),
            mode_name=unique(mode_name),
            duration_ms=unique(duration_ms)) %>%
  arrange(desc(count))

top1_songs <- top1_songs[,2:4]
colnames(top1_songs) <- c('Track_Name', 'Artist', 'Days_as_Top1')
top1_songs

######################
# KEY/MODE ANALYSIS
######################

# Total streams of Top 200 by key and mode (major or minor)
key <- df %>%
  group_by(uri, track_name.x, key_mode) %>%
  summarise(count= n(),
            total_streams_millions= sum(streams)/1000000,
            key_name=unique(key_name),
            mode_name=unique(mode_name)) %>%
  arrange(desc(total_streams_millions))

key_mode_count <- df %>%
  group_by(key_mode) %>%
  summarise(count = n(),
  total_streams_millions= sum(streams)/1000000,
  mode_name = unique(mode_name))

ggplot(key_mode_count, aes(x=reorder(key_mode, -total_streams_millions, sum), y=total_streams_millions, fill=mode_name)) +
  geom_col() + dark_theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(fill = 'Mode', x='Key and Mode', y='Streams in Millions', title='TOP 200 songs by key and mode, y is the count of songs for each key', subtitle='C#, C and D are usually major; F#, B and F are usually minor')

ggplot(key, aes(x=reorder(key_name, -total_streams_millions, sum), y=total_streams_millions, fill=mode_name)) +
  geom_col() + labs(fill = 'Mode', x='Key', y='Streams in Millions', title='TOP 200 songs by key and mode, y is the sum of streams for each key', subtitle='C#, C and D are usually major; F#, B and F are usually minor') +
  scale_fill_manual(labels = c("Major", "Minor"), values=c('red','blue')) + dark_theme_minimal() 

key

#######################
# Same plot, different arrangement
ggplot(key, aes(x=reorder(key_name, -total_streams_millions, sum), y=total_streams_millions, colour=key_name, palette='Set1')) +
  geom_jitter() + dark_theme_minimal() + 
  labs(x='Key', y='Streams in Millions', colour='Key', title='TOP 200 songs by key and streams, each dot represents a song', subtitle='Ordered by overall total streams')

#ggplot(key, aes(x=key_name, y=total_streams_millions, colour=key_name, palette='Set1')) +
  geom_jitter() + dark_theme_minimal() + 
  labs(x='Key', y='Streams in Millions', colour='Key', title='TOP 200 songs by key and streams, each dot represents a song', subtitle='Key alphabetical order')

# Streams by Mode (major/minor)

ggplot(key, aes(y=total_streams_millions, x=mode_name, colour= mode_name)) +
  geom_jitter() + dark_theme_light() +
  labs(x='Mode', colour='Mode',
       y='Streams in Millions',
       title='TOP 200 streams by mode, each dot is a song',
       subtitle='The difference is relevant, but songs in major mode seem to performance better') +
  scale_color_hue(labels = c("Major", "Minor"))

######################
# Duration
######################

length <- df %>%
  group_by(uri,track_name.x) %>%
  summarise(count= n(),
            artist=unique(artist_name),
            total_streams_millions= sum(streams)/1000000,
            length_s=unique(duration_ms)/1000,
            mode_name = unique(mode_name)) %>%
  arrange(desc(length_s))
head(duration)

length$minutes <- (length$length_s %/% 60)
length$seconds <- (length$length_s %% 60)
length$min_sec <- paste(length$minutes, 'min',round(length$seconds),'s')

length
length_clean <- length[,c(2, 4, 10, 5)]
length_clean$total_streams_millions <- specify_decimal(length$total_streams_millions,2)
colnames(length_clean) <- c('Track_Name', 'Artist', 'Length(ms)', 'Total_Streams_Millions')

# Checking the 20 lenghtiest songs that made in the TOP 200
as.data.frame(head(length_clean,20))

# Plotting Length vs Total Streams coloured by Mode (major or minor)
ggplot(length, aes(x=length_s, y=total_streams_millions, colour=mode_name)) +
  geom_point() + dark_theme_gray()+
  scale_x_continuous(breaks = seq(50, 600, 50)) +
  labs(x='Length(sec)', y='Total Streams (Millions)', title='Songs in TOP 200 are about 100~250 seconds long')
