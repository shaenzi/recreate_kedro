library(dplyr)
config <- config::get()

res <- download_meteo_data(config$urls)

# why on earth does this not work
# lubridate::ymd_hm(res$temperature$datum[[1]], format = "%Y-%m-%dT%H:%M", tz = "Europe/Zurich")

rain <- res$rain
temp <- res$temperature
         