library(tidyverse)
library(ggplot2)
library(ggdark)
library(caTools)
library(e1071)
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

# Read unique df with popularity
svm <- read.csv('Top200_popularity.csv')

svm <- select(svm, c('popularity', 'danceability',
                       'energy','loudness',
                       'speechiness','acousticness',
                       'liveness','valence','tempo', 'key', 'mode',
                       'duration_ms'))

svm <- dummy_cols(svm, c('key', 'mode'), remove_first_dummy = TRUE)

# Split into subsets
sample <- sample.split(svm$popularity, SplitRatio = 0.7)
train <- subset(svm, sample == TRUE)
test <- subset(svm, sample == FALSE)

# Create model and check summary

model <- svm(popularity ~ ., data=train)
mse = mean(model$residuals^2)
mse
# MSE 344

summary(model)
# Multiple R-squared:  0.05126,	Adjusted R-squared:  0.02441 
# That's really low

# Get predictions
predictions <- predict(model, test)
results <- cbind(predictions, test$popularity)
colnames(results) <- c('predicted', 'actual')
results <- as.data.frame(results)

mse_predicted <- mean((results[,2] - results[,1])^2)
mse_predicted
# MSE = ~415

# Plot pred vs actual
ggplot(results, aes(x=actual, y=predicted)) +geom_point() +
  geom_smooth() + geom_line(aes(x=actual, y=actual))+
  dark_theme_bw()

# Results are worse than using mean for predictions