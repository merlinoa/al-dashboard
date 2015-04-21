## ui.R ##
library(shinydashboard)


header <- dashboardHeader(
            title = "Auto Liability"
          )

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Vehicles", tabName = "vehicles_tab", icon = icon("car")),
    menuItem("Add Vehicle", icon = icon("file-text"), tabName = "add_vehicle_tab"),
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
            choices = c(unique(as.data.frame(select(vehicles, member_num))$member_num), "All"),
            multiple = TRUE,
            selected = "All"
          )
        ),
        box(
          width = 3,
          radioButtons(
            inputId = "group_by_vehicles",
            label = "Group By:",
            choices = list(
              "Vehicle" = "vin",
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
      tabName = "add_vehicle_tab",
      fluidRow(
        box(
          width = 6,
          h2("Add Vehicle"),
          textInput(
            inputId = "vin_request",
            label = "Vin #"
          ),
          selectInput(
            inputId = "member_request",
            label = "Member #",
            choices = list(
                        "Andy County - 210" = 210,
                        "Andy School - 450" = 450,
                        "Merlino County - 720" = 720,
                        "Merlino School - 740" = 740
                      )
          ),
          selectInput(
            inputId = "year_request",
            label = "Year",
            choices = 2016:1970
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