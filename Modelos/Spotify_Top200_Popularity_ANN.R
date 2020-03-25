library(tidyverse)
library(ggplot2)
library(ggdark)
library(caTools)
library(h2o)
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

ann <- read.csv('Top200_popularity.csv')

# Selecting numberic variables
ann <- select(ann, c('popularity', 'danceability',
       'energy','key','loudness','mode',
       'speechiness','acousticness',
       'liveness','valence','tempo',
       'duration_ms'))

# Creating dummies for key and mode
ann <- dummy_cols(ann, c('key', 'mode'), remove_first_dummy = TRUE)

# Subsetting
split = sample.split(ann$popularity, SplitRatio = 0.70)
training_set = subset(ann, split == TRUE)
test_set = subset(ann, split == FALSE)

# Scaling data
training_set[-1] = scale(training_set[-1])
test_set[-1] = scale(test_set[-1])

# Creating Model with aribitrary parameters
h2o.init(nthreads = -1)
classifier = NULL
classifier = h2o.deeplearning(y = 'popularity',
                               training_frame = as.h2o(training_set),
                               hidden = c(23, 15, 10, 5, 3),
                               epochs = 10,
                               activation = 'Rectifier',
                               train_samples_per_iteration = -2)
h2o.r2(classifier)
# R² 0.112, really low regarding prediction power
h2o.mse(classifier)
# MSE 356

# Predictions vs Real
prob_pred <- h2o.predict(classifier, newdata = as.h2o(test_set[-1]))
real_pred <- data.frame(as.vector(test_set[,1]), as.vector(prob_pred))
colnames(real_pred) <- c('real', 'predicted')

# Calculating MSE of test set
mse_ann_predicted <- mean((real_pred[,2] - real_pred[,1])^2)
mse_ann_predicted
# 406
ggplot(real_pred, aes(x=real, y=predicted)) +
  geom_point() + geom_smooth() +
  geom_line(aes(x=real, y=real)) + dark_theme_bw()
## Converging to average

######## Grid search to find better parameters

# Creating a list of hyperparameters
hyper_params <- list(
  activation = c("Rectifier"), 
  hidden = list(c(23, 12, 5, 3, 2), c(20, 15, 7, 7, 3),
                c(18, 12, 8, 5, 3),c(15, 7, 5, 5, 3)),
  epochs = c(10, 15, 20))

# Train and validate a cartesian grid of GBMs
h2o.grid("deeplearning", y = 'popularity',
         grid_id = "tunning",
         training_frame = as.h2o(training_set),
         validation_frame = as.h2o(test_set),
         hyper_params = hyper_params,
         train_samples_per_iteration = -2)

# Applying the chosen parameters
ann_gridperf <- h2o.getGrid(grid_id = "tunning",
                            sort_by = "mse",
                            decreasing = TRUE)
print(ann_gridperf)

# 12  Rectifier   10.0 [20, 15, 7, 7, 3]  tunning_model_4 395.04632403776367
# It'll change depending on the subset split process

classifier = h2o.deeplearning(y = 'popularity',
                              training_frame = as.h2o(training_set),
                              hidden = c(20, 15, 7, 7, 3),
                              epochs = 10,
                              activation = 'Rectifier',
                              train_samples_per_iteration = -2)

# After grid Predictions
prob_pred <- h2o.predict(classifier, newdata = as.h2o(test_set[-1]))
# After grid Real vs Predictions
real_pred <- data.frame(as.vector(test_set[,1]), as.vector(prob_pred))
colnames(real_pred) <- c('actual', 'predicted')
# After grid MSE
mse_ann_predicted <- mean((real_pred[,2] - real_pred[,1])^2)
mse_ann_predicted

# After grid  MSE = 396, converges to average
# MSE can very depending on the subset
ggplot(real_pred, aes(x=actual, y=predicted)) +
  geom_point() + geom_smooth() +
  geom_line(aes(x=actual, y=actual)) + dark_theme_bw()
