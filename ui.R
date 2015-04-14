## ui.R ##
library(shinydashboard)


header <- dashboardHeader(
            title = "Auto Liability"
          )

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Vehicles", tabName = "vehicles_tab", icon = icon("car")),
    menuItem("Request Form", icon = icon("file-text"), tabName = "request_form_tab"),
    menuItem("Rates", icon = icon("money"), tabName = "rates_tab")
  )
)

body <- dashboardBody(
  tabItems(
  # Vehicles tab -----------------------------------------------     
    tabItem(tabName = "vehicles_tab", 
      fluidRow(
        box(width = 3,
          radioButtons(
            inputId = "active_vehicles", 
            label = NULL,  
            choices = list(
                        "All Vehicles" = "all_vehicles",
                        "Active Vehicles Only" = "active_vehicles_only"
                      )
          ),
          conditionalPanel(
            condition = "input.active_vehicles == 'active_vehicles_only'",
            dateInput(
              inputId = "vehicle_date",
              label = "Active Vehicles as of:",
              value = Sys.Date()
            )
          )
        ),
        box(width = 3,
          selectizeInput(
            inputId = "member_vehicles",
            label = "Member",
            choices = c(unique(vehicles$member_number), "All"),
            multiple = TRUE,
            selected = "All"
          )
        ),
        box(
          width = 3,
          radioButtons(
            inputId = "group_by_vehicles",
            label = "Summarize By:",
            choices = list(
              "Member" = "member_num",
              "Vehicle Class" = "class"
            )
          )
        ),
        box(width = 3,
            downloadButton("download_vehicles", label = "Download Vehicles Table")
        ),
        box(width = 12,  
          dataTableOutput("vehicles_table_out")
        )
      )
    ),
  
  # Request for tab --------------------------------------------------------------
    tabItem(
      tabName = "request_form_tab",
      fluidRow(
        box(
          width = 6,
          h2("Vehicle Request Form"),
          radioButtons(
            inputId = "request_type", 
            label = "Request Type",
            choices = list(
                        "Add" = "add",
                        "Delete" = "delete",
                        "Change" = "change"
                      )
          ),
          textInput(
            inputId = "vin_request",
            label = "Vin #"
          ),
          numericInput(
            inputId = "member_request",
            label = "Member #",
            210
          ),
          textInput(
            inputId = "year_request",
            label = "Year"
          ),
          textInput(
            inputId = "make_request",
            label = "Make"
          ),
          textInput(
            inputId = "model_request",
            label = "Model"
          ),
          selectInput(
            inputId = "class_request",
            label = "Class",
            choices = c(200, 201, 202,
                        300, 301, 302,
                        400, 401, 402,
                        500, 501, 502,
                        600, 601, 602)
          ),
          numericInput(
            inputId = "acv_request",
            label = "Actual Cost Value",
            15000
          ),
          dateInput(
            inputId = "date_request",
            label = "Effective Date",
            value = Sys.Date()
          ),
          actionButton("submit_request", "Submit Request")
        )
      )
    ),
  # ---- Rates tab ---------------------------------------------------------
    tabItem(
      tabName = "rates_tab"
    )
  )
)

dashboardPage(
  header,
  sidebar,
  body
)