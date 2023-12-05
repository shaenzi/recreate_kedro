#' download_meteo_data
#'
#' @param urls list of urls to download data from
#'
#' @return list of tibbles with temperature and rain data
#' @export
download_meteo_data <- function(urls) {
  all_data <- purrr::map(urls, ~ data.table::fread(.x) |> janitor::clean_names())
  
  temp_data <- purrr::map(all_data, 
                          ~ .x |> dplyr::filter(parameter == "T")) |> 
    purrr::list_rbind() |> 
    # convert datum column to datetime, add zero seconds as otherwise
    # lubridate cannot parse it (??)
    mutate(datum = stringr::str_replace(datum, "\\+", "\\:00\\+"),
          datum = lubridate::ymd_hms(datum, tz = "Europe/Zurich"))
  
  rain_data <- purrr::map(all_data, 
                          ~ .x |> dplyr::filter(parameter == "RainDur")) |> 
    purrr::list_rbind() |> 
    # convert datum column to datetime, add zero seconds as otherwise
    # lubridate cannot parse it
    mutate(datum = stringr::str_replace(datum, "\\+", "\\:00\\+"),
           datum = lubridate::ymd_hms(datum, tz = "Europe/Zurich"))
  
  return(list("temperature" = temp_data, "rain" = rain_data))
}
