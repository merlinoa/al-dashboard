library(dplyr)

# connect to database
al_db <- src_postgres(
           dbname = "al_db",
           host = "ractuary-db.carngedsdgcf.us-west-2.rds.amazonaws.com",
           port = 5432,
           user = "merlinoa",
           password = "",
           options = "-c search_path=al_db"
         )

# query all vehicles from data base
vehicles <- tbl(al_db, "vehicles")
vehicles <- as.data.frame(vehicles)