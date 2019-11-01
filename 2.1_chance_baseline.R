## Chance baseline

library(tidyverse)
library(caret)

# load data
data_dir <- "../newspaper-data/"
load(paste0(data_dir, "us_news_test.rda"))

set.seed(1984) # for reproducibility 

id_order = c("left", "leanleft", "center", "leanright", "right")

# chance draw
chance_class = sample(rep(id_order,2000),size=10000,replace=FALSE)

# actual class
actual_class = us_news_test$ideology

# confusion matrix
chance_matrix = table(factor(chance_class, levels = id_order), actual_class)
confusionMatrix(chance_matrix, mode = "everything")