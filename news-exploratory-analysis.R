## ----setup, include=FALSE------------------------------------------------
# defaults 
knitr::opts_chunk$set(echo=FALSE)
options(java.parameters = "-Xmx1024m")
rm(list=ls())
setwd("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data")

# packages 
library(foreign)
library(haven)
library(knitr)
library(magrittr)
library(plyr)
library(dplyr)
library(magrittr)
library(descr)
library(ggplot2)
library(kableExtra)
library(pander) 
library(expss)
library(scales)
library(stargazer)
library(foreach)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(wesanderson)
library(quanteda)
library(stringr)
library(lubridate)
library(zoo)
library(ggpubr)

# set root directory (for some reason some errors with setwd())
opts_knit$set(root.dir="/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data")

# ggplot defaults 
ggplot2::theme_set(theme_minimal())


## ----loading and merging raw data----------------------------------------
# # loading data
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/abcnews_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/bbcnews_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/bloomberg_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/breitbart_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/cnbc_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/dailykos_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/foxnews_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/guardian_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/huffingtonpost_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/infowars_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/motherjones_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/newsweek_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/nytimes_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/politico_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/thehill_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/thinkprogress_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/townhall_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/vice_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/washingtonpost_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/wsj_to_may_2019.RDa")
# load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data/yahoous_to_may_2019.RDa")
# 
# # full_join()
# us_raw_df <- full_join(abcnews_df,bbcnews_df)
# us_raw_df = full_join(us_raw_df, bloomberg_df)
# us_raw_df = full_join(us_raw_df, breitbart_df)
# us_raw_df = full_join(us_raw_df, cnbc_df)
# us_raw_df = full_join(us_raw_df, dailykos_df)
# us_raw_df = full_join(us_raw_df, foxnews_df)
# us_raw_df = full_join(us_raw_df, guardian_df)
# us_raw_df = full_join(us_raw_df, huffingtonpost_df)
# us_raw_df = full_join(us_raw_df, infowars_df)
# us_raw_df = full_join(us_raw_df, motherjones_df)
# us_raw_df = full_join(us_raw_df, newsweek_df)
# us_raw_df = full_join(us_raw_df, nytimes_df)
# us_raw_df = full_join(us_raw_df, politico_df)
# us_raw_df = full_join(us_raw_df, thehill_df)
# us_raw_df = full_join(us_raw_df, thinkprogress_df)
# us_raw_df = full_join(us_raw_df, townhall_df)
# us_raw_df = full_join(us_raw_df, washingtonpost_df)
# us_raw_df = full_join(us_raw_df, wsj_df)
# us_raw_df = full_join(us_raw_df, yahoous_df)
# 
# # saving df 
# save(us_raw_df,file="/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data-append.RDa")


## ----loading full dataset and hoping for the best------------------------
load("/Users/allisonwun-huikoh/Google Drive/___hertie/2019-fall/e1291-ml/e1291-group-project/news-data-append.RDa")
df <- us_raw_df

names(df)
nrow(df)


## ----nyt topfeatures-----------------------------------------------------
# names(nytimes_df)
# table(nytimes_df$topic_tags)

# subset for politics using grep on topic_tags
nytimes_pol_df <- nytimes_df[grep("Polit",nytimes_df$topic_tags),]

# corpus of topic_tags only 
nyt_pol_docs1 <- corpus(nytimes_pol_df$topic_tags)
summary(nyt_pol_docs1)

# cleaning text 
nyt_pol_dfm1 <- dfm(nyt_pol_docs1,
                   remove=stopwords("english"),
                   stem=TRUE,remove_punct=TRUE)

# topfeatures
topfeatures(nyt_pol_dfm1,100)

# plot features by frequency 
nyt_pol_features <- textstat_frequency(nyt_pol_dfm1,n=100)
nyt_pol_features$feature <- with(nyt_pol_features,reorder(feature,-frequency))


ggplot(nyt_pol_features, aes(x=feature,y=frequency)) + 
  geom_point() + 
  theme(axis.text.x=element_text(angle=90,hjust=1))

