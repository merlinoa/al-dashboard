## ui.R ##
library(shinydashboard)


header <- dashboardHeader(
            title = "Auto Liability"
          )

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard_tab", icon = icon("dashboard")),
    menuItem("Vehicles Table", tabName = "vehicles_tab", icon = icon("car")),
    menuItem("Add Vehicle", icon = icon("file-text"), tabName = "add_vehicle_tab"),
    menuItem("Rates", icon = icon("money"), tabName = "rates_tab")
  )
)

body <- dashboardBody(
  tabItems(
  # Dashboard tab ----------------------------------------------
    tabItem(tabName = "dashboard_tab",
      fluidRow(
        box(
          p("Disclaimer: This dashboard is only meant as an example, and it is incomplete.")
        )
      ),
      fluidRow(
        valueBoxOutput("vehicles_total", width = 4),
        box(
          width = 8,
          radioButtons(
            inputId = "group_by_vehicles",
            label = "Group By:",
            choices = list(
              "Member" = "member_num",
              "Vehicle Class" = "class"
            )
          ),
          dataTableOutput("vehicles_summary_out")
        )
      )
      
    ),
  # Vehicles tab -----------------------------------------------     
    tabItem(tabName = "vehicles_tab", 
      fluidRow(
        box(width = 4,
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
        box(width = 4,
          selectizeInput(
            inputId = "member_vehicles",
            label = "Member",
            choices = c(unique(as.data.frame(select(vehicles, member_num))$member_num), "All"),
            multiple = TRUE,
            selected = "All"
          )
        ),
        box(width = 4,
            downloadButton("download_vehicles", label = "Download Table")
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
                        "Merlino County - 660" = 660,
                        "Merlino School - 740" = 740
                      )
          ),
          selectInput(
            inputId = "class_request",
            label = "Vehicle Class",
            choices = list("Compact - 100" = 100,
                           "Sedan - 101" = 101, 
                           "Truck- 300" = 200, 
                           "SUV - 301" = 300, 
                           "BUS - 400" = 302
                           )
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
      tabName = "rates_tab",
      fluidRow(
        box(
          h1("Individual Vehicle Pricing/Rate Structure"),
          width = 12,
          DiagrammeR::grViz("
          digraph rmarkdown {
          Vehicle -> Liability
          Vehicle -> Medical
          Vehicle -> UM
          Vehicle -> APD
          Liability -> LiabilityDeductible
          Medical -> MedicalDeductible
          UM -> UMDeductible
          APD -> APDDeductible
          LiabilityDeductible -> EMod
          MedicalDeductible -> EMod
          UMDeductible -> EMod
          APDDeductible -> EMod
          EMod -> ScheduleMod
          ScheduleMod -> VehiclePricing
          }
          ", height = 700)
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