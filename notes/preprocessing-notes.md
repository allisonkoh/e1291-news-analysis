Data sets labelled by right, lean right, center, lean left, left

## Breakdown by outlet

- 41k on the right
- 32k on the left
- 67k on the lean right
- 238k on the lean left
- 53k on the center

## Outlets to remove
- Buzzfeed
- USA Today
- Bloomberg
as they do not encompass the full set of data spanning the year

## Headlines
- Remove punctuation
- Remove hyphens
- Lowercase
- Remove stopwords
- Stemming


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

#convert back to df
df.w <- as.data.frame(dfm.w)

df_ideo <- cbind(df.w, us_news_train$ideology)
names(df_ideo)[8443] <- "class_ideology"
df_ideo <- df_ideo[,2:8443]

summary(glm(class_ideology ~ ., family=binomial, data=df_ideo))
