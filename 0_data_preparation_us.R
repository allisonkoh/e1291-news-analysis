## DATA MERGING FOR U.S. ----------------

## set wd

setwd("/Volumes/Sebastian/framing-project")

library(tidyverse)

## loading data sets (one-by-one) | computer kept on crashing when requesting all of them

load("newspaper-data/abcnews_to_may_2019.RDa")
load("newspaper-data/bbcnews_to_may_2019.RDa")
load("newspaper-data/bloomberg_to_may_2019.RDa")
load("newspaper-data/breitbart_to_may_2019.RDa")
load("newspaper-data/buzzfeed_to_may_2019.RDa")
load("newspaper-data/cnbc_to_may_2019.RDa")
load("newspaper-data/dailykos_to_may_2019.RDa")
load("newspaper-data/foxnews_to_may_2019.RDa")
load("newspaper-data/guardian_to_may_2019.RDa")
load("newspaper-data/huffingtonpost_to_may_2019.RDa")
load("newspaper-data/infowars_to_may_2019.RDa")
load("newspaper-data/motherjones_to_may_2019.RDa")
load("newspaper-data/newsweek_to_may_2019.RDa")
load("newspaper-data/nytimes_to_may_2019.RDa")
load("newspaper-data/politico_to_may_2019.RDa")
load("newspaper-data/thehill_to_may_2019.RDa")
load("newspaper-data/thinkprogress_to_may_2019.RDa")
load("newspaper-data/townhall_to_may_2019.RDa")
load("newspaper-data/usatoday_to_may_2019.RDa")
load("newspaper-data/vice_to_may_2019.RDa")
load("newspaper-data/washingtonpost_to_may_2019.RDa")
load("newspaper-data/wsj_to_may_2019.RDa")
load("newspaper-data/yahoous_to_may_2019.RDa")

## joining DFs (one-by-one) | computer kept on crashing when merging all of them

us_raw_df = full_join(abcnews_df, bbcnews_df)
us_raw_df = full_join(us_raw_df, bloomberg_df)
us_raw_df = full_join(us_raw_df, breitbart_df)
us_raw_df = full_join(us_raw_df, buzzfeed_df)
us_raw_df = full_join(us_raw_df, cnbc_df)
us_raw_df = full_join(us_raw_df, dailykos_df)
us_raw_df = full_join(us_raw_df, foxnews_df)
us_raw_df = full_join(us_raw_df, guardian_df)
us_raw_df = full_join(us_raw_df, huffingtonpost_df)
us_raw_df = full_join(us_raw_df, infowars_df)
us_raw_df = full_join(us_raw_df, motherjones_df)
us_raw_df = full_join(us_raw_df, newsweek_df)
us_raw_df = full_join(us_raw_df, nytimes_df)
us_raw_df = full_join(us_raw_df, politico_df)
us_raw_df = full_join(us_raw_df, thehill_df)
us_raw_df = full_join(us_raw_df, thinkprogress_df)
us_raw_df = full_join(us_raw_df, townhall_df)
us_raw_df = full_join(us_raw_df, usatoday_df)
us_raw_df = full_join(us_raw_df, washingtonpost_df)
us_raw_df = full_join(us_raw_df, wsj_df)
us_raw_df = full_join(us_raw_df, yahoous_df)

## save the new DF for U.S.
save(us_raw_df, file = "newspaper-data/us_raw_df.rda")

