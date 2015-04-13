library(dplyr)

# connect to database
al_db <- src_sqlite("al_db.sqlite3")

# query all vehicles from data base
vehicles <- tbl(al_db, sql("SELECT * FROM vehicles"))
vehicles <- as.data.frame(vehicles)
