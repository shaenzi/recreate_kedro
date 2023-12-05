library(dplyr)
config <- config::get()

df22 <- data.table::fread(config$urls$link_2022) |> 
  janitor::clean_names()

temp_22 <- df22 |> 
  filter(parameter == "T")
