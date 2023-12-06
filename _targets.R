# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("data.table", "dplyr", "janitor", "lubridate", "purrr", "stringr", "tibble") # packages that your targets need to run
  # format = "qs", # Optionally set the default storage format. qs is fast.
  # Set other options as needed.
)

# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
options(clustermq.scheduler = "multiprocess")

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Replace the target list below with your own:
list(
  tar_target(
    name = config,
    command = config::get()
  ),
  tar_target(
    name = data,
    command = download_meteo_data(config$urls)
    # format = "feather" # efficient storage for large data frames
  )
)
