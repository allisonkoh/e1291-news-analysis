library(keras)
library(dplyr)
library(ggplot2)
library(purrr)
library(varhandle)

# loading data
data_dir = "newspaper-data/"
load(paste0(data_dir, "us_news_train.rda"))
load(paste0(data_dir, "us_news_test.rda"))
load(paste0(data_dir, "us_news_validation.rda"))

set.seed(1984)

x_train = us_news_train$headline
y_train = us_news_train$ideology
ytrain = to.dummy(y_train, "ideology")

x_val = us_news_validation$validate.headline
y_val = us_news_validation$validate.ideology
yval = to.dummy(y_val, "ideology")

x_test = us_news_test$headline
y_test = us_news_test$ideology
ytest = to.dummy(y_test, "ideology")


vocab_size = 10000
tokenizer = text_tokenizer(num_words = vocab_size, lower = TRUE) %>% 
  fit_text_tokenizer(x_train) 

sequences = texts_to_sequences(tokenizer, x_train)

xtrain = pad_sequences(sequences, maxlen=12)

# setting up RNN
model = keras_model_sequential()
model %>% layer_embedding(input_dim = vocab_size, output_dim = 16) %>%
  layer_spatial_dropout_1d(0.4) %>%
  layer_lstm(100, dropout=0.4, recurrent_dropout=0.4) %>%
  layer_dense(5, activation = "softmax")

model %>% compile(
  optimizer = 'adam',
  loss = 'categorical_crossentropy',
  metrics = c('accuracy')
)



rnn_title = model %>% fit(
  xtrain,
  ytrain,
  epochs = 30,
  batch_size = 500,
  validation_split = 0.1)


plot(rnn_title)
