library(keras)
library(dplyr)
library(ggplot2)
library(purrr)
library(varhandle)
library(caret)

# loading data
data_dir = "../newspaper-data/"
load(paste0(data_dir, "us_news_train.rda"))
load(paste0(data_dir, "us_news_test.rda"))
load(paste0(data_dir, "us_news_validation.rda"))

set.seed(1984)

id_order = c("left", "leanleft", "center", "leanright", "right")
actual_class = us_news_test$ideology

x_train = us_news_train$headline
y_train = us_news_train$ideology
ytrain = to.dummy(y_train, "ideology")

x_val = us_news_validation$headline
y_val = us_news_validation$ideology
yval = to.dummy(y_val, "ideology")

x_test = us_news_test$headline
y_test = us_news_test$ideology
ytest = to.dummy(y_test, "ideology")

max_features = 1500
maxlen = 15
batch_size = 512
embedding_dims = 64
filters = 128
kernel_size = 5

tokenizer = text_tokenizer(num_words = max_features, lower = TRUE) %>% 
  fit_text_tokenizer(x_train)

train_seq = texts_to_sequences(tokenizer, x_train)
xtrain = pad_sequences(train_seq, maxlen=maxlen)

val_seq = texts_to_sequences(tokenizer, x_val)
xval = pad_sequences(val_seq, maxlen=maxlen)

test_seq = texts_to_sequences(tokenizer, x_test)
xtest = pad_sequences(test_seq, maxlen=maxlen)

# setting up RNN-CNN
model = keras_model_sequential()
model %>% 
  layer_embedding(max_features, embedding_dims, input_length = maxlen) %>%
  layer_dropout(0.3) %>%
  layer_conv_1d(filters, kernel_size, 
                padding = "valid", activation = "relu") %>%
  layer_max_pooling_1d(pool_size = 2) %>%
  layer_dropout(0.3) %>%
  layer_conv_1d(filters, kernel_size, 
                padding = "valid", activation = "relu") %>%
  layer_gru(units=128, dropout = 0.1, recurrent_dropout = 0.5) %>%
  layer_dense(5) %>% 
  layer_activation("softmax")

# model compiler
model %>% compile(
  loss = "categorical_crossentropy",
  optimizer = "adam",
  metrics = "accuracy"
)


rnncnn_hl = model %>% fit(
  xtrain,
  ytrain,
  epochs = 10,
  batch_size = 512,
  validation_data = list(xval, yval))

plot(rnncnn_hl)

results = model %>% evaluate(xtest, ytest)
results
pred_class_hl = model %>% predict_classes(xtest)
pred_class_hl = factor(pred_class_hl)
pred_class_tab_hl = table(actual_class, factor(pred_class_hl, labels = id_order))

result_rnncnn_hl = confusionMatrix(pred_class_tab_hl,mode="everything")
result_rnncnn_hl = data.frame(t(result_rnncnn_hl$byClass))
result_rnncnn_hl$Macro = base::rowMeans(result_rnncnn_hl)