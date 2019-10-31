## DATA MERGING FOR GERMANY ----------------

# set wd
setwd("/Volumes/Sebastian/framing-project")

library(tidyverse)

## loading data sets (one-by-one) | computer kept on crashing when requesting all of them

load("newspaper-data/abendblatt_to_may_2019.RDa")
load("newspaper-data/bild_to_may_2019.RDa")
load("newspaper-data/faz_to_may_2019.RDa")
load("newspaper-data/focus_to_may_2019.RDa")
load("newspaper-data/freitag_to_may_2019.RDa")
load("newspaper-data/gmx_to_may_2019.RDa")
load("newspaper-data/handelsblatt_to_may_2019.RDa")
load("newspaper-data/jungefreiheit_to_may_2019.RDa")
load("newspaper-data/spiegel_to_may_2019.RDa")
load("newspaper-data/stuttgarter_to_may_2019.RDa")
load("newspaper-data/sueddeutsche_to_may_2019.RDa")
load("newspaper-data/tagesspiegel_to_may_2019.RDa")
load("newspaper-data/tonline_to_may_2019.RDa")
load("newspaper-data/webde_to_may_2019.RDa")
load("newspaper-data/welt_to_may_2019.RDa")
load("newspaper-data/yahoode_to_may_2019.RDa")
load("newspaper-data/zeit_to_may_2019.RDa")

## joining DFs (one-by-one) | computer kept on crashing when merging all of them

ger_raw_df = full_join(abendblatt_df, bild_df)
ger_raw_df = full_join(ger_raw_df, faz_df)
ger_raw_df = full_join(ger_raw_df, focus_df)
ger_raw_df = full_join(ger_raw_df, freitag_df)
ger_raw_df = full_join(ger_raw_df, gmx_df)
ger_raw_df = full_join(ger_raw_df, handelsblatt_df)
ger_raw_df = full_join(ger_raw_df, jungefreiheit_df)
ger_raw_df = full_join(ger_raw_df, spiegel_df)
ger_raw_df = full_join(ger_raw_df, stuttgarter_df)
ger_raw_df = full_join(ger_raw_df, sueddeutsche_df)
ger_raw_df = full_join(ger_raw_df, tagesspiegel_df)
ger_raw_df = full_join(ger_raw_df, tonline_df)
ger_raw_df = full_join(ger_raw_df, webde_df)
ger_raw_df = full_join(ger_raw_df, welt_df)
ger_raw_df = full_join(ger_raw_df, yahoode_df)
ger_raw_df = full_join(ger_raw_df, zeit_df)

## save the new DF for Germany.
save(ger_raw_df, file = "newspaper-data/ger_raw_df.rda")