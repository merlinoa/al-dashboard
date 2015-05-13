## server.R ##

function(input, output, session) {
  
  # vehicles ---------------------------------------------------------------
  vehicles_active <- reactive({
    # subset by active vehicles
    if (identical(input$active_vehicles, "active_vehicles_only")) {
      filter(holder, 
        delete_effective_date >= input$vehicle_date | 
          is.na(delete_effective_date
        )
      )
    } else {
      holder
    }
  })
  
  vehicles_member <- reactive({
    # subset by member number
    if ("All" %in% input$member_vehicles) {
      # don't do anythingo
      vehicles_active()
    } else if (length(input$member_vehicles) == 0) {
      NULL
    } else if (length(input$member_vehicles) == 1){
      filter(vehicles_active(),
        member_num == input$member_vehicles
      )
    } else  {
      filter(vehicles_active(), 
        member_num %in% input$member_vehicles # does not work for 1 member?
      )
    }
  })
  
  vehicles_group <- reactive({
    # group by vin, member, or vehicle class
    if (identical("member_num", input$group_by_vehicles)) {
      group_by(vehicles_member(), member_num) %>%
        summarise("Vehicles" = n())
    } else if (identical("class", input$group_by_vehicles)) {
      out <- group_by(vehicles_member(), class) %>%
               summarise("Vehicles" = n())
    } else {
      vehicles_member() 
    }
  })
   
  vehicles_table <- reactive({  
    as.data.frame(vehicles_group())
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
  
  observe({
    input$submit_request
    isolate({
      request_sql <- paste0(
                       "INSERT INTO vehicles VALUES(",
                       "'", input$vin_request, "', ", 
                       input$member_request, ", ",
                       input$class_request, ", ",
                       "'", input$date_request, "', ",
                       "NULL, ",
                       "'", Sys.Date(), "', ",
                       "'add');"
                     )
      dbGetQuery(conn = al_db$con,
                 statement = request_sql)
    })
  })
  
  
  #---------------------Rates-----------------------------------------
  
  # table to display base vehicle pricing rates for selected policy year
  base_rate <- reactive({
    holder <- tbl(al_db, sql("SELECT coverage1 coverage2 rate 
                   FROM base_rates 
                   WHERE effective_end_date == NA"))
    as.data.frame(holder)
  })
}
