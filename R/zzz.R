.onLoad <- function(libname, pkgname){
  Sys.setenv("DB_HOST" = "159.65.104.28")
  Sys.setenv("DB_NAME" = "cabbage")
  Sys.setenv("DB_USER" = "cabbage")
  Sys.setenv("DB_PWD"  = "cabbage")
}





Sys.setenv("DB_HOST" = "159.65.104.28")
Sys.setenv("DB_NAME" = "cabbage")
Sys.setenv("DB_USER" = "cabbage")
Sys.setenv("DB_PWD"  = "cabbage")
#
con <- DBI::dbConnect(odbc::odbc(),
                      Driver = "PostgreSQL",
                      database = Sys.getenv("DB_NAME"),
                      UID    = Sys.getenv("DB_USER"),
                      PWD    = Sys.getenv("DB_PWD"),
                      host = Sys.getenv("DB_HOST"),
                      port = 5432)

DBI::dbReadTable(con, "wh_api_data")