# visualizing dfm 
# set.seed(1217)
# textplot_wordcloud(nyt_pol_dfm1, min_count=250, random_order=FALSE,
#                    rotation=.25,
#                    color=RColorBrewer::brewer.pal(8,"Dark2"))


## ----nyt ts--------------------------------------------------------------
# corpus for all text and metadata 
nyt_pol_docs <- corpus(nytimes_pol_df)
summary(nyt_pol_docs$documents)
nyt_pol_tokeninfo <- summary(nyt_pol_docs)
nyt_pol_tokeninfo
nyt_pol_tokeninfo

# dfm object 
nyt_pol_dfm <- dfm(nyt_pol_docs,
                   remove=stopwords("english"),
                   stem=TRUE,remove_punct=TRUE)

# convert to df for further subsetting 
nyt_pol_df <- docvars(nyt_pol_dfm)

# add date vars 
nyt_pol_df$month <- lubridate::month(nyt_pol_df$datetime)
nyt_pol_df$year <- lubridate::year(nyt_pol_df$datetime)
nyt_pol_df$moyr <- paste(nyt_pol_df$year,nyt_pol_df$month,sep="-")

# event: midterm elections 
nyt_midterms <- nyt_pol_df[grep("Midterm",nyt_pol_df$topic_tags),]

# group_by()
nyt_midterms_bymon <- nyt_midterms %>% 
  group_by(moyr) %>% 
  summarize(n=n())
nyt_midterms_bymon
nyt_midterms_bymon$chron <- c(1810,1811,1903,1904,1805,1905,1806,1807,1808,1809)

