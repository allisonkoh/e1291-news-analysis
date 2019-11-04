## Outlet-specific string cleaning and data split
library(tidyverse)
library(textclean)

# load dataset 
data_dir <- "../newspaper-data/"
load(paste0(data_dir, "us_df.RDa"))

set.seed(1984) # for reproducibility

## taking random sample of 20k from each ideology
us_news_df = us_df %>% group_by(ideology) %>% sample_n(20000)

# cleaning text for outlet-specific strings
us_news_df$headline = gsub("| Breitbart", "", us_news_df$headline)
us_news_df$text = gsub("CNBC on YouTube", "", us_news_df$text)
us_news_df$text = gsub("— CNBC's", "", us_news_df$text)
us_news_df$text = gsub("for Breitbart News", "", us_news_df$text)
us_news_df$text = gsub("Breitbart News Tonight", "", us_news_df$text)
us_news_df$text = gsub("ThinkProgress", "", us_news_df$text)

# cleaning contractions
us_news_df$text = replace_contractions(us_news_df$text)
us_news_df$description = replace_contractions(us_news_df$description)

## splitting into training, validation and test sets
spec = c(train = .8, test = .1, validate = .1)

g = sample(cut(
  seq(nrow(us_news_df)), 
  nrow(us_news_df)*cumsum(c(0,spec)),
  labels = names(spec)
))

res = split(us_news_df, g)

## check split results 
sapply(res, nrow)/nrow(us_news_df)
addmargins(prop.table(table(g)))

## rename column names
us_news_train <- as.data.frame(res[1])
us_news_test <- as.data.frame(res[2])
us_news_validation <- as.data.frame(res[3])

colnames(us_news_train) = gsub("train\\.", "", colnames(us_news_train))
colnames(us_news_test) = gsub("test\\.", "", colnames(us_news_test))
colnames(us_news_validation) = gsub("validate\\.", "", colnames(us_news_validation))

##save dfs
save(us_news_train, file = paste0(data_dir,"us_news_train.rda"))
save(us_news_test, file = paste0(data_dir,"us_news_test.rda"))
save(us_news_validation, file = paste0(data_dir,"us_news_validation.rda"))
