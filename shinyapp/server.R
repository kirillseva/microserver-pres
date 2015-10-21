library(magrittr)
library(httr)
library(jsonlite)
URL <- 'http://localhost:8103'

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
