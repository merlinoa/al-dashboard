## server.R ##
library(reshape2)
library(dplyr)
library(ggplot2)

# connect to database
al_db <- src_sqlite("al_db.sqlite3")

function(input, output, session) {
  
  # retreive vehicles from database
  vehicles <- reactive({
    holder <- tbl(al_db, sql("SELECT * FROM vehicles"))
    as.data.frame(holder)
  })
  
  # output vehicles table 
  vehicles_table <- reactive({
    holder <- vehicles()[, setdiff(names(vehicles()), c("vehicle_id", "class"))]
    if (input$active_vehicles) {
      holder <- holder[holder$delete_date >= input$vehicle_date | 
                      is.na(holder$delete_date), ]
    }
    holder
  })
  
  output$vehicles_table_out <- renderDataTable({
    vehicles_table()
  })
  
  # vechile table download
  output$download_vehicles <- downloadHandler(
    filename = function() {paste0("vehicle-exposure-", input$vehicle_date, ".csv")},
    content = function(file) {
      write.csv(
        vehicles_table(),
        file = file,
        row.names = FALSE
      )
    }
  )
  
  #---------------------Pricing-----------------------------------------
  
  # table to display base vehicle pricing rates for selected policy year
  base_rate <- reactive({
    holder <- tbl(al_db, sql("SELECT coverage1 coverage2 rate 
                   FROM base_rates 
                   WHERE effective_end_date == NA"))
    as.data.frame(holder)
  })
  
  ### outputs to ui.r ---------------------------------------
  
  
  # base rate table 
  output$base <- renderTable({
    base_rate()
  },
    include.rownames = FALSE,
    align = "lllr",
    digits = 2
  )
  
}
