Find an english version of this README file [here](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/blob/master/EN_README.md).

# Paradas Musicais Top 200 - Spotify Charts Brasil
## Análise das paradas musicais Top 200 diárias do Spotify para o mercado brasileiro

O Spotify é o serviço de streaming mais popular do ocidente, com mais de [270 milhões usuários ativos](https://s22.q4cdn.com/540910603/files/doc_financials/2019/q4/Shareholder-Letter-Q4-2019.pdf) em 79 países. A plataforma, junto de suas competidoras, impactaram drasticamente o funcionamento da indústria musical nos últimos anos. 

A empresa disponibiliza em [Spotify Charts](https://spotifycharts.com/) dados diários e semanais das 200 músicas com mais streams, permitindo filtrar por região.

Este repositório consolida os dados diários de 2019 para o mercado brasileiro, ou seja, extrai o Top 200 de todos os dias de 2019 e os converte em um único dataframe contendo as músicas, suas estatísticas de acesso e suas características técnicas e subjetivas (BPM, duração, tom, modo, dançabilidade, etc.)

## Inspirações

A análise seria impossível sem o pacote [spotifyr](https://github.com/charlie86/spotifyr), que permite a extração de informações sobre as músicas através do [API oficial do Spotify](https://developer.spotify.com/).

Também é necessário ressaltar que o código para scraping foi quase que inteiramente baseado no trabalho de [Nathaniel Lao](http://natelao.com/SpotifyAnalysis/SpotifyAnalysis.html).

## Bibliotecas necessárias

```{r libraries}
install.packages("spotifyr") # Allows for extracting metadata for songs
install.packages("dplyr") # DF manipulation
install.packages("readr") # Fil reading
install.packages("stringr") # For string manipulation
install.packages("ggplot2") # Plotting
install.packages("ggdark") # Plotting themes
```

## Apresentação da análise

O código foi dividido em três partes:
- Spotify Scraping: extração dos dados de Spotify Charts, manipulação do dataframe e extração das informações sobre as músicas através do API do Spotify
- Spotify Objective Analysis: análise sobre características objetivas das músicas, tais como posição no Top 200, tom, modo, duração, BPM, etc.
- Spotify Subjective Analysis: curta análise sobre características subjetivas das músicas, tais como dançabilidade, energia, acusticidade, etc.

## Principais resultados

É muito difícil um fator ser completamente determinante para o sucesso de uma música, sendo este o resultado de diversas variáveis, muitas delas dificilmente quantificáveis, como fatores culturais, estratégias de marketing, tendências locais, etc.

Abaixo é possível conferir algumas características básicas do mercado musical brasileiro.


![Tom e Modo](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/raw/master/An%C3%A1lise/2_Spotify_Objective_Analysis_files/figure-gfm/key__plot-1.png)

![Tom e Streams](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/raw/master/An%C3%A1lise/2_Spotify_Objective_Analysis_files/figure-gfm/key__plot2-1.png)

![Duração](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/raw/master/An%C3%A1lise/2_Spotify_Objective_Analysis_files/figure-gfm/duration_-1.png)

![Energia](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/raw/master/An%C3%A1lise/3_Spotify_Subjective_Analysis_files/figure-gfm/energy_plot-1.png)