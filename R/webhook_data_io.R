#' Webhook Data Integration
#'
#' Endpoint to receive data external system, triggered by webhook,
#' must provide valid partner issued api key
#'
#' @param apikey partner issued api key
#' @param ... data sent in request
#'
#' @importFrom rlang dots_values
#' @importFrom lubridate now
#'
#' @name zappier_data_ingest
NULL


#' @describeIn zappier_data_ingest TBD
#' @export
hcazapier <- function(..., apikey = NULL) {

  partner_guid <- verifyPartnerKey( apikey )

  ts_utc_int <- ceiling(as.numeric(lubridate::now(tzone = "UTC")))


  body <- list(
    file_name = paste0(partner_guid, "_", ts_utc_int),
    input_data = rlang::dots_values(...),
    apikey = apikey
  )

  url <- "http://localhost/ocpu/library/novar/R/write_session_data"
  r <- httr::POST(url, body = body)

  session_id <- r$headers[["x-ocpu-session"]]

  con <- DBI::dbConnect(odbc::odbc(),
                        Driver = "PostgreSQL",
                        database = Sys.getenv("DB_NAME"),
                        UID    = Sys.getenv("DB_USER"),
                        PWD    = Sys.getenv("DB_PWD"),
                        host = Sys.getenv("DB_HOST"),
                        port = 5432)
  on.exit(DBI::dbDisconnect(con))

  row <-  data.table::data.table(lubridate::now(tzone = "UTC"), session_id)
  DBI::dbAppendTable(con, "wh_api_data", row)

  return(TRUE)

}





#' @describeIn zappier_data_ingest TBD
#' @export
write_session_data <- function(file_name, input_data, apikey){
  jsonlite::write_json(input_data, file_name)
}



#' @describeIn zappier_data_ingest TBD
#' @export
verifyPartnerKey <- function(apikey){
  warning( "NO VERIFICATION PERFORMED (TESTING)")
  return("ABCDEFG")
}
