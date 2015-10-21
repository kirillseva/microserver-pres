title: "Microserver: APIs in R"
author:
  name: Kirill Sevastyanenko
  email: kirill.sevastyanenko@avant.com
  twitter: kirillseva
  github: robertzk/microserver

output: pres.html
controls: false
--

# Microserver
## or how to make APIs using R

--

### Typical data science workflow

<img src="http://puu.sh/kPjWe/536512eb4c.png" width="100%">
--

### Ideal data science workflow

<img src="http://puu.sh/kPkyE/b0af456b08.png" width="100%">
--

### Compromise

<img src="http://puu.sh/kPkTo/e51dc5ee71.png" width="100%">
--

### Compromise

<img src="http://puu.sh/kPncW/044c031806.png" width="100%">
--

### Enter microserver

```r
## Simple hello-world web server
routes <- list('/hello' = function(...) { "world" }, function(...) { "default" })
microserver::run_server(routes, port = 8103)
```

That's it!
--

### Microserver

- Built on top of `httpuv` - the same library that powers Shiny.
- Parses POST and GET parameters for you.
- Reliable - used by Avant to power all predictions.

--

### Examples

```r
routes <- list(
  # every route is a map between path and the function that should be called
  # on the request
  # Let's make a route with path 'hello' that returns 'world'
  '/hello' = function(...) 'world',
  # That simple!
  # Now let's make something more complicated
  # Let's make a route 'sum' that would sum all the inputs for a JSON payload
  # that looks like {"values": [1,2,3,-5.6,...]}
  # and let's make it works with POST requests (or, generally speaking)
  # for requests that have a JSON body
  '/sum'   = function(p, q) {
    if (length(p) == 0) 'must be a POST request with values'
    else sum(unlist(p$values))
  },
  # You can also submit a wildcard route that will be called
  # whenever someone queries a route that was not specified
  # in the configuration
  function(...) { "This is microserver demo" }
)
# And then you can just run the server using the routes that you've defined
microserver::run_server(routes, port = 8103)
```

--

### Examples

Here are some examples of querying this server:
<img src="http://puu.sh/kRx5x/d34cd39f72.png" width="100%">

--

### Examples

<img src="http://puu.sh/kRwd1/95382fcb8f.png" width="100%">

--

### Examples

Notice how error message gets returned as a response
<img src="http://puu.sh/kRwqo/454be5aa0c.png" width="100%">

--

### Examples

<img src="http://puu.sh/kRwT5/ba673c15cb.png" width="100%">

--

### Demo

- Make a web server that serves model predictions.
- Create a shiny app that works with microserver.

--

### Code for server

This part can be done entirely by data scientist
```r
mod    <- lm(mpg ~ . , data = mtcars) # s3read('path/to/model')
score <- function(mod, lst) {
  lst <- lapply(lst, as.numeric)
  df  <- data.frame(lst, stringsAsFactors = FALSE)
  unname(predict(mod, df))
}
routes <- list('/predict' = function(p, q) {
  list(score = score(mod, p)) }, function(...) "pong"
)
microserver::run_server(routes, port = 8103)
```

--

### Testing that the server works

<img src="http://puu.sh/kSykk/d98e579389.png" width="100%">

--

### Using this model in an app

```r
shinyServer(function(input, output) {
  score <- reactive({
    varnames <- c('cyl', 'disp', 'hp', 'drat',
      'wt', 'qsec', 'vs', 'am', 'gear', 'carb')
    payload <- lapply(varnames, function(nm) input[[nm]]) %>% setNames(varnames)
    httr::POST(paste0(URL, '/predict'), encode = 'json', body = payload) %>%
      content %>%
      jsonlite::fromJSON(.) %>%
      .$score
  })

  output$predicted_mpg <- renderText({ score() })
})
```

--

### Using this model in an app

That is all that your app/engineers need to do! Only fetch data and
send it to prediction service.

--

## One model server - infinitely many apps!

<img src="http://puu.sh/kSEpJ/da98a1e7d3.png" width="100%">
