## CLEANING DATA U.S.

setwd("/Volumes/Sebastian/framing-project")

library(tidyverse)

## load
load("newspaper-data/us_raw_df.RDa")

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

desc_tab
