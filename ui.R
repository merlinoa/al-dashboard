## ui.R ##
library(shinydashboard)


header <- dashboardHeader(title = "Auto Liability",
            dropdownMenu(type = "notifications",
              messageItem(
                 from = "Enrty #6583",
                 message = "Duplicate Vin found in database",
                 icon = icon("question")
              )
            )
          )

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Vehicles", tabName = "vehicles_tab", icon = icon("car")),
    menuItem("Request Form", icon = icon("money"), tabName = "vehicle_request_form")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "vehicles_tab", 
      fluidRow(
        box(width = 4,
          checkboxInput("active_vehicles", label = "Active Vehicles Only", value = TRUE)
        ),
        box(width = 4,
          conditionalPanel(
            condition = "input.active_vehicles == true",
            dateInput(
              inputId = "vehicle_date",
              label = "Active Vehicles as of:",
              value = Sys.Date()
            )
          )
        ),
        box(width = 4,
            downloadButton("download_vehicles", label = "Download Vehicles Table")
        ),
        box(width = 12,  
          dataTableOutput("vehicles_table_out")
        )
      )
    ),
    tabItem(tabName = "vehicle_request_form",
            fluidRow(
              column(width = 6,
                radioButtons(inputId = "request_type", 
                  label = "Request Type",
                  choices = list("Add" = "add",
                                 "Delete" = "delete",
                                 "Change" = "change"
                                 )
                )
              ),
              
              column(width = 6,
                box(width = 12,
                  h2("Current Pricing"),
                  h3("Base Rates"),
                  tableOutput("base_yr")
                )
              )
            )
    )
    
  
    
  )
)

dashboardPage(
  header,
  sidebar,
  body
)