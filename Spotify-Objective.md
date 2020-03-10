Análise das paradas musicais Top 200 do Spotify para o mercado
brasileiro (Parte 2 - Spotify Objective Analysis)
================
Rodrigo Bercini Martins

### Top 20 músicas por número total de streams em 2019

Primeiro importamos o dataframe criado na seção anterior, depois o
filtramos e selecionamos as 20 músicas com maior número de streams em
2019.

    ## # A tibble: 20 x 3
    ##    Track_Name                                Artist          Total_Streams_Mill~
    ##    <fct>                                     <fct>           <chr>              
    ##  1 Bebi Liguei - Ao Vivo                     Marília Mendon~ 100.03             
    ##  2 Atrasadinha - Ao Vivo                     Felipe Araújo   99.62              
    ##  3 Vou Ter Que Superar - Ao Vivo             Matheus & Kauan 99.48              
    ##  4 Cobaia                                    Lauana Prado    99.43              
    ##  5 Tijolão - Ao Vivo                         Jorge & Mateus  98.21              
    ##  6 Todo Mundo Vai Sofrer - Ao Vivo           Marília Mendon~ 96.53              
    ##  7 Solteiro Não Trai - Ao Vivo               Gustavo Mioto   91.81              
    ##  8 Quando a vontade bater (Participação esp~ Pk              89.37              
    ##  9 Estado Decadente - Acústico               Zé Neto & Cris~ 87.50              
    ## 10 Cem Mil - Ao Vivo                         Gusttavo Lima   87.41              
    ## 11 Quarta Cadeira - Ao Vivo                  Matheus & Kauan 83.43              
    ## 12 Ela É do Tipo                             MC Kevin o Chr~ 81.14              
    ## 13 Evoluiu                                   MC Kevin o Chr~ 78.24              
    ## 14 Ouvi Dizer                                Melim           75.75              
    ## 15 Hoje Eu Vou Parar Na Gaiola               Mc Livinho      75.57              
    ## 16 Bebaça - Ao Vivo                          Marília Mendon~ 74.00              
    ## 17 Espaçosa Demais - Ao Vivo                 Felipe Araújo   73.28              
    ## 18 Quem Me Dera                              Márcia Fellipe  73.26              
    ## 19 Supera - Ao Vivo                          Marília Mendon~ 73.08              
    ## 20 Vamos pra Gaiola                          MC Kevin o Chr~ 72.31

Abaixo podemos conferir as músicas que estiveram no Top 200 das mais
ouvidas todos os 365 dias do ano.

    # Songs that were the entire year (365 days) in the top 200
    top_entire_year <- top_songs[top_songs$count == 365,c(2,3,5)]
    colnames(top_entire_year) <- c("Track_Name", "Artist", "Total_Streams_Millions")
    top_entire_year

### Análise de posição

Músicas que estiveram na primeira posição pelo maior número de dias.

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

### Análise de tom e modo

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
      labs(fill = 'Mode', x='Key and Mode', y='Streams in Millions', title='TOP 200 songs by key and mode (major/minor), y axis is the count of songs for each key', subtitle='C#, C and D are usually major; F#, B and F are usually minor')

    ggplot(key, aes(x=reorder(key_name, -total_streams_millions, sum), y=total_streams_millions, fill=mode_name)) +
      geom_col() + labs(fill = 'Mode', x='Key', y='Streams in Millions', title='TOP 200 songs by key and mode (major/minor), y axis is the sum of streams for each key', subtitle='C#, C and D are usually major; F#, B and F are usually minor') +
      scale_fill_manual(labels = c("Major", "Minor"), values=c('red','blue')) + dark_theme_minimal()
