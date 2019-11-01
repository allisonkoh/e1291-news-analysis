## DATA MERGING FOR U.S. ----------------
library(tidyverse)

data_dir = "../newspaper-data/"

## loading data sets

load(paste0(data_dir, "abcnews_to_may_2019.RDa"))
load(paste0(data_dir, "bbcnews_to_may_2019.RDa"))
load(paste0(data_dir, "bloomberg_to_may_2019.RDa"))
load(paste0(data_dir, "breitbart_to_may_2019.RDa"))
load(paste0(data_dir, "buzzfeed_to_may_2019.RDa"))
load(paste0(data_dir, "cnbc_to_may_2019.RDa"))
load(paste0(data_dir, "dailykos_to_may_2019.RDa"))
load(paste0(data_dir, "foxnews_to_may_2019.RDa"))
load(paste0(data_dir, "guardian_to_may_2019.RDa"))
load(paste0(data_dir, "huffingtonpost_to_may_2019.RDa"))
load(paste0(data_dir, "infowars_to_may_2019.RDa"))
load(paste0(data_dir, "motherjones_to_may_2019.RDa"))
load(paste0(data_dir, "newsweek_to_may_2019.RDa"))
load(paste0(data_dir, "nytimes_to_may_2019.RDa"))
load(paste0(data_dir, "politico_to_may_2019.RDa"))
load(paste0(data_dir, "thehill_to_may_2019.RDa"))
load(paste0(data_dir, "thinkprogress_to_may_2019.RDa"))
load(paste0(data_dir, "townhall_to_may_2019.RDa"))
load(paste0(data_dir, "usatoday_to_may_2019.RDa"))
load(paste0(data_dir, "vice_to_may_2019.RDa"))
load(paste0(data_dir, "washingtonpost_to_may_2019.RDa"))
load(paste0(data_dir, "wsj_to_may_2019.RDa"))
load(paste0(data_dir, "yahoous_to_may_2019.RDa"))

## joining DFs

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

## save the raw for U.S.
save(us_raw_df, file = (paste0(data_dir, "us_raw_df.rda"))) 