ggplot(nyt_midterms_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
   geom_line() + geom_point()

# coverage of immigration 
nyt_immigr <- nyt_pol_df[grep("Immigr|Bord",nyt_pol_df$topic_tags),]
nrow(nyt_immigr)
# group_by() for immigr 
nyt_immigr_bymon <- nyt_immigr %>% 
  group_by(moyr) %>% 
  summarize(n=n())
nyt_immigr_bymon$chron <- c(1810,1811,1812,1804,1805,1806,1807,1808,1809,1901,1902,1903,1904,1905)
nyt_immigr_bymon <- nyt_immigr_bymon[c(1:3,5:14),] # get rid of apr 2019 

ggplot(nyt_immigr_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
  geom_line() + geom_point()

# mueller report 
nyt_mueller <- nyt_pol_df[grep("Mueller",nyt_pol_df$topic_tags),]

# group_by() for mueller 
nyt_mueller_bymon <- nyt_mueller %>% 
  group_by(moyr) %>% 
  summarize(n=n())
nyt_mueller_bymon
nyt_mueller_bymon$chron <- c(1812,1804,1805,1806,1807,1808,1809,1901,1902,1903,1904,1905)
nyt_mueller_bymon <- nyt_mueller_bymon[c(1,3:12),] # get rid of apr 2019 

mueller_n <- c(rep(0,2))
mueller_moyr <- c("2018-10","2018-11")
mueller_chron <- c(1810,1811)

mueller_append <- as.data.frame(cbind(mueller_n,mueller_moyr,mueller_chron))
names(mueller_append)[names(mueller_append) == "mueller_n"] <- "n"
names(mueller_append)[names(mueller_append) == "mueller_moyr"] <- "moyr"
names(mueller_append)[names(mueller_append) == "mueller_chron"] <- "chron"

nyt_mueller_bymon <- rbind(nyt_mueller_bymon,mueller_append)
nyt_mueller_bymon$n <- as.numeric(nyt_mueller_bymon$n)
nyt_mueller_bymon$chron <- as.numeric(nyt_mueller_bymon$chron)

ggplot(nyt_mueller_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
   geom_line() + geom_point()

# brett kavanaugh
nyt_brett <- nyt_pol_df[grep("Brett|Kavanaugh",nyt_pol_df$topic_tags),]

# group_by() for brett 
nyt_brett_bymon <- nyt_brett %>% 
  group_by(moyr) %>% 
  summarize(n=n())
nyt_brett_bymon
nyt_brett_bymon$chron <- c(1810,1811,1812,1806,1807,1808,1809,1901,1902,1903,1904,1905)

ggplot(nyt_brett_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
   geom_line() + geom_point()


## ----fox-----------------------------------------------------------------
names(foxnews_df)

# corpus of just headlines 
fox_docs <- corpus(foxnews_df$headline)
fox_dfm <- dfm(fox_docs,
                remove=stopwords("english"),
                stem=TRUE,remove_punct=TRUE)
topfeatures(fox_dfm,200)

# full corpus by topic- immigration 
fox_immigr <- foxnews_df[grep("Immigr|immigr|Bord",foxnews_df$headline),]
fox_immigr_docs <- corpus(fox_immigr)
fox_immigr_dfm <- dfm(fox_immigr_docs, 
                remove=stopwords("english"),
                stem=TRUE,remove_punct=TRUE)

# dfm to df, add date vars 
fox_immigr <- docvars(fox_immigr_dfm)
fox_immigr$month <- month(fox_immigr$datetime)
fox_immigr$year <- year(fox_immigr$datetime)
fox_immigr$moyr <- paste(fox_immigr$year,fox_immigr$month,sep="-")

# coverage of immigration by month 
fox_immigr_bymon <- fox_immigr %>% 
  group_by(moyr) %>% 
  summarize(n=n())
fox_immigr_bymon
fox_immigr_bymon$chron <- c(1810,1811,1812,1805,1806,1807,1808,1809,1901,1902,1903,1904,1905)

ggplot(fox_immigr_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
  geom_line() + geom_point()

# mueller report 
fox_mueller <- foxnews_df[grep("Mueller",foxnews_df$headline),]
fox_mueller_docs <- corpus(fox_mueller)
fox_mueller_dfm <- dfm(fox_mueller_docs,
                       remove=stopwords("english"),
                       stem=TRUE,remove_punct=TRUE)

# dfm to df, add date vars 
fox_mueller <- docvars(fox_mueller_dfm)
fox_mueller$month <- month(fox_mueller$datetime)
fox_mueller$year <- year(fox_mueller$datetime)
fox_mueller$moyr <- paste(fox_mueller$year,fox_mueller$month,sep="-")

# group_by() for mueller 
fox_mueller_bymon <- fox_mueller %>% 
  group_by(moyr) %>% 
  summarize(n=n())
fox_mueller_bymon
fox_mueller_bymon$chron <- c(1712,1810,1811,1812,1805,1806,1807,1808,1809,1901,1902,1903,1904,1905)
fox_mueller_bymon <- fox_mueller_bymon[c(2:14),] # get rid of dec 2017

ggplot(fox_mueller_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
   geom_line() + geom_point()

# brett kavanaugh 
fox_brett <- foxnews_df[grep("Brett|Kavanaugh",foxnews_df$headline),]
fox_brett_docs <- corpus(fox_brett)
fox_brett_dfm <- dfm(fox_brett_docs,
                       remove=stopwords("english"),
                       stem=TRUE,remove_punct=TRUE)

# dfm to df, add date vars 
fox_brett <- docvars(fox_brett_dfm)
fox_brett$month <- month(fox_brett$datetime)
fox_brett$year <- year(fox_brett$datetime)
fox_brett$moyr <- paste(fox_brett$year,fox_brett$month,sep="-")

# group_by() for brett 
fox_brett_bymon <- fox_brett %>% 
  group_by(moyr) %>% 
  summarize(n=n())
fox_brett_bymon
fox_brett_bymon$chron <- c(1810,1811,1812,1805,1806,1807,1808,1809,1901,1902,1903,1904,1905)

ggplot(fox_brett_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
   geom_line() + geom_point()


## ----breitbart-----------------------------------------------------------
names(breitbart_df)

# corpus of just topic tags 
bre_docs <- corpus(breitbart_df$topic_tags)
bre_dfm <- dfm(bre_docs,
               remove=stopwords("english"),
               stem=TRUE,remove_punct=TRUE)
topfeatures(bre_dfm,200)

# full corpus by topic- immigration 
bre_immigr <- breitbart_df[grep("Immigr|Bord",breitbart_df$topic_tags),]
bre_immigr_docs <- corpus(bre_immigr)
bre_immigr_dfm <- dfm(bre_immigr_docs,
                      remove=stopwords("english"),
                      stem=TRUE,remove_punct=TRUE) 

# dfm to df, add date vars 
bre_immigr <- docvars(bre_immigr_dfm)
bre_immigr$month <- month(bre_immigr$datetime)
bre_immigr$year <- year(bre_immigr$datetime)
bre_immigr$moyr <- paste(bre_immigr$year,bre_immigr$month,sep="-")

# coverage of immigrant by month 
bre_immigr_bymon <- bre_immigr %>% 
  group_by(moyr) %>% 
  summarize(n=n())
bre_immigr_bymon
bre_immigr_bymon$chron <- c(1810,1811,1812,1804,1805,1806,1807,1808,1809,1901,1902,1903,1904,1905,NA)
bre_immigr_bymon <- bre_immigr_bymon[c(1:3,5:14),] # get rid of apr 2019 and NA 

ggplot(bre_immigr_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
  geom_point() + geom_line()

# mueller report 
bre_mueller <- breitbart_df[grep("Mueller",breitbart_df$topic_tags),]
bre_mueller_docs <- corpus(bre_mueller)
bre_mueller_dfm <- dfm(bre_mueller_docs,
                      remove=stopwords("english"),
                      stem=TRUE,remove_punct=TRUE) 

# dfm to df, add date vars 
bre_mueller <- docvars(bre_mueller_dfm)
bre_mueller$month <- month(bre_mueller$datetime)
bre_mueller$year <- year(bre_mueller$datetime)
bre_mueller$moyr <- paste(bre_mueller$year,bre_mueller$month,sep="-")

# coverage of MUELLER by month 
bre_mueller_bymon <- bre_mueller %>% 
  group_by(moyr) %>% 
  summarize(n=n())
bre_mueller_bymon
bre_mueller_bymon$chron <- c(1810,1811,1812,1805,1807,1808,1809,1901,1902,1903,1904,1905)

bre_mueller_append <- c("2019-6",0,1806)
bre_mueller_bymon <- rbind(bre_mueller_bymon,bre_mueller_append)

bre_mueller_bymon$chron <- as.numeric(bre_mueller_bymon$chron)
bre_mueller_bymon$n <- as.numeric(bre_mueller_bymon$n)

ggplot(bre_mueller_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
  geom_point() + geom_line()

# brett kavanaugh 
bre_brett <- breitbart_df[grep("Brett|Kavanaugh",breitbart_df$topic_tags),]
bre_brett_docs <- corpus(bre_brett)
bre_brett_dfm <- dfm(bre_brett_docs,
                      remove=stopwords("english"),
                      stem=TRUE,remove_punct=TRUE) 

# dfm to df, add date vars 
bre_brett <- docvars(bre_brett_dfm)
bre_brett$month <- month(bre_brett$datetime)
bre_brett$year <- year(bre_brett$datetime)
bre_brett$moyr <- paste(bre_brett$year,bre_brett$month,sep="-")

# coverage of brett by month 
bre_brett_bymon <- bre_brett %>% 
  group_by(moyr) %>% 
  summarize(n=n())
bre_brett_bymon
bre_brett_bymon$chron <- c(1810,1811,1812,1807,1808,1809,1901,1902,1903,1904,1905,NA,1906)
bre_brett_bymon <- bre_brett_bymon[c(1:11),]

bre_brett_append <- c("2019-6",0,1806)
bre_brett_bymon <- rbind(bre_brett_bymon,bre_brett_append)

bre_brett_bymon$chron <- as.numeric(bre_brett_bymon$chron)
bre_brett_bymon$n <- as.numeric(bre_brett_bymon$n)

ggplot(bre_brett_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
  geom_point() + geom_line()


## ----thinkprogress-------------------------------------------------------
names(thinkprogress_df)
# corpus of just topic tags 
thi_docs <- corpus(thinkprogress_df$topic_tags)
thi_dfm <- dfm(thi_docs,
               remove=stopwords("english"),
               stem=TRUE,remove_punct=TRUE)
topfeatures(thi_dfm,200)

# full corpus by topic- immigration 
thi_immigr <- thinkprogress_df[grep("Immigr|Bord",thinkprogress_df$topic_tags),]
thi_immigr_docs <- corpus(thi_immigr)
thi_immigr_dfm <- dfm(thi_immigr_docs,
                      remove=stopwords("english"),
                      stem=TRUE,remove_punct=TRUE) 

# dfm to df, add date vars 
thi_immigr <- docvars(thi_immigr_dfm)
thi_immigr$month <- month(thi_immigr$datetime)
thi_immigr$year <- year(thi_immigr$datetime)
thi_immigr$moyr <- paste(thi_immigr$year,thi_immigr$month,sep="-")

# coverage of immigrant by month 
thi_immigr_bymon <- thi_immigr %>% 
  group_by(moyr) %>% 
  summarize(n=n())
thi_immigr_bymon
thi_immigr_bymon$chron <- c(1810,1811,1812,1805,1806,1807,1808,1809,1901,1902,1903,1904,1905)

ggplot(thi_immigr_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
  geom_point() + geom_line()

# mueller report 
thi_mueller <- thinkprogress_df[grep("Mueller",thinkprogress_df$topic_tags),]
thi_mueller_docs <- corpus(thi_mueller)
thi_mueller_dfm <- dfm(thi_mueller_docs,
                      remove=stopwords("english"),
                      stem=TRUE,remove_punct=TRUE) 

# dfm to df, add date vars 
thi_mueller <- docvars(thi_mueller_dfm)
thi_mueller$month <- month(thi_mueller$datetime)
thi_mueller$year <- year(thi_mueller$datetime)
thi_mueller$moyr <- paste(thi_mueller$year,thi_mueller$month,sep="-")

# coverage of MUELLER by month 
thi_mueller_bymon <- thi_mueller %>% 
  group_by(moyr) %>% 
  summarize(n=n())
thi_mueller_bymon
thi_mueller_bymon$chron <- c(1810,1811,1812,1805,1806,1807,1808,1809,1901,1902,1903,1904,1905)

ggplot(thi_mueller_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
  geom_point() + geom_line()

# Brett Kavanaugh 
thi_brett <- thinkprogress_df[grep("Brett|Kavanaugh",thinkprogress_df$topic_tags),]
thi_brett_docs <- corpus(thi_brett)
thi_brett_dfm <- dfm(thi_brett_docs,
                      remove=stopwords("english"),
                      stem=TRUE,remove_punct=TRUE) 

# dfm to df, add date vars 
thi_brett <- docvars(thi_brett_dfm)
thi_brett$month <- month(thi_brett$datetime)
thi_brett$year <- year(thi_brett$datetime)
thi_brett$moyr <- paste(thi_brett$year,thi_brett$month,sep="-")

# coverage of BRETT KAVANAUGH by month 
thi_brett_bymon <- thi_brett %>% 
  group_by(moyr) %>% 
  summarize(n=n())
thi_brett_bymon
thi_brett_bymon$chron <- c(1810,1811,1812,1807,1808,1809,1901,1902,1903,1904,1905)

ggplot(thi_brett_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
  geom_point() + geom_line()


## ----washington post-----------------------------------------------------
names(washingtonpost_df)

# corpus of just topic tags 
wp_docs <- corpus(washingtonpost_df$topic_tags)
wp_dfm <- dfm(wp_docs,
               remove=stopwords("english"),
               stem=TRUE,remove_punct=TRUE)
topfeatures(wp_dfm,200)

# mueller report 
wp_mueller <- washingtonpost_df[grep("Mueller",washingtonpost_df$topic_tags),]
wp_mueller_docs <- corpus(wp_mueller)
wp_mueller_dfm <- dfm(wp_mueller_docs,
                      remove=stopwords("english"),
                      stem=TRUE,remove_punct=TRUE) 

# dfm to df, add date vars 
wp_mueller <- docvars(wp_mueller_dfm)
wp_mueller$month <- month(wp_mueller$datetime)
wp_mueller$year <- year(wp_mueller$datetime)
wp_mueller$moyr <- paste(wp_mueller$year,wp_mueller$month,sep="-")

# coverage of mueller by month 
wp_mueller_bymon <- wp_mueller %>% 
  group_by(moyr) %>% 
  summarize(n=n())
wp_mueller_bymon
wp_mueller_bymon$chron <- c(1810,1811,1812,1805,1806,1807,1808,1809,1901,1902,1903,1904,1905,NA)
wp_mueller_bymon <- wp_mueller_bymon[1:13,]

ggplot(wp_mueller_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
  geom_point() + geom_line()

# brett
wp_brett <- washingtonpost_df[grep("Brett|Kavanaugh",washingtonpost_df$topic_tags),]
wp_brett_docs <- corpus(wp_brett)
wp_brett_dfm <- dfm(wp_brett_docs,
                      remove=stopwords("english"),
                      stem=TRUE,remove_punct=TRUE) 

# dfm to df, add date vars 
wp_brett <- docvars(wp_brett_dfm)
wp_brett$month <- month(wp_brett$datetime)
wp_brett$year <- year(wp_brett$datetime)
wp_brett$moyr <- paste(wp_brett$year,wp_brett$month,sep="-")

# coverage of brett by month 
wp_brett_bymon <- wp_brett %>% 
  group_by(moyr) %>% 
  summarize(n=n())
wp_brett_bymon
wp_brett_bymon$chron <- c(1810,1811,1812,1805,1806,1807,1808,1809,1901,1902,1903,1904,1905,NA)
wp_brett_bymon <- wp_brett_bymon[1:13,]

ggplot(wp_brett_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
  geom_point() + geom_line()


## ----infowars------------------------------------------------------------
names(infowars_df)

# corpus of just headlines 
info_docs <- corpus(infowars_df$headline)
info_dfm <- dfm(info_docs,
                remove=stopwords("english"),
                stem=TRUE,remove_punct=TRUE)
topfeatures(info_dfm,200)

# mueller report 
info_mueller <- infowars_df[grep("Mueller",infowars_df$headline),]
info_mueller_docs <- corpus(info_mueller)
info_mueller_dfm <- dfm(info_mueller_docs,
                       remove=stopwords("english"),
                       stem=TRUE,remove_punct=TRUE)

# dfm to df, add date vars 
info_mueller <- docvars(info_mueller_dfm)
info_mueller$month <- month(info_mueller$datetime)
info_mueller$year <- year(info_mueller$datetime)
info_mueller$moyr <- paste(info_mueller$year,info_mueller$month,sep="-")

# group_by() for mueller 
info_mueller_bymon <- info_mueller %>% 
  group_by(moyr) %>% 
  summarize(n=n())
info_mueller_bymon
info_mueller_bymon$chron <- c(1810,1811,1812,1805,1806,1807,1808,1809,1901,1902,1903,1904,1905,NA)
info_mueller_bymon <- info_mueller_bymon[c(1:13),] # get rid of NA

ggplot(info_mueller_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
   geom_line() + geom_point()

# brett kavanaugh
info_brett <- infowars_df[grep("Brett|Kavanaugh",infowars_df$headline),]
info_brett_docs <- corpus(info_brett)
info_brett_dfm <- dfm(info_brett_docs,
                       remove=stopwords("english"),
                       stem=TRUE,remove_punct=TRUE)

# dfm to df, add date vars 
info_brett <- docvars(info_brett_dfm)
info_brett$month <- month(info_brett$datetime)
info_brett$year <- year(info_brett$datetime)
info_brett$moyr <- paste(info_brett$year,info_brett$month,sep="-")

# group_by() for brett
info_brett_bymon <- info_brett %>% 
  group_by(moyr) %>% 
  summarize(n=n())
info_brett_bymon
info_brett_bymon$chron <- c(1810,1811,1812,1807,1808,1809,1902,1904)

moyr <- c("2019-1","2019-3","2019-5")
n <- c(rep(0,3))
chron <- c(1901,1903,1905)

brett_append <- cbind(moyr,n,chron)
info_brett_bymon <- rbind(info_brett_bymon,brett_append)

info_brett_bymon$n <- as.numeric(info_brett_bymon$n)
info_brett_bymon$chron <- as.numeric(info_brett_bymon$chron)

ggplot(info_brett_bymon,aes(x=reorder(moyr,chron),y=n,group=1)) + 
   geom_line() + geom_point()


## ----combine figs for project proposal-----------------------------------
# mueller report ts 
mueller_bymon <- rbind(nyt_mueller_bymon,
                       fox_mueller_bymon,
                       bre_mueller_bymon,
                       thi_mueller_bymon,
                       wp_mueller_bymon,
                       info_mueller_bymon)

mueller_bymon$moyr1 <- as.factor(mueller_bymon$moyr)
levels(mueller_bymon$moyr1) <- c("Oct 2018",
                                 "Nov 2018",
                                 "Dec 2018",
                                 "May 2018",
                                 "Jun 2018",
                                 "Jul 2018",
                                 "Aug 2018",
                                 "Sep 2018",
                                 "Jan 2019",
                                 "Feb 2019",
                                 "Mar 2019",
                                 "Apr 2019",
                                 "May 2019",
                                 "June 2019")

mueller_bymon$Outlet <- c(rep("New York Times",13),
                          rep("Fox News",13),
                          rep("Breitbart News",13),
                          rep("Think Progress",13),
                          rep("Washington Post",13),
                          rep("Info Wars",13))
mueller_plot <- ggplot(mueller_bymon,aes(x=reorder(moyr1,chron),y=n,group=Outlet,color=Outlet)) + 
  geom_point() + geom_line() + scale_color_brewer(palette="Set2") + 
  theme(axis.text.x=element_text(angle=90,hjust=1),
        plot.title=element_text(hjust=.5),
        legend.title=element_blank()) + 
  labs(x="",y="# Articles",title="Mueller Report")

# brett kavanaugh
brett_bymon <- rbind(nyt_brett_bymon,
                     fox_brett_bymon,
                     bre_brett_bymon,
                     thi_brett_bymon,
                     wp_brett_bymon,
                     info_brett_bymon)

brett_bymon$moyr1 <- as.factor(brett_bymon$moyr)
levels(brett_bymon$moyr1) <- c("Oct 2018",
                               "Nov 2018",
                               "Dec 2018",
                               "May 2018",
                               "Jun 2018",
                               "Jul 2018",
                               "Aug 2018",
                               "Sep 2018",
                               "Jan 2019",
                               "Feb 2019",
                               "Mar 2019",
                               "Apr 2019",
                               "May 2019")

brett_bymon$Outlet <- c(rep("New York Times",12),
                          rep("Fox News",13),
                          rep("Breitbart News",11),
                          rep("Think Progress",11),
                          rep("Washington Post",13),
                          rep("Info Wars",11))

brett_plot <- ggplot(brett_bymon,aes(x=reorder(moyr1,chron),y=n,group=Outlet,color=Outlet)) + 
  geom_point() + geom_line() + scale_color_brewer(palette="Set2") + 
  theme(axis.text.x=element_text(angle=90,hjust=1),
        plot.title=element_text(hjust=.5),
        legend.title=element_blank()) + 
  labs(x="",y="",title="Brett Kavanaugh")

png(file="mueller_brett_plots.png",width=700,height=350,res=72)
ggarrange(mueller_plot,brett_plot,common.legend=TRUE)
dev.off()

