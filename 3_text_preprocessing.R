library(quanteda)

# load dataset 
data_dir = "../newspaper-data/"
load(paste0(data_dir, "us_news_train.rda"))

set.seed(1984) # for reproducibility

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

#Dropping words that appear less than 5 times and in less than 3 documents.
dfm.trim <- dfm_trim(dfm.m, min_termfreq = 5, min_docfreq = 3)

#tfidf weighting
dfm.w <- dfm_tfidf(dfm.trim)

