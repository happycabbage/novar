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

  if (is.null(apikey))
    stop( "Argument partner_key missing and required" )

  partner_guid <- verifyPartnerKey( apikey )

  ts_utc_int <- ceiling(as.numeric(lubridate::now(tzone = "UTC")))
  input_data <- rlang::dots_values(...)

  return( list("partner_guid" = partner_guid,
               "sent_utc_int" = ts_utc_int,
               "received_dat" = input_data) )
}


#' @describeIn zappier_data_ingest TBD
#' @export
verifyPartnerKey <- function(apikey){
  warning( "NO VERIFICATION PERFORMED (TESTING)" )
  return("ABCDEFG")
}


