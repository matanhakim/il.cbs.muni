#' Combine municipalities data frames from different sheets
#'
#' This function is a wrapper around `read_cbs_muni()` to help in combining data
#' for cities, local councils and regional councils.
#' From 2015 and earlier, the Israeli CBS publishes municipal data on different
#' sheets and formats for cities and local councils, and for regional councils.
#' This function enables the user to combine the two data frames for selected
#' columns. It is up to the user to take care of the specific match between specific
#' columns.
#'
#' @param path A character vector of length 1, denoting the local file path to the
#'  municipal data file. A full list of available files by the CBS is at the
#'  [relevant CBS page](https://www.cbs.gov.il/he/publications/Pages/2019/%D7%94%D7%A8%D7%A9%D7%95%D7%99%D7%95%D7%AA-%D7%94%D7%9E%D7%A7%D7%95%D7%9E%D7%99%D7%95%D7%AA-%D7%91%D7%99%D7%A9%D7%A8%D7%90%D7%9C-%D7%A7%D7%95%D7%91%D7%A6%D7%99-%D7%A0%D7%AA%D7%95%D7%A0%D7%99%D7%9D-%D7%9C%D7%A2%D7%99%D7%91%D7%95%D7%93-1999-2017.aspx).
#' @param year A numeric vector of length 1 denoting which year the data file
#' pointed in `path` is for. Currently supporting 2003-2015, since before 2003 the
#' data structure is very different, and after 2015 the file is already combined.
#' @param cols_city <[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)>
#'  Columns to keep from the cities and local councils sheet.
#' @param cols_rc <[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)>
#'  Columns to keep from the regional councils sheet. Should be in the same order
#'  of desired columns as in `cols_city`, since the columns are matched by order.
#' @param data_domain A character vector of length 1, one of
#' `c("physical", "budget")`. Every Excel municipal data file has a few different
#' data domains, most notably physical and population data, and budget data.
#' @param col_names A character vector containing the new column names of the
#' output tibble. If `NULL` then the tibble uses the original column names.
#' Must be the same length as the number of columns picked in `cols`. If not `NULL`,
#' overrides the choice in `col_names_from`.
#' @param col_names_from A character vector of length 1, one of
#' `c("city_lc", "rc")`. Denotes which column names should be kept - those from the
#' cities and local councils sheet, or those from the regional councils sheet.
#'
#' @return A tibble with municipal data for a specific year, with the columns from
#' `cols_city` and `cols_rc` binded by rows and matched by order of columns. Every row is a
#' municipality and every column is a different variable for this municipality in
#' that year. Be advised all columns are of type character, so you need to parse
#' the data types yourself at will. Column names are merged from the relevant headers,
#' and only single whitespaces are kept. Rows with more than 90% empty cells (usually
#' rows with non-data notes) are removed.
#' @export
#' @md
#'
#' @examples
#' df_1 <- combine_cbs_muni(
#'   system.file("extdata", "2009.xls", package = "il.cbs.muni"),
#'   year = 2009,
#'   cols_city = c(1:7, 11),
#'   cols_rc = c(1:7, 25)
#' )
#'
#' df_1 |>
#'   dplyr::glimpse()
#'
#' df_2 <- combine_cbs_muni(
#'   system.file("extdata", "2009.xls", package = "il.cbs.muni"),
#'   year = 2009,
#'   cols_city = c(1:12),
#'   cols_rc = c(1:12),
#'   data_domain = "budget",
#'   col_names_from = "rc"
#' )
#'
#' df_2 |>
#'   dplyr::glimpse()
combine_cbs_muni <- function(
    path, year, cols_city, cols_rc, data_domain = c("physical", "budget"),
    col_names = NULL, col_names_from = c("city_lc", "rc")) {

  data_domain <- rlang::arg_match(data_domain)
  col_names_from <- rlang::arg_match(col_names_from)

  df_city <- read_cbs_muni(
    path = path,
    year = {{ year }},
    muni_type = "city_lc",
    data_domain =  {{ data_domain }},
    cols = cols_city
  )

  df_rc <- read_cbs_muni(
    path = path,
    year = {{ year }},
    muni_type = "rc",
    data_domain =  {{ data_domain }},
    cols = cols_rc
  )

  if (!is.null(col_names)) {
    names(df) <- col_names
  } else {
    if (col_names_from == "city_lc")
      names(df_rc) <- names(df_city)
    else if (col_names_from == "rc")
      names(df_city) <- names(df_rc)
    else
      stop("`col_names_from` must be one of `c('city_lc', 'rc')`")
  }

  dplyr::bind_rows(df_city, df_rc)
}
