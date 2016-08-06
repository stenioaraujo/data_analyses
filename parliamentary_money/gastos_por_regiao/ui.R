library(shiny)

shinyUI(fluidPage(
  tags$head(tags$style(
    type="text/css",
    "#image img {max-width: 100%; width: 100%; height: auto}"
  )),
  
  titlePanel("Expenses by Region"),
  
  sidebarLayout(
    sidebarPanel(
       sliderInput("valor",
                  "Valor do Documento:",
                  min = 1,
                  max = 1000000,
                  value = 1000000,
                  ticks = FALSE)
    ),
    
    mainPanel(
      h3("Teste"),
      plotOutput("regioes", width="100%"),
      plotOutput("tipoGasto", width="100%"),
      plotOutput("partidos")
    )
  )
))
