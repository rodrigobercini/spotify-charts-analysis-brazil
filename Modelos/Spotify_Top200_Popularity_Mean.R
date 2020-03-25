### Mean popularity as prediction

library(tidyverse)
library(ggplot2)
library(ggdark)
library(caTools)
library(fastDummies)

# The following section must only be run once
###################################################
#df <- read.csv('df_final.csv')
#df2 <- select(df, c('track_name.x', 'uri' , 'danceability',
                    #'energy','key','loudness','mode',
                    #'speechiness','acousticness',
                    #'instrumentalness','liveness','valence','tempo',
                    #'time_signature', 'duration_ms'))
#df3 <- unique(df2)
#df3$artists <- NULL

#for (i in 1:1095){
  #df3[i,16] <- get_track(df3$uri[i])[13]
  #print(i)
#}

#write.csv(df3, 'Top200_popularity.csv')
##################################################

df <- read.csv('Top200_popularity.csv')

df <- select(df, c('popularity', 'danceability',
                   'energy','key','loudness','mode',
                   'speechiness','acousticness',
                   'liveness','valence','tempo',
                   'duration_ms'))
# Creating Dummies
df <- dummy_cols(df, c('key', 'mode'), remove_first_dummy = TRUE)

# Splitting into subsets
sample <- sample.split(df$popularity, SplitRatio = 0.7)
train <- subset(df, sample == TRUE)
test <- subset(df, sample == FALSE)

# Creating results df
rf.train.mean.pop <- mean(as.numeric(train[,1]))
results <- cbind(rf.train.mean.pop, test$popularity)
colnames(results) <- c('mean', 'actual')
results <- as.data.frame(results)

# Getting mean MSE
mse_avg_predicted <- mean((results[,2] - results[,1])^2)
mse_avg_predicted
# MSE 397

# Plot average vs Real
ggplot(results, aes(x=actual, y=mean)) +geom_point() +
  geom_smooth() + geom_line(aes(x=actual, y=actual)) + dark_theme_bw()

