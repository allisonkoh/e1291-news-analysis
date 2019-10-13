## ----[3] test set pre-processing for baseline model----------------------
# load packages 
library(dplyr)
library(magrittr)
library(quanteda)

# load test set 
load("/Volumes/My Passport for Mac/___hertie/2019-fall/e1291-ml/us_news_test.rda")

# for reproducibility 
set.seed(1984)

headline_corpus1 <- corpus(us_news_test, text_field = "headline") 

tok1 <- tokens(headline_corpus1, what = "word",
              remove_punct = TRUE,
              remove_hyphens = TRUE,
              verbose = TRUE)

dfm1 <- dfm(tok1, 
           tolower = TRUE,
           remove=stopwords("english"),
           stem=TRUE, 
           verbose = TRUE)

#Removing any digits. `dfm` picks up any separated digits, not digits that are part of tokens.
#Removing any punctuation. `dfm` picks up any punctuation unless it's part of a token.
#Removing any tokens less than four characters.
dfm1.m <- dfm_select(dfm1, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                    valuetype="regex", verbose = TRUE)

#Dropping words that appear less than 5 times and in less than 3 documents.
dfm1.trim <- dfm_trim(dfm1.m, min_termfreq = 5, min_docfreq = 3)

# tfidf weighting
dfm1.w <- dfm_tfidf(dfm1.trim)

#convert back to df
df1.w <- as.data.frame(dfm1.w)

df1_ideo <- cbind(df1.w, us_news_test$ideology)
ncol(df1.w)
ncol(df1_ideo)
names(df1_ideo)[2729] <- "class_ideology"
df1_ideo <- df1_ideo[,2:2729]
table(df1_ideo$class_ideology)
save(df1_ideo,file="/Volumes/My Passport for Mac/___hertie/2019-fall/e1291-ml/df_ideo_test.RDa")