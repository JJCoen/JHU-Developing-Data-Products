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

str(loan_data) 
loan_data <- loan_data[, .(loan_status, loan_amnt, ir_cat, emp_cat)]
# Convert response to categorical in order to 
# identify with names when plotting
loan_data$loan_status <-ifelse(loan_data$loan_status ==1, 
                               "Default!",
                               "Loan Paid") %>% 
  as.factor() %>% 
  relevel(ref = "Loan Paid")

ir <- "0-8"
emp <- "0-15"
loan_data <- loan_data[ ir_cat == eval(ir) & 
                          emp_cat == eval(emp)]

fig <- plot_ly(loan_data, y = ~loan_amnt, x = ~loan_status,
               type = "box",
               color = ~loan_status,
               showlegend = FALSE,
               colors = c("darkgreen", "red") ) %>% 
  layout(title = "Loan Amount by Status",
         yaxis = list(title = "Loan Amount"),
         xaxis = list(title = "Loan Status"))
fig

