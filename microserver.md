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
- Used by Avant to power all predictions.

--

### Demo

- Show POST and GET parameter parsing works.
- Make a titanic prediction web server.
- Create a shiny app that works with microserver.
