Connect R- With my Database(My workbench)
                    

##### Library Manager #####
library(DBI)
library(RMariaDB)
library(dplyr)
library(ggplot2)
library(readr)
library(patchwork)

##### Database Connection #####
con <- dbConnect(
  RMariaDB::MariaDB(),
  host = "localhost",
  port = 3306,
  user = "root",
  password = "root",
  dbname = "new_born_babies"
)
