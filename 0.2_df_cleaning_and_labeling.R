library(tidyverse)

## Cleaning U.S. dataframe and labeling ---------------------

# load dataset 
data_dir <- "../newspaper-data/"

load(paste0(data_dir, "us_raw_df.RDa"))

## dropping articles outside of scrapping effort
us_df = us_raw_df %>% filter(datetime >= "2018-04-30 00:00:00")

## dropping incomplete outlets - bloomberg, buzzfeed, and usatoday
us_df = us_df %>% filter(outlet != "bloomberg" & outlet != "buzzfeed" & outlet != "usatoday")

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

##save dfs
save(us_df, file = paste0(data_dir,"us_df.rda"))
