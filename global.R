library(dplyr)
library(RPostgreSQL)

# connect to database
al_db <- src_postgres(
           dbname = "al_db",
           host = "",
           port = 5432,
           user = "",
           password = "",
           options = "-c search_path=al_db"
         )

# query all vehicles from data base
vehicles <- tbl(al_db, "vehicles")
holder <- select(vehicles, 
                 -request_date, 
                 -request_type,
                 -vehicle_id)