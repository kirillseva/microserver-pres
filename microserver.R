library(microserver)
library(methods)
library(stats)
mod    <- lm(mpg ~ . , data = mtcars) # s3read('path/to/model')
score <- function(mod, lst) {
  lst <- lapply(lst, as.numeric)
  df  <- data.frame(lst, stringsAsFactors = FALSE)
  unname(predict(mod, df))
}
routes <- list('/predict' = function(p, q) { list(score = score(mod, p)) }, function(...) "pong")
microserver::run_server(routes, port = 8103)
