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
fluidPage(
  
  
  titlePanel("Loan Repayment based on Amount"),
  sidebarPanel(
    selectInput('ir', label = 'Interest Rate: ', 
                choices = levels(loan_data$ir_cat)),
    selectInput('emp', label = 'Employment Length: ', 
                choices = levels(loan_data$emp_cat)) 
  ),
  plotOutput("plot", dblclick = "plot_reset")
  
)
