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

sapply(res, nrow)/nrow(us_news_df)
addmargins(prop.table(table(g)))

