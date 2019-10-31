# Cleaning text in R (this is not done yet, but thought to commit a working session, so we are not all doing the same thing)
#-	Remove emojis, symbols 
#-	Outlet & names (e.g. Breitbart) in headlines -> Sebastians part, but I will also try to find a solution tommorrow
#-	URLs
#-	Remove @ and #
#-	Remove stopwords

# Do we want to stem?

#in Python
#- normalize contraction
#- Spellcheck


#set wd
setwd("C:/Users/phili/Documents/Hertie/Courses/Introduction to Machine Learning")


#load data
load("C:/Users/phili/Documents/Hertie/Courses/Introduction to Machine Learning/news-analysis/us_raw_df.rda")

#packages
library(tm)
library(lattice)
library(ggplot2)

# Create variable for article text length
us_raw_df$textlength <- nchar(us_raw_df$text)
ggplot(us_raw_df, aes(textlength)) + geom_histogram(binwidth = 6) # fit axis later


#Create corpus
us_corpus <- Corpus(VectorSource(us_raw_df$text))
View(us_corpus)
print(us_corpus)
inspect(us_corpus[1:10])

# clean corpus
clean_us_corpus <- tm_map(us_corpus, tolower)
clean_us_corpus <- tm_map(clean_us_corpus, removePunctuation)
clean_us_corpus <- tm_map(clean_us_corpus, removeWords, stopwords("english"))  # do we want to remove stopwords?


inspect(clean_us_corpus [1:5])

#remove all non ASCII characters like emojis or symbols (does not stop running on my machine)
# gsub("[^\x01-\x7F]", "", clean_us_corpus) # base R option 

x <- "a1~!@#$%^&*(){}_+:\"<>?,./;'[]-=" #stringr option
str_replace_all(x, "[[:punct:]]", " ")

#remove urls from corpus
gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", clean_us_corpus)
clean(clean_us_corpus, removeURL=TRUE)

clean_us_corpus <- tm_map(clean_us_corpus, stripWhitespace)

# clean_us_corpus <- tm_map(clean_us_corpus, stemDocument) reasonable to stem?

