## Naive Bayes and Logistic Regression - headlines, RSS description, full-text
library(tidyverse)
library(quanteda)
library(caret)
library(e1071)
library(glmnet)

# load training set 
data_dir = "../newspaper-data/"
load(paste0(data_dir, "us_news_train.rda"))
load(paste0(data_dir, "us_news_test.rda"))
load(paste0(data_dir, "us_news_validation.rda"))

set.seed(1984) # for reproducibility 

# factor order
id_order = c("left", "leanleft", "center", "leanright", "right")

#### Creating document-feature matrices -----------------------------

### Headlines ----

## creating headline training matrix 
tr_hl_corpus = corpus(us_news_train, text_field = "headline") 

tr_hl_tok = tokens(tr_hl_corpus, what = "word",
                   remove_punct = TRUE,
                   remove_hyphens = TRUE,
                   verbose = TRUE)

tr_hl_ft = dfm(tr_hl_tok, 
               tolower = TRUE,
               remove=stopwords("english"),
               stem=TRUE, 
               verbose = TRUE) 

tr_hl_sl = dfm_select(tr_hl_ft, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                      valuetype="regex", verbose = TRUE)

# trim dfm for tokens present in at least 0.01% of documents
tr_hl_trim = dfm_trim(tr_hl_sl, min_docfreq = 0.001, max_docfreq = .05, docfreq_type = "prop")

# obtaining tf-idf
tr_hl_tfidf = dfm_tfidf(tr_hl_trim)

## creating headline test matrix
tst_hl_corpus <- corpus(us_news_test, text_field = "headline") 

tst_hl_tok <- tokens(tst_hl_corpus, what = "word",
                     remove_punct = TRUE,
                     remove_hyphens = TRUE,
                     verbose = TRUE)

tst_hl_ft <- dfm(tst_hl_tok, 
                 tolower = TRUE,
                 remove=stopwords("english"),
                 stem=TRUE, 
                 verbose = TRUE)

tst_hl_sl <- dfm_select(tst_hl_ft, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                        valuetype="regex", verbose = TRUE)

tst_hl_tfidf <- dfm_tfidf(tst_hl_sl)

# coercing headline test dfm to train dimensions
tst_hl_coerced = dfm_match(tst_hl_sl,features=featnames(tr_hl_trim))
tst_hl_coerced_tfidf = dfm_match(tst_hl_tfidf,features=featnames(tr_hl_tfidf))

### Description  ----

## creating description training matrix 
tr_dsc_corpus = corpus(us_news_train, text_field = "description") 

tr_dsc_tok = tokens(tr_dsc_corpus, what = "word",
                    remove_punct = TRUE,
                    remove_hyphens = TRUE,
                    verbose = TRUE)

tr_dsc_ft = dfm(tr_dsc_tok, 
                tolower = TRUE,
                remove=stopwords("english"),
                stem=TRUE, 
                verbose = TRUE) 

tr_dsc_sl = dfm_select(tr_dsc_ft, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                       valuetype="regex", verbose = TRUE)

# trim dfm for tokens present in at least 0.01% of documents
tr_dsc_trim = dfm_trim(tr_dsc_sl, min_docfreq = 0.001, max_docfreq = .05, docfreq_type = "prop")

# obtaining tf-idf
tr_dsc_tfidf = dfm_tfidf(tr_dsc_trim)

## creating description test matrix
tst_dsc_corpus <- corpus(us_news_test, text_field = "description") 

tst_dsc_tok <- tokens(tst_dsc_corpus, what = "word",
                      remove_punct = TRUE,
                      remove_hyphens = TRUE,
                      verbose = TRUE)

tst_dsc_ft <- dfm(tst_dsc_tok, 
                  tolower = TRUE,
                  remove=stopwords("english"),
                  stem=TRUE, 
                  verbose = TRUE)

tst_dsc_sl <- dfm_select(tst_dsc_ft, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                         valuetype="regex", verbose = TRUE)

tst_dsc_tfidf <- dfm_tfidf(tst_dsc_sl)

# coercing description test dfm to train dimensions
tst_dsc_coerced = dfm_match(tst_dsc_sl,features=featnames(tr_dsc_trim))
tst_dsc_coerced_tfidf = dfm_match(tst_dsc_tfidf,features=featnames(tr_dsc_tfidf))

### Full-text  ----

## creating full text training matrix 
tr_txt_corpus = corpus(us_news_train, text_field = "text") 

tr_txt_tok = tokens(tr_txt_corpus, what = "word",
                    remove_punct = TRUE,
                    remove_hyphens = TRUE,
                    verbose = TRUE)

tr_txt_ft = dfm(tr_txt_tok, 
                tolower = TRUE,
                remove=stopwords("english"),
                stem=TRUE, 
                verbose = TRUE) 

tr_txt_sl = dfm_select(tr_txt_ft, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                       valuetype="regex", verbose = TRUE)

# trim dfm for tokens present in at least 0.01% of documents
tr_txt_trim = dfm_trim(tr_txt_sl, min_docfreq = 0.001, max_docfreq = .05, docfreq_type = "prop")

# obtaining tf-idf
tr_txt_tfidf = dfm_tfidf(tr_txt_trim)

## creating full text test matrix
tst_txt_corpus <- corpus(us_news_test, text_field = "text") 

tst_txt_tok <- tokens(tst_txt_corpus, what = "word",
                      remove_punct = TRUE,
                      remove_hyphens = TRUE,
                      verbose = TRUE)

tst_txt_ft <- dfm(tst_txt_tok, 
                  tolower = TRUE,
                  remove=stopwords("english"),
                  stem=TRUE, 
                  verbose = TRUE)

tst_txt_sl <- dfm_select(tst_txt_ft, c("[\\d-]", "[[:punct:]]", "^.{1,3}$"), selection = "remove", 
                         valuetype="regex", verbose = TRUE)

tst_txt_tfidf <- dfm_tfidf(tst_txt_sl)

# coercing full text test dfm to train dimensions
tst_txt_coerced = dfm_match(tst_txt_sl,features=featnames(tr_txt_trim))
tst_txt_coerced_tfidf = dfm_match(tst_txt_tfidf,features=featnames(tr_txt_tfidf))
