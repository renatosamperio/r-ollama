library(httr2)
library(glue)
library(dplyr)

texts <- c('I love this product', 'I hate this product', 'I am neutral about this product')
reqs <- lapply(texts, function(text) {
  prompt <- glue("Your only task/role is to evaluate the sentiment of product reviews, and your response should be one of the following:'positive', 'negative', or 'other'. Product review: {text}")
  ollamar::generate("llama3.2", prompt, output = "req")
})
resps <- httr2::req_perform_parallel(reqs)
sapply(resps, ollamar::resp_process, "text")