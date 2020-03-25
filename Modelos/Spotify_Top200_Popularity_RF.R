library(tidyverse)
library(ggplot2)
library(ggdark)
library(caTools)
library(randomForest)
library(caret)
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

rf <- read.csv('Top200_popularity.csv')

rf <- select(rf, c('popularity', 'danceability',
                   'energy','key','loudness','mode',
                   'speechiness','acousticness',
                   'liveness','valence','tempo',
                   'duration_ms'))

rf <- dummy_cols(rf, c('key', 'mode'), remove_first_dummy = TRUE)

# Split into subsets
sample <- sample.split(rf$popularity, SplitRatio = 0.7)
train <- subset(rf, sample == TRUE)
test <- subset(rf, sample == FALSE)

# Create model and check summary
model.rf = randomForest(popularity ~ ., data = train,
                        importance= TRUE,
                        ntrees=500)

model.rf$importance
# danceabul

model.mse <- mean(model.rf$mse)
model.mse
# ~ 443

# Get predictions
predictions <- predict(model.rf, test)
results <- cbind(predictions, test$popularity)
colnames(results) <- c('predicted', 'actual')
results <- as.data.frame(results)
head(results)

mse_predicted <- mean((results[,2] - results[,1])^2)
mse_predicted
# 466

# Plot pred vs actual
ggplot(results, aes(x=actual, y=predicted)) +geom_point() +
  geom_smooth() + geom_line(aes(x=actual, y=actual)) + dark_theme_bw()

# Results are way worse than using mean for predictions

#### Grid search for better parameters

# Fitting model with ranger method
rf_fit <- train(popularity ~ ., 
                data = train, 
                method = "ranger")

# Checking fit
print(rf_fit)

# Getting adjusted model predictions
predictions <- predict(rf_fit, test)
results <- cbind(predictions, test$popularity)
colnames(results) <- c('predicted', 'actual')
results <- as.data.frame(results)
head(results)

mse_predicted <- mean((results[,2] - results[,1])^2)
mse_predicted
# 427, better

# Line seems to be converging to average
ggplot(results, aes(x=actual, y=predicted)) +geom_point() +
  geom_smooth() + geom_line(aes(x=actual, y=actual)) + dark_theme_bw()

# Results are still worse than using mean for predictions
