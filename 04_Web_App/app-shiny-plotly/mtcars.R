library(shiny)
library(plotly)

ui <- fluidPage(
  headerPanel('Example'),
  sidebarPanel(
    selectInput('xcol','X Variable', names(mtcars)),
    selectInput('ycol','Y Variable', names(mtcars)),
    selected = names(mtcars)[[2]]),
  mainPanel(
    plotlyOutput('plot')
  )
)

server <- function(input, output) {
  
  x <- reactive({
    mtcars[,input$xcol]
  })
  
  y <- reactive({
    mtcars[,input$ycol]
  })
  
  
  output$plot <- renderPlotly(
    plot1 <- plot_ly(
      x = x(),
      y = y(), 
      type = 'scatter',
      mode = 'markers')
  )
  
}

shinyApp(ui,server)