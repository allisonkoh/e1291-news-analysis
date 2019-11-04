# load dataset 
data_dir <- "../newspaper-data/"
load(paste0(data_dir, "us_df.RDa"))

set.seed(1984) # for reproducibility

## taking random sample of 20k from each ideology
us_news_df = us_df %>% group_by(ideology) %>% sample_n(20000)

## splitting into training, validation and test sets
spec = c(train = .8, test = .1, validate = .1)

g = sample(cut(
  seq(nrow(us_news_df)), 
  nrow(us_news_df)*cumsum(c(0,spec)),
  labels = names(spec)
))

res = split(us_news_df, g)

## check split results 
sapply(res, nrow)/nrow(us_news_df)
addmargins(prop.table(table(g)))

## rename column names
us_news_train <- as.data.frame(res[1])
us_news_test <- as.data.frame(res[2])
us_news_validation <- as.data.frame(res[3])

colnames(us_news_train) = gsub("train\\.", "", colnames(us_news_train))
colnames(us_news_test) = gsub("test\\.", "", colnames(us_news_test))
colnames(us_news_validation) = gsub("validation\\.", "", colnames(us_news_validation))

##save dfs
save(us_news_train, file = paste0(data_dir,"us_news_train.rda"))
save(us_news_test, file = paste0(data_dir,"us_news_test.rda"))
save(us_news_validation, file = paste0(data_dir,"us_news_validation.rda"))