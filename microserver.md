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

### POST and GET request parameter parsing

```r
library(magrittr); library(httr); library(jsonlight)
routes <- list(
  '/post' = function(p, q) { p },
  '/get'  = function(p, q) { q },
  function(...) "ok")
microserver::run_server(routes, port = 8103)
```

```r
httr::GET(url) %>% content # default route
# [1] "\"ok\""
httr::GET(paste0(url, 'get')) %>% content # GET with no args
# [1] ""
httr::GET(paste0(url, 'get?a=1&b=2')) %>% content # list(a=1,b=2) is available as `q`
# [1] "{\"a\":\"1\",\"b\":\"2\"}"
httr::GET(paste0(url, 'post?a=1&b=2')) %>% content # `p` is still empty
# [1] ""
httr::POST(paste0(url, 'post'), body = list(a=1,b=2), encode = "json") %>% content
# [1] "{\"a\":1,\"b\":2}" # list(a=1,b=2) is available as `p`
```

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
  # and let's make it work with POST requests (or, generally speaking)
  # for requests that have a JSON body
  '/sum'   = function(p, q) {
    if (length(p) == 0) 'must be a POST request' else sum(unlist(p$values))
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
![GET root](http://puu.sh/kRx5x/d34cd39f72.png)

--

### Examples

![GET hello](http://puu.sh/kRwd1/95382fcb8f.png)

--

### Examples

Notice how error message gets returned as a response
![POST sum](http://puu.sh/kRwqo/454be5aa0c.png)

--

### Examples

![GET sum](http://puu.sh/kRwT5/ba673c15cb.png)

--

### Demo

- Show POST and GET parameter parsing works.
- Make a titanic prediction web server.
- Create a shiny app that works with microserver.
