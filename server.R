## server.R ##

function(input, output, session) {
  
  # vehicles --------------------------------------------------------------- 
  vehicles_table <- reactive({
    holder <- vehicles[, setdiff(names(vehicles), c("vehicle_id", "class"))]
    # subset by active vehicles
    if (identical(input$active_vehicles, "active_vehicles_only")) {
      holder <- holder[holder$delete_date >= input$vehicle_date | 
                      is.na(holder$delete_date), ]
    }
    
    # subset by member number
    if ("All" %in% input$member_vehicles) {
      # don't do anything
    } else {
      holder <- holder[holder$member_number %in% as.numeric(input$member_vehicles), ]
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
  
  #------------------Request Form-------------------------------------
  
  request_sql <- reactive({
    input$submit_request
    isolate({
      if (identical(input$request_type, add)) {
        add_request <- paste(
                         "INSERT INTO vehicles values(",
                         as.integer(max(vehicles$vehicle_id) + 1.01),
                         input$vin_request,
                         input$member_request,
                         input$year_request,
                         input$make_request,
                         input$model_request,
                         input$class_request,
                         input$acv_request,
                         input$add_date,
                         NULL,
                         Sys.time(),
                         ");"
                       )
        dbSendQuery(al_db, add_request)
      } else if (identical(input$request_type, delete)) {
        # todo: delete request
      } else {
        # todo: change request
      }
    })
  })
  
  
  #dbSendQuery(
  #  al_db$con, 
  #  'INSERT INTO vehicles VALUES (9.9, 9.9, 9.9, 9.9, "new")'
  #)
  
  #---------------------Rates-----------------------------------------
  
  # table to display base vehicle pricing rates for selected policy year
  base_rate <- reactive({
    holder <- tbl(al_db, sql("SELECT coverage1 coverage2 rate 
                   FROM base_rates 
                   WHERE effective_end_date == NA"))
    as.data.frame(holder)
  })
}
