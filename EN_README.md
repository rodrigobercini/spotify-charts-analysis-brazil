Acesse o README em português [aqui](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/blob/master/README.md).

# Top 200 Music Charts - Spotify Charts Brazil
## Daily Spotify Charts Top 200 Analysis for brazilian music market
 
Spotify is the most popular western music streaming service with more than [270 million active users](https://s22.q4cdn.com/540910603/files/doc_financials/2019/q4/Shareholder-Letter-Q4-2019.pdf) in 79 countries. The platform, and its competitors, had a big impact on how the music industry functions in the past 10 years.

The company provides daily and weekly data for the Top 200 songs, filtered by geographical region, on [Spotify Charts](https://spotifycharts.com/).

This repo consolidates brazilian daily data of 2019, i.e. scrapes every single day of 2019 and converts the data into a dataframe containing songs, access stats and audio features (key, mode, tempo, danceability, etc.).

## Inspirations

This analysis would be impossible without the [spotifyr](https://github.com/charlie86/spotifyr) R package, that provides an elegant way of scraping songs features through [Spotify's Official API](https://developer.spotify.com/).

It's also important to say that the code for scraping Spotify Charts was almost entirely based on the work of [Nathaniel Lao](http://natelao.com/SpotifyAnalysis/SpotifyAnalysis.html). Make sure to check his analysis!

## Necessary libraries

```{r libraries}
install.packages("spotifyr") # Allows for extracting metadata for songs
install.packages("dplyr") # DF manipulation
install.packages("readr") # Fil reading
install.packages("stringr") # For string manipulation
install.packages("ggplot2") # Plotting
install.packages("ggdark") # Plotting themes
```

## Analysis

The analysis was divided in three parts (markdown file):
- [Spotify Scraping](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/blob/master/An%C3%A1lise/1_Spotify_Scraping.md): Spotify Charts scraping, dataframe manipulation and songs features scraping via Spotify's Official Website.
- [Spotify Objective Analysis](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/blob/master/An%C3%A1lise/2_Spotify_Objective_Analysis.md): analysis of songs objective features, such as position, key, mode, duration and tempo.
- [Spotify Subjective Analysis](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/blob/master/An%C3%A1lise/3_Spotify_Subjective_Analysis.md): short analysis of subjective features, such as danceability, energy, acousticness, etc.

Check [Código](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/tree/master/C%C3%B3digo) for the entire code.

## Main results

It's hard to find a specific factor that completely explains the success of a song, since the music market is complex and is impacted by many different variables, many of them being impossible to quantify. Still, it's possible to understand some of the main trends in the brazilian music market.

Find below some of the analysis' results.


![Key and Mode](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/raw/master/An%C3%A1lise/2_Spotify_Objective_Analysis_files/figure-gfm/key__plot-1.png)

![Key and Streams](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/raw/master/An%C3%A1lise/2_Spotify_Objective_Analysis_files/figure-gfm/key__plot2-1.png)

![Duration](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/raw/master/An%C3%A1lise/2_Spotify_Objective_Analysis_files/figure-gfm/duration_-1.png)

![Energy](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/raw/master/An%C3%A1lise/3_Spotify_Subjective_Analysis_files/figure-gfm/energy_plot-1.png)