Find an english version of this README file [here](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/blob/master/EN_README.md).

# Paradas Musicais Top 200 - Spotify Charts Brasil
## Análise das paradas musicais Top 200 diárias do Spotify para o mercado brasileiro

O Spotify é o serviço de streaming mais popular do ocidente, com mais de [270 milhões usuários ativos](https://s22.q4cdn.com/540910603/files/doc_financials/2019/q4/Shareholder-Letter-Q4-2019.pdf) em 79 países. A plataforma, junto de suas competidoras, impactaram drasticamente o funcionamento da indústria musical nos últimos anos. 

A empresa disponibiliza em [Spotify Charts](https://spotifycharts.com/) dados diários e semanais das 200 músicas com mais streams, permitindo filtrar por região.

Este repositório consolida os dados diários de 2019 para o mercado brasileiro, ou seja, extrai o Top 200 de todos os dias de 2019 e os converte em um único dataframe contendo as músicas, suas estatísticas de acesso e suas características técnicas e subjetivas (BPM, duração, tom, modo, dançabilidade, etc.).

Também é feita uma rápida modelagem de previsões para o parâmetro Popularidade.  Os resultados se mostraram iguais ou piores à previsão por média, com conversão dos modelos à mesma.

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

A análise foi dividida em três partes (arquivo markdown):
- [Spotify Scraping](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/blob/master/An%C3%A1lise/1_Spotify_Scraping.md): extração dos dados de Spotify Charts, manipulação do dataframe e extração das informações sobre as músicas através do API do Spotify
- [Spotify Objective Analysis](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/blob/master/An%C3%A1lise/2_Spotify_Objective_Analysis.md): análise sobre características objetivas das músicas, tais como posição no Top 200, tom, modo, duração, BPM, etc.
- [Spotify Subjective Analysis](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/blob/master/An%C3%A1lise/3_Spotify_Subjective_Analysis.md): curta análise sobre características subjetivas das músicas, tais como dançabilidade, energia, acusticidade, etc.

Confira o diretório [Código](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/tree/master/C%C3%B3digo) para o código completo.

## Principais resultados

É muito difícil um fator ser completamente determinante para o sucesso de uma música, sendo este o resultado de diversas variáveis, muitas delas dificilmente quantificáveis, como fatores culturais, estratégias de marketing, tendências locais, etc.

De qualquer forma, a análise nos permite verificar algumas das principais tendências do mercado musical brasileiro. Abaixo é possível conferir gráficos gerados.

![Tom e Modo](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/raw/master/An%C3%A1lise/2_Spotify_Objective_Analysis_files/figure-gfm/key__plot-1.png)

![Tom e Streams](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/raw/master/An%C3%A1lise/2_Spotify_Objective_Analysis_files/figure-gfm/key__plot2-1.png)

![Duração](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/raw/master/An%C3%A1lise/2_Spotify_Objective_Analysis_files/figure-gfm/duration_-1.png)

![Energia](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/raw/master/An%C3%A1lise/3_Spotify_Subjective_Analysis_files/figure-gfm/energy_plot-1.png)

## Previsão de popularidade

Foram utilizados modelos de Redes Neurais Artificiais (ANN), regressão linear (LM), support vector machines (SVM) e floresta aleatória (RF). Os modelos estão disponíveis na pasta [Modelos](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/tree/master/Modelos), porém os resultados não são 100% reproduzíveis já que a divisão amostral é aleatória.

Abaixo, é possível ver que eles não se saíram melhores do que a previsão por média. Apenas o de redes neurais teve um resultado similar, porém justamente pelo fato do modelo começar a convergir as previsões para a média.

|     | Mean | ANN |  LM | SVM | RF  |
|:---:|:----:|:---:|:---:|:---:|-----|
| MSE |  398 | 396 | 413 | 415 | 427 |

Dois são os motivos para um resultado tão pífio:
1) Pequena amostra: o dataframe de teste continha menos de 300 linhas, o que dificulta a previsão pelos modelos;
2) A baixa explicabilidade da popularidade das músicas pelos parâmetros obtidos pelo API, o que já havia sido constatado na [análise subjetiva](https://github.com/rodrigobercini/spotify-charts-analysis-brazil/blob/master/An%C3%A1lise/3_Spotify_Subjective_Analysis.md).