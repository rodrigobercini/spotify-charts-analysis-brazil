# Análise das paradas musicais Top 200 do Spotify para o mercado brasileiro (Parte 1 - Spotify Scraping)

### Preparação do ambiente

Instalando as bibliotecas necessárias.

```{r libraries}
library(spotifyr) # Allows for extracting metadata for songs
library(dplyr) # DF manipulation
library(readr) # Fil reading
library(stringr) # For string manpulation
library(ggplot2) # Plotting
library(ggdark) # Plotting themes
```

Declarando a chave do API do Spotify como variável do ambiente. Acesse a [documentação](https://cran.r-project.org/web/packages/spotifyr/readme/README.html) para mais detalhes.

```{r Spotify API, eval=FALSE}
Sys.setenv(SPOTIFY_CLIENT_ID = 'YOUR KEY')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'YOUR CLIENT SECRET')
```

### Web Scraping

#### Boa parte desta seção foi baseada no código de [Nathaniel Lao](http://natelao.com/SpotifyAnalysis/SpotifyAnalysis.html).

Declarando as datas desejadas, neste caso, o ano de 2019; e o país desejado, Brasil.

```{r setting_dates, eval=FALSE}
# Get start and end date
start_date <- as.Date("2019/01/01")
end_date <- as.Date("2019/12/31")

# Target URL prefix and suffix
url_prefix <- 'https://spotifycharts.com/regional/br/daily/'
url_suffix <- '/download'

# List of Column Names that should exist in the dataframe
col_names = c("Position","`Track Name`","Artist","Streams","URL")
```

### Criando e chamando a função para scraping

Cria a função para extrair dados de [Spotify Charts](https://spotifycharts.com/) e formar em um dataframe.

```{r extraction_function,eval=FALSE}
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
```

Loop que chama a função acima com as datas definidas como argumentos e forma o dataframe.

``` {r apply_function, eval=FALSE}
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
```

Cria uma coluna contendo o uri (variável usada para conseguir dados sobre as músicas) a partir da URL.

``` {r manipulation_checkpoint, eval=FALSE}
# Extracts uri from URL
top200_df$uri <-  lapply(top200_df[,'url'], function(x) str_sub(as.character(x), -22, -1))

top200_df = data.frame(lapply(top200_df, as.character), stringsAsFactors=FALSE)

# Checkpoint

write.csv(top200_df, 'top200_brazil.csv', row.names=FALSE)
```

### Reduzindo dataframe

Cria um dataframe com as músicas únicas que estiveram no Top 200 em qualquer dia de 2019.
Este passo é necessário pois o dataframe original possui 73.000 linhas, o que excederia o limite do API e bloquearia a conexão.

``` {r api_in_action, eval=FALSE}
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
```

### Uso do API para obtenção de metadata

Finalmente, usa o API do Spotify para conseguir informações das músicas e depois cruza os dados com o dataframe original.

```{r scrape_time, eval=FALSE}
for (i in 1:1095){
  simple_unique[i,names] <- get_track_audio_features(simple_unique[i,2])
  print(i)
}

# Checkpoint for songs with features scraped
write.csv(simple_unique, 'tracks_analysis.csv', row.names=FALSE)

# Final df with all tracks, days and features
df <- merge(x=top200_df, y=tracks_analysis, by.x = 'uri', by.y='id')
df$track_name.y <- NULL
```

### Engenharia de Recursos

Realiza uma rápida engenharia de recursos para converter o tom e o modo das músicas de número para nome. 
Ex: 0 - > C (dó).
0 -> minor.
Salva o dataframe final.

``` {r feature_engineering, eval=FALSE}
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
```
