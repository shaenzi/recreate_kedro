# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("data.table", 
               "dplyr", 
               "here", 
               "janitor", 
               "lubridate", 
               "purrr", 
               "quarto",
               "stringr", 
               "tarchetypes", 
               "tibble") # packages that your targets need to run
  # format = "qs", # Optionally set the default storage format. qs is fast.
  # Set other options as needed.
)

# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
options(clustermq.scheduler = "multiprocess")

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

list(
  tar_target(
    name = config,
    command = config::get(),
    cue = tar_cue(mode = "always") 
    # it does not recognise that it needs to rerun when config.yml changes
    # not sure whether this should be a target? or I just call it above?
  ),
  tar_target(
    name = data,
    command = download_meteo_data(config$urls)
    # format = "feather" # efficient storage for large data frames
  ),
  tar_quarto_rep(
    name = report,
    path = here::here("quartos", "base_meteo.qmd"),
    execute_params = tibble::tibble(
      location = config$locations,
      output_file = here::here("quartos", paste0("base_meteo_", config$locations, ".html"))
    )
  )
)
