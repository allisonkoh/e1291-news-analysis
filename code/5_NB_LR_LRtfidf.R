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

#### Naive Bayes ---------------------------------------

actual_class = us_news_test$ideology

### Headlines
test_hl_nb <- textmodel_nb(tr_hl_trim, docvars(tr_hl_trim, "ideology"), distribution = "multinomial")
predicted_class_hl_nb <- predict(test_hl_nb,newdata=tst_hl_coerced)
tab_class_hl_nb <- table(actual_class,predicted_class_hl_nb)

result_nb_hl = confusionMatrix(tab_class_hl_nb,mode="everything")
result_nb_hl = data.frame(t(result_nb_hl$byClass))
result_nb_hl$Total = base::rowMeans(result_nb_hl)

### Description
test_dsc_nb <- textmodel_nb(tr_dsc_trim, docvars(tr_dsc_trim, "ideology"), distribution = "multinomial")
predicted_class_dsc_nb <- predict(test_dsc_nb,newdata=tst_dsc_coerced)
tab_class_dsc_nb <- table(actual_class,predicted_class_dsc_nb)

result_nb_dsc = confusionMatrix(tab_class_dsc_nb,mode="everything")
result_nb_dsc = data.frame(t(result_nb_dsc$byClass))
result_nb_dsc$Total = base::rowMeans(result_nb_dsc)

### Full-text
test_txt_nb <- textmodel_nb(tr_txt_trim, docvars(tr_txt_trim, "ideology"), distribution = "multinomial")
predicted_class_txt_nb <- predict(test_txt_nb,newdata=tst_txt_coerced)
tab_class_txt_nb <- table(actual_class,predicted_class_txt_nb)

result_nb_txt = confusionMatrix(tab_class_txt_nb,mode="everything")
result_nb_txt = data.frame(t(result_nb_txt$byClass))
result_nb_txt$Total = base::rowMeans(result_nb_txt)


#### Logistic Regression -------------------------------------

### Headlines
lr_hl = cv.glmnet(tr_hl_trim, docvars(tr_hl_trim, "ideology"), family="multinomial")
predicted_class_hl_lr <- predict(lr_hl,newx=tst_hl_coerced, type = "class")
tab_class_hl_lr <- table(actual_class, factor(predicted_class_hl_lr, levels = id_order))

result_lr_hl = confusionMatrix(tab_class_hl_lr,mode="everything")
result_lr_hl = data.frame(t(result_lr_hl$byClass))
result_lr_hl$Total = base::rowMeans(result_lr_hl)

### Description
lr_dsc = cv.glmnet(tr_dsc_trim, docvars(tr_dsc_trim, "ideology"), family="multinomial")
predicted_class_dsc_lr <- predict(lr_dsc,newx=tst_dsc_coerced, type = "class")
tab_class_dsc_lr <- table(actual_class, factor(predicted_class_dsc_lr, levels = id_order))

result_lr_dsc = confusionMatrix(tab_class_dsc_lr,mode="everything")
result_lr_dsc = data.frame(t(result_lr_dsc$byClass))
result_lr_dsc$Total = base::rowMeans(result_lr_dsc)

### Full-text
lr_txt = cv.glmnet(tr_txt_trim, docvars(tr_txt_trim, "ideology"), family="multinomial")
predicted_class_txt_lr <- predict(lr_txt,newx=tst_txt_coerced, type = "class")
tab_class_txt_lr <- table(actual_class, factor(predicted_class_txt_lr, levels = id_order))

result_lr_txt = confusionMatrix(tab_class_txt_lr,mode="everything")
result_lr_txt = data.frame(t(result_lr_txt$byClass))
result_lr_txt$Total = base::rowMeans(result_lr_txt)

#### Logistic Regression - TFIDF -------------------------------------

### Headlines
lr_hl_tfidf = cv.glmnet(tr_hl_tfidf, docvars(tr_hl_tfidf, "ideology"), family="multinomial")
predicted_class_hl_lr_tfidf <- predict(lr_hl_tfidf,newx=tst_hl_coerced_tfidf, type = "class")
tab_class_hl_lr_tfidf <- table(actual_class, factor(predicted_class_hl_lr_tfidf, levels = id_order))

result_lr_hl_tfidf = confusionMatrix(tab_class_hl_lr_tfidf,mode="everything")
result_lr_hl_tfidf = data.frame(t(result_lr_hl_tfidf$byClass))
result_lr_hl_tfidf$Total = base::rowMeans(result_lr_hl_tfidf)

### Description
lr_dsc_tfidf = cv.glmnet(tr_dsc_tfidf, docvars(tr_dsc_tfidf, "ideology"), family="multinomial")
predicted_class_dsc_lr_tfidf <- predict(lr_dsc_tfidf,newx=tst_dsc_coerced_tfidf, type = "class")
tab_class_dsc_lr_tfidf <- table(actual_class, factor(predicted_class_dsc_lr_tfidf, levels = id_order))

result_lr_dsc_tfidf = confusionMatrix(tab_class_dsc_lr_tfidf,mode="everything")
result_lr_dsc_tfidf = data.frame(t(result_lr_dsc_tfidf$byClass))
result_lr_dsc_tfidf$Total = base::rowMeans(result_lr_dsc_tfidf)

### Full-text
lr_txt_tfidf = cv.glmnet(tr_txt_tfidf, docvars(tr_txt_tfidf, "ideology"), family="multinomial")
predicted_class_txt_lr_tfidf <- predict(lr_txt_tfidf,newx=tst_txt_coerced, type = "class")
tab_class_txt_lr_tfidf <- table(actual_class, factor(predicted_class_txt_lr_tfidf, levels = id_order))

result_lr_txt_tfidf = confusionMatrix(tab_class_txt_lr_tfidf,mode="everything")
result_lr_txt_tfidf = data.frame(t(result_lr_txt_tfidf$byClass))
result_lr_txt_tfidf$Total = base::rowMeans(result_lr_txt_tfidf)