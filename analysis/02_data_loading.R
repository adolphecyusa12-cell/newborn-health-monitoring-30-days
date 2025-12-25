##### Load Tables from MySQL #####

babies <- dbReadTable(con, "babies")
excretion <- dbReadTable(con, "excretion")
illness <- dbReadTable(con, "illness")
immunization <- dbReadTable(con, "immunization")
size <- dbReadTable(con, "size")
vitals <- dbReadTable(con, "vitals")
immunization_type <- dbReadTable(con, "vaccination_type")
