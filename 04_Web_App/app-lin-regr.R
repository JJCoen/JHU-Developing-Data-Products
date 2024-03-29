#Load libraries
library(data.table)
library(readr)
library(dplyr)
library(ggplot2)
library(plotly)

library(shiny)

# load Loans Data
loan_data <- read.csv("./Data/loan_data_preproc.csv", stringsAsFactors = TRUE)
setDT(loan_data)
# remove index column inserted by Excel
loan_data[, X := NULL]
# Select required variables
loan_data <- loan_data[, .(loan_status, loan_amnt, ir_cat, emp_cat)]
# Convert response to categorical in order to 
# identify with names when plotting
loan_data$loan_status <-ifelse(loan_data$loan_status ==1, 
                               "Default!",
                               "Loan Paid") %>% 
  as.factor() %>% 
  relevel(ref = "Loan Paid")

#Define UI
ui <- fluidPage(
  
  
  titlePanel("Loan Repayment based on Amount"),
  sidebarPanel(
    selectInput('ir', label = 'Interest Rate: ', 
                choices = levels(loan_data$ir_cat)),
    selectInput('emp', label = 'Employment Length: ', 
                choices = levels(loan_data$emp_cat)) 
    ),
  plotOutput("plot", dblclick = "plot_reset")
  
)
server <- function(input, output) {
  
  output$plot <- renderPlot({
    # select interest rate and employment categories
    subset_data <- loan_data[ ir_cat == input$ir &
                               emp_cat == input$emp]

    ggplot(subset_data, aes(y = loan_amnt, x = loan_status,
                            color = loan_status) ) +
      geom_boxplot() +
      coord_flip() +
      # Use brewer color palettes
      scale_color_brewer(palette="Dark2") +
      theme(legend.position="none") +
      labs(title="Repayment",x="Loan Outcome", y = "Loan Amount") 

  }, res = 96)
}

# Run the application 
shinyApp(ui = ui, server = server)