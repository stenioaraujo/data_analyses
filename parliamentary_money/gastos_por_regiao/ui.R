library(shiny)

nomeRegioes = c("NORDESTE", "NORTE", "CENTRO-OESTE", "SUDESTE", "SUL")
textoDescricoes = c("MANUTENÇÃO DE ESCRITÓRIOS", "COMBUSTÍVEIS", "CONSULTORIAS", 
                    "DIVULGAÇÃO", "SEGURANÇA", "TELEFONIA", "SERVIÇOS POSTAIS", "LOCAÇÃO DE VEÍCULOS", 
                    "PASSAGENS AÉREAS", "ALIMENTAÇÃO", "TÁXI, PEDÁGIO E ESTACIONAMENTO", 
                    "ASSINATURA DE PUBLICAÇÕES", "HOSPEDAGEM", "PASSAGENS NÃO AÉREAS", 
                    "LOCAÇÃO DE AERONAVES", "LOCAÇÃO DE EMBARCAÇÕES", "PARTICIPAÇÃO EM EVENTOS")
siglaPartidos = c("DEM", "PCdoB", "PDT", "PEN", 
                  "PHS", "PMB", "PMDB", "PP", "PPS", "PR", "PRB", "PROS", "PRP", 
                  "PRTB", "PSB", "PSC", "PSD", "PSDB", "PSL", "PSOL", "PT", "PTB", 
                  "PTdoB", "PTN", "PV", "REDE", "SD")

shinyUI(fluidPage(
  tags$head(tags$style(
    type="text/css",
    "#image img {max-width: 100%; width: 100%; height: auto}"
  )),
  
  titlePanel("Gastos por Região"),
  
  sidebarLayout(
    sidebarPanel(
       selectInput("regioes",
                   "Região",
                   nomeRegioes,
                   selected = nomeRegioes,
                   multiple = TRUE),
       selectInput("partidos",
                   "Partido",
                   siglaPartidos,
                   selected = siglaPartidos,
                   multiple = TRUE),
       selectInput("descricoes",
                   "Gasto com",
                   textoDescricoes,
                   selected = textoDescricoes,
                   multiple = TRUE),
       submitButton("Filtrar", icon("refresh"), width="100%")
    ),
    
    mainPanel(
      p("Esta página é uma continuação de outros trabalhos, sobre os gastos dos políticos brasileiros de Janeiro a Julho.",br(),
        "Os trabalhos podem ser encontrados em: ",
        a(href="https://r.kyaa.sg/xpovdo.html", "Parliamentary Money in Brazil"), ", ",
        a(href="https://r.kyaa.sg/evfiyf.html", "Dinheiro parlamentar no Brasil"), "," ,
        a(href="https://r.kyaa.sg/njbmpt.html", "Distribuição dos Gastos do Parlamentares"), "."),
      plotOutput("regioes"),
      plotOutput("tipoGasto"),
      plotOutput("partidos")
    )
  )
))
