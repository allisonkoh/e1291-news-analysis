# relevant packages 
library(dplyr)
library(magrittr)
library(readr)
library(stringr)
library(quanteda)
library(caret)
library(e1071)

# load training set 
us_news_train <- read_csv("us_news_train.csv")

# load test set 
us_news_test <- read_csv("us_news_test.csv")

# repeat pre-processing training set 
set.seed(1984)
headline_corpus <- corpus(us_news_train, text_field = "headline") 

tok <- tokens(headline_corpus, what = "word",
               remove_punct = TRUE,
               remove_hyphens = TRUE,
               verbose = TRUE)

dfm <- dfm(tok, 
            tolower = TRUE,
            remove=stopwords("english"),
            stem=TRUE, 
            verbose = TRUE)

dfm.m <- dfm_select(dfm, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                     valuetype="regex", verbose = TRUE)

dfm.trim <- dfm_trim(dfm.m,min_termfreq = 5,min_docfreq = 3)

dfm.w <- dfm_tfidf(dfm.trim)

# repreat pre-processing test set 
set.seed(1984)
headline_corpus1 <- corpus(us_news_test, text_field = "headline")

tok1 <- tokens(headline_corpus1, what = "word",
               remove_punct = TRUE,
               remove_hyphens = TRUE,
               verbose = TRUE)

dfm1 <- dfm(tok1, 
           tolower = TRUE,
           remove = stopwords("english"), 
           stem = TRUE,
           verbose = TRUE)

dfm1.m <- dfm_select(dfm1, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                     valuetype="regex", verbose = TRUE)

dfm1.trim <- dfm_trim(dfm1.m, min_termfreq = 5, min_docfreq = 3)

dfm1.w <- dfm_tfidf(dfm1.trim)

# pre-process validation set for testing model performance before running the full model 
set.seed(1984)

us_news_validation <- us_news_validation %>%
  dplyr::rename_all(
    funs(stringr::str_replace_all(., "validate.", ""))
  )

headline_corpus2 <- corpus(us_news_validation, text_field = "headline")

tok2 <- tokens(headline_corpus2, what = "word",
               remove_punct = TRUE,
               remove_hyphens = TRUE,
               verbose = TRUE)

dfm2 <- dfm(tok2, 
            tolower = TRUE,
            remove = stopwords("english"), 
            stem = TRUE,
            verbose = TRUE)

dfm2.m <- dfm_select(dfm2, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                     valuetype="regex", verbose = TRUE)

dfm2.trim <- dfm_trim(dfm2.m, min_termfreq = 5, min_docfreq = 3)

dfm2.w <- dfm_tfidf(dfm2.trim)

# model 
dfm_matched1 <- dfm_match(dfm.trim,features=featnames(dfm2.trim))
textmod_nb <- textmodel_nb(dfm.trim, smooth=0.5, docvars(dfm.trim,"ideology"), distribution = "multinomial")
predicted_class1 <- predict(textmod_nb,newdata=dfm.trim)
actual_class <- docvars(dfm2.trim,"ideology")

summary(dfm_matched)
tab_class1 <- table(actual_class,predicted_class1)

summary(actual_class)

confusionMatrix(tab_class1,mode="everything")

#----------Trying again with evenly matched dev sets taken from train-------------------------------------------------#
set.seed(1984)
us_news_dev <- us_news_train %>% group_by(ideology) %>% sample_n(2000)

headline_corpus3 <- corpus(us_news_dev, text_field = "headline")

tok3 <- tokens(headline_corpus3, what = "word",
               remove_punct = TRUE,
               remove_hyphens = TRUE,
               verbose = TRUE)

dfm3 <- dfm(tok3, 
            tolower = TRUE,
            remove = stopwords("english"), 
            stem = TRUE,
            verbose = TRUE)

dfm3.m <- dfm_select(dfm3, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                     valuetype="regex", verbose = TRUE)

dfm3.trim <- dfm_trim(dfm3.m, min_termfreq = 5, min_docfreq = 3)

dfm3.w <- dfm_tfidf(dfm3.trim)
#---------------------------------------------------------------------------------------------------------------------#

# model with dev and validation sets 
dfm_matched2 <- dfm_match(dfm2.trim,features=featnames(dfm3.trim))
textmod_nb1 <- textmodel_nb(dfm2.trim, smooth=0.5, docvars(dfm2.trim,"ideology"), distribution = "multinomial")
predicted_class1 <- predict(textmod_nb1,newdata=dfm2.trim)
actual_class <- docvars(dfm3.trim,"ideology")
tab_class1 <- table(actual_class,predicted_class1)

confusionMatrix(tab_class1,mode="everything")

predicted_class1 <- as.character(predicted_class1)
logit_df <- data.frame(cbind(predicted_class1,actual_class))

write_csv(logit_df,"/Users/allisonwun-huikoh/Documents/GitHub/e1291-news-analysis/logit_df.csv")
