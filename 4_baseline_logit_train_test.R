# relevant packages 
library(dplyr)
library(magrittr)
library(quanteda)
library(caret)
library(e1071)

# load training set 
data_dir = "../newspaper-data/"
load(paste0(data_dir, "us_news_train.rda"))
load(paste0(data_dir, "us_news_test.rda"))

# for reproducibility 
set.seed(1984)

# creating training matrix
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

#Removing any digits. `dfm` picks up any separated digits, not digits that are part of tokens.
#Removing any punctuation. `dfm` picks up any punctuation unless it's part of a token.
#Removing any tokens less than four characters.
dfm.m <- dfm_select(dfm, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                    valuetype="regex", verbose = TRUE)


# creating test matrix
test_headline_corpus <- corpus(us_news_test, text_field = "headline") 

tok_test <- tokens(test_headline_corpus, what = "word",
                   remove_punct = TRUE,
                   remove_hyphens = TRUE,
                   verbose = TRUE)

dfm_test <- dfm(tok_test, 
                tolower = TRUE,
                remove=stopwords("english"),
                stem=TRUE, 
                verbose = TRUE)

#Removing any digits. `dfm` picks up any separated digits, not digits that are part of tokens.
#Removing any punctuation. `dfm` picks up any punctuation unless it's part of a token.
#Removing any tokens less than four characters.
dfm.m_test <- dfm_select(dfm_test, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                         valuetype="regex", verbose = TRUE)

# Matching features from training and test

dfm_matched <- dfm_match(dfm.m_test,features=featnames(dfm.m))
actual_class <- docvars(dfm.m_test,"ideology")
testmod_nb <- textmodel_nb(dfm.m, docvars(dfm.m, "ideology"), distribution = "multinomial")
predicted_class <- predict(testmod_nb,newdata=dfm_matched)
tab_class <- table(actual_class,predicted_class)

confusionMatrix(tab_class,mode="everything")