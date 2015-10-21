library(magrittr)
library(httr)
library(jsonlite)
URL <- 'http://localhost:8103'

shinyServer(function(input, output) {
  # Fetch the scores
  score <- reactive({
    httr::POST(paste0(URL, '/predict'), encode = 'json',
      body = list(
        cyl    = input$cyl,
        disp   = input$disp,
        hp     = input$hp,
        drat   = input$drat,
        wt     = input$wt,
        qsec   = input$qsec,
        vs     = input$vs,
        am     = input$am,
        gear   = input$gear,
        carb   = input$carb
    )) %>% content %>% jsonlite::fromJSON(.) %>% .$score
  })

  output$predicted_mpg <- renderText({ score() })
})
