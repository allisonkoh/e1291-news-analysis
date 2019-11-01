## CLEANING DATA U.S.
#setwd("/Volumes/Sebastian/framing-project/")
library(tidyverse)

# load dataset 
data_dir <- "../newspaper-data/"

load(paste0(data_dir, "us_raw_df.RDa"))

## dropping articles outside of scrapping effort
us_df = us_raw_df %>% filter(datetime >= "2018-04-30 00:00:00")

## plot densities to assess scrapping problems
ggplot(us_df, aes(x=datetime, color = outlet)) + geom_density()

## dropping bloomberg, buzzfeed, and usatoday
us_df = us_df %>% filter(outlet != "bloomberg" & outlet != "buzzfeed" & outlet != "usatoday")

## plot dens
ggplot(us_df, aes(x=datetime, color = outlet)) + geom_density()

## table freqs
desc_tab = us_df %>% group_by(outlet) %>% summarize(articles = n(),
                                         author =  n_distinct(author),
                                         domain = n_distinct(domain),
                                         topic_tags = n_distinct(topic_tags),
                                         section = n_distinct(section),
                                         news_keywords = n_distinct(news_keywords),
                                         subsection = n_distinct(subsection),
                                         paywall = n_distinct(paywall),
                                         provider = n_distinct(provider))

# label lists
left = c("dailykos", "huffingtonpost", "motherjones", "thinkprogress")
lean_left = c("abcnews", "guardian", "newsweek", "nytimes", "politico", "washingtonpost", "yahoous")
center= c("bbcnews", "cnbc", "thehill")
lean_right = c("foxnews", "wallstreetjournal")
right = c("breitbart", "infowars", "townhall")

# factor order
id_order = c("left", "leanleft", "center", "leanright", "right")

# ideology label 
us_df$ideology = NA
us_df$ideology = ifelse(us_df$outlet %in% left, "left", us_df$ideology)
us_df$ideology = ifelse(us_df$outlet %in% lean_left, "leanleft", us_df$ideology)
us_df$ideology = ifelse(us_df$outlet %in% center, "center", us_df$ideology)
us_df$ideology = ifelse(us_df$outlet %in% lean_right, "leanright", us_df$ideology)
us_df$ideology = ifelse(us_df$outlet %in% right, "right", us_df$ideology)
us_df$ideology = factor(us_df$ideology, levels = id_order)

set.seed(1984) # for reproducibility

## taking random sample of 20k from each ideology
us_news_df = us_df %>% group_by(ideology) %>% sample_n(20000)

# cleaning text 
us_news_df$headline = gsub("| Breitbart", "", us_news_df$headline)
us_news_df$text = gsub("CNBC on YouTube", "", us_news_df$text)
us_news_df$text = gsub("— CNBC's", "", us_news_df$text)
us_news_df$text = gsub("for Breitbart News", "", us_news_df$text)
us_news_df$text = gsub("Breitbart News Tonight", "", us_news_df$text)
us_news_df$text = gsub("ThinkProgress", "", us_news_df$text)

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
colnames(us_news_validation) = gsub("validation\\.", "", colnames(us_news_validation))

##save dfs
save(us_df, file = paste0(data_dir,"us_df.rda"))
save(us_news_train, file = paste0(data_dir,"us_news_train.rda"))
save(us_news_test, file = paste0(data_dir,"us_news_test.rda"))
save(us_news_validation, file = paste0(data_dir,"us_news_validation.rda"))
