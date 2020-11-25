#' Webhook Data Integration
#'
#' Endpoint to receive data external system, triggered by webhook,
#' must provide valid partner issued api key
#'
#' @param apikey partner issued api key
#' @param ... data sent in request
#' @param file_name TBD
#' @param input_data TBD
#'
#' @importFrom rlang dots_values
#' @importFrom lubridate now
#' @importFrom data.table data.table
#' @importFrom DBI dbConnect dbDisconnect dbAppendTable
#' @importFrom RPostgres Postgres
#' @importFrom httr POST
#' @importFrom jsonlite write_json
#'
#' @name zappier_data_ingest
NULL


#' @describeIn zappier_data_ingest TBD
#' @export
hcazapier <- function(..., apikey = NULL) {

  partner_guid <- verifyPartnerKey( apikey )

  ts_utc_int <- ceiling(as.numeric(lubridate::now(tzone = "UTC")))

  fname <- paste0(partner_guid, "_", ts_utc_int)
  body <- list(
    file_name = fname,
    input_data = rlang::dots_values(...),
    apikey = apikey
  )

  url <- "http://159.65.104.28/ocpu/library/novar/R/write_session_data"
  r <- httr::POST(url, body = body, encode = "json")

  session_id <- r$headers[["x-ocpu-session"]]

  con <- DBI::dbConnect(
    drv = RPostgres::Postgres(),
    dbname = Sys.getenv("DB_NAME"),
    user = Sys.getenv("DB_USER"),
    password = Sys.getenv("DB_PWD"),
    host = Sys.getenv("DB_HOST"),
    port = 5432
  )

  on.exit(DBI::dbDisconnect(con))

  row <-  data.table::data.table(created_utc = lubridate::now(tzone = "UTC"),
                                 session_tmp_id = session_id,
                                 filename = fname)

  DBI::dbAppendTable(con, "wh_api_data", row)
  return(TRUE)
}

# base_api <- "http://159.65.104.28/ocpu"
# url <- stringr::str_glue("{base_api}/tmp/x0ceeae977187bd/files/ABCDEFG_1605847663")
# httr::GET(url)
#
# con <- DBI::dbConnect(odbc::odbc(),
#                       Driver = "PostgreSQL",
#                       database = Sys.getenv("DB_NAME"),
#                       UID    = Sys.getenv("DB_USER"),
#                       PWD    = Sys.getenv("DB_PWD"),
#                       host = Sys.getenv("DB_HOST"),
#                       port = 5432)
#
# DBI::dbReadTable(con, "wh_api_data")




#' @describeIn zappier_data_ingest TBD
#' @export
write_session_data <- function(file_name, input_data, apikey){
  saveRDS(input_data, file_name)
}



#' @describeIn zappier_data_ingest TBD
#' @export
verifyPartnerKey <- function(apikey){
  warning( "NO VERIFICATION PERFORMED (TESTING)")
  return("placeholder_partner_key")
}
