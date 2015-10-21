shinyUI(fluidPage(
  titlePanel("Mpg predictor"),
  fluidRow(
    column(3,
      wellPanel(
        h4("Filter"),
        sliderInput("cyl", "Number of cylinders", value = 6, min = 4, max = 8, step = 1),
        sliderInput("gear", "Number of forward gears", value = 4, min = 3, max = 5, step = 1),
        sliderInput("carb", "Number of carburetors", value = 2, min = 1, max = 8, step = 1),
        checkboxInput("am", label = "Automatic transmission", value = TRUE),
        checkboxInput("vs", label = "V-engine", value = FALSE),
        numericInput("disp", "Displacement (cu.in.)", value = 196.3, min = 71.1, max = 472, step = 1),
        numericInput("hp", "Gross horsepower", value = 123.0, min = 52, max = 335, step = 1),
        numericInput("drat", "Rear axle ratio", value = 3.695, min = 2.760, max = 4.930, step = 0.1),
        numericInput("wt", "Weight (lb/1000)", value = 3.325, min = 1.513, max = 5.424, step = 0.1),
        numericInput("qsec", "1/4 mile time", value = 17.71, min = 14.50, max = 22.90, step = 0.1)
      ),
      wellPanel(
        tags$small(paste0(
          "Predicting mpg powered by mtcars"
        ))
      )
    ),
    column(9,
      wellPanel(
        span(h3("Predicted mpg:"),
          h1(textOutput("predicted_mpg"))
        )
      )
    )
  )
))
