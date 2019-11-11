library(keras)
library(dplyr)
library(ggplot2)
library(purrr)
library(varhandle)

# loading data
data_dir = "../newspaper-data/"
load(paste0(data_dir, "us_news_train.rda"))
load(paste0(data_dir, "us_news_test.rda"))
load(paste0(data_dir, "us_news_validation.rda"))

set.seed(1984)

x_train = us_news_train$text
y_train = us_news_train$ideology
ytrain = to.dummy(y_train, "ideology")

x_val = us_news_validation$validate.headline
y_val = us_news_validation$validate.ideology
yval = to.dummy(y_val, "ideology")

x_test = us_news_test$text
y_test = us_news_test$ideology
ytest = to.dummy(y_test, "ideology")


max_features = 5000
maxlen = 400
batch_size = 512
embedding_dims = 50
filters = 250
kernel_size = 3
hidden_dims = 250

x_train_tok = text_tokenizer(num_words = max_features, lower = TRUE) %>% 
  fit_text_tokenizer(x_train)
train_seq = texts_to_sequences(x_train_tok, x_train)
xtrain = pad_sequences(train_seq, maxlen=maxlen)

# setting up CNN
model = keras_model_sequential()
model %>% 
  layer_embedding(max_features, embedding_dims, input_length = maxlen) %>%
  layer_dropout(0.3) %>%
  layer_conv_1d(filters, kernel_size, 
                padding = "valid", activation = "relu", strides = 1) %>%
  layer_global_max_pooling_1d() %>%
  layer_dense(hidden_dims) %>%
  layer_dropout(0.3) %>%
  layer_activation("relu") %>%
  layer_dense(5) %>%
  layer_activation("sigmoid")

# model compiler
model %>% compile(
  loss = "categorical_crossentropy",
  optimizer = "adam",
  metrics = "accuracy"
)

cnn_title = model %>% fit(
  xtrain,
  ytrain,
  epochs = 10,
  batch_size = 512,
  validation_split = 0.1)

plot(cnn_title)