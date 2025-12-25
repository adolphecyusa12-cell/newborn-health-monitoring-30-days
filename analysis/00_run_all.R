
# Run All - 30-Day Newborn Health Monitoring (R + MySQL)

# 1) Connect to database + load libraries
source("analysis/01_db_connection.R")

# 2) Load tables into R
source("analysis/02_data_loading.R")

# 3) Build daily integrated dataset
source("analysis/03_data_processing.R")

# 4) Create visualizations
source("analysis/04_visualizations.R")

# Optional: close connection when done
dbDisconnect(con)
