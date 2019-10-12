## ----[3] toy-------------------------------------------------------------
# relevant packages 
library(dplyr)
library(magrittr)
library(quanteda)
library(caret)

# load training set 
load("/Volumes/My Passport for Mac/___hertie/2019-fall/e1291-ml/us_news_train.rda")

# for reproducibility 
set.seed(1984)

us_toy_df <- us_df %>% group_by(ideology) %>% sample_n(20)

headline_corpus <- corpus(us_toy_df, text_field = "headline") 

tok <- tokens(headline_corpus, what = "word",
              remove_punct = TRUE,
              remove_hyphens = TRUE,
              verbose = TRUE)

dfm <- dfm(tok, 
           tolower = TRUE,
           remove=stopwords("english"),
           stem=TRUE, 
           verbose = TRUE)

#Removing any digits. `dfm` picks up any separated digits, not digits that are part of tokens.
#Removing any punctuation. `dfm` picks up any punctuation unless it's part of a token.
#Removing any tokens less than four characters.
dfm.m <- dfm_select(dfm, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                    valuetype="regex", verbose = TRUE)

#Dropping words that appear less than 5 times and in less than 3 documents.
# dfm.trim <- dfm_trim(dfm.m, min_termfreq = 5, min_docfreq = 3)

# tfidf weighting
# dfm.w <- dfm_tfidf(dfm.trim)

#-----------------

us_toy_df1 <- us_df %>% group_by(ideology) %>% sample_n(20)


headline_corpus1 <- corpus(us_toy_df1, text_field = "headline") 

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

dfm_matched <- dfm_match(dfm1.m,features=featnames(dfm.m))
actual_class <- docvars(dfm.m,"ideology")
predicted_class <- predict(testmod_nb,newdata=dfm_matched)
tab_class <- table(actual_class,predicted_class)

confusionMatrix(tab_class,mode="everything")