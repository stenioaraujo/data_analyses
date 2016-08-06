#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(knitr)

num = as.numeric

######## RETRIEVING THE DATA #####################
untar("../data/ano-atual.csv.tgz", files="ano-atual.csv", exdir="../temp")
source("https://github.com/nazareno/ciencia-de-dados-1/raw/master/1-EDA/problema%201/gastos_lib.R")
expenses = ler_gastos("../temp/ano-atual.csv")

######## PREPARING THE DATA ######################
### Identify the politicians by Brazilian regions
regiaoSigla = function(state) {
  switch (tolower(state),
    pb=,pe=,rn=,ce=,al=,ba=,se=,pi=,ma = "NORDESTE",
    pa=,to=,ap=,rr=,am=,ac=,ro = "NORTE",
    mt=,df=,go=,ms = "CENTRO-OESTE",
    mg=,sp=,rj=,es = "SUDESTE",
    pr=,sc=,rs = "SUL"
  )
}
map = new.env()
map[["Emissão Bilhete Aéreo"]] = "PASSAGENS AÉREAS"
map[["DIVULGAÇÃO DA ATIVIDADE PARLAMENTAR."]] = "DIVULGAÇÃO"
map[["LOCAÇÃO OU FRETAMENTO DE VEÍCULOS AUTOMOTORES"]] = "LOCAÇÃO DE VEÍCULOS"
map[["MANUTENÇÃO DE ESCRITÓRIO DE APOIO À ATIVIDADE PARLAMENTAR"]] = "MANUTENÇÃO DE ESCRITÓRIOS"
map[["CONSULTORIAS, PESQUISAS E TRABALHOS TÉCNICOS."]] = "CONSULTORIAS"
map[["COMBUSTÍVEIS E LUBRIFICANTES."]] = "COMBUSTÍVEIS"
map[["LOCAÇÃO OU FRETAMENTO DE AERONAVES"]] = "LOCAÇÃO DE AERONAVES"
map[["HOSPEDAGEM ,EXCETO DO PARLAMENTAR NO DISTRITO FEDERAL."]] = "HOSPEDAGEM"
map[["FORNECIMENTO DE ALIMENTAÇÃO DO PARLAMENTAR"]] = "ALIMENTAÇÃO"
map[["SERVIÇO DE SEGURANÇA PRESTADO POR EMPRESA ESPECIALIZADA."]] = "SEGURANÇA"
map[["SERVIÇO DE TÁXI, PEDÁGIO E ESTACIONAMENTO"]] = "TÁXI, PEDÁGIO E ESTACIONAMENTO"
map[["PARTICIPAÇÃO EM CURSO, PALESTRA OU EVENTO SIMILAR"]] = "PARTICIPAÇÃO EM EVENTOS"
map[["PASSAGENS TERRESTRES, MARÍTIMAS OU FLUVIAIS"]] = "PASSAGENS NÃO AÉREAS"
map[["LOCAÇÃO OU FRETAMENTO DE EMBARCAÇÕES"]] = "LOCAÇÃO DE EMBARCAÇÕES"
tipo = function(tipoDeGasto) {
  t = as.character(tipoDeGasto)
  if (!is.null(map[[t]]))
    return(map[[t]])
  else
    return(t)
}

expenses = expenses %>%
  filter(!is.na(sgUF), vlrDocumento > 0) %>%
  mutate(regiao = sapply(sgUF, regiaoSigla),
         descricao = sapply(as.character(txtDescricao), tipo))

shinyServer(function(input, output) {
   
  #expenses by Region
  output$regioes = renderPlot({
    
    regioes = expenses %>%
      group_by(regiao) %>%
      summarise(total = sum(vlrDocumento))
    
    ggplot(regioes, aes(x = reorder(regiao, total),
                        y = total, fill = regiao)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      theme_minimal()
  })
  
  #expenses by kind of expenses
  output$tipoGasto = renderPlot({
    
    tipoGasto = expenses %>%
      group_by(descricao, regiao) %>%
      summarise(total = sum(vlrDocumento))
    
    ggplot(tipoGasto, aes(x = reorder(descricao, total), 
                          y = total, fill = regiao)) +
      geom_bar(stat = "identity", position = "dodge") +
      coord_flip() +
      theme_minimal()
  })
  
  output$partidos = renderPlot({
    
    partidos = expenses %>%
      group_by(sgPartido, regiao) %>%
      summarise(total = sum(vlrDocumento))
    
    ggplot(partidos, aes(x = reorder(sgPartido, total), 
                          y = total, fill = regiao)) +
      geom_bar(stat = "identity", position = "dodge") +
      coord_flip() +
      theme_minimal()
  })
})
