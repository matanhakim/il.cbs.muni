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
#' `cols_city` and `cols_rc` bound by rows and matched by order of columns. Every row is a
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
#' \donttest{
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
#' }
combine_cbs_muni <- function(
    path, year, cols_city, cols_rc, data_domain = c("physical", "budget"),
    col_names = NULL, col_names_from = c("city_lc", "rc")) {

  # Validate path
  if (!is.character(path) || length(path) != 1) {
    rlang::abort(
      "`path` must be a character vector of length 1.",
      class = "combine_cbs_muni_invalid_path"
    )
  }
  
  # Validate year
  if (!is.numeric(year) || length(year) != 1 || is.na(year)) {
    rlang::abort(
      "`year` must be a numeric vector of length 1.",
      class = "combine_cbs_muni_invalid_year"
    )
  }

  # Validate col_names if provided
  if (!is.null(col_names) && !is.character(col_names)) {
    rlang::abort(
      "`col_names` must be NULL or a character vector.",
      class = "combine_cbs_muni_invalid_col_names"
    )
  }

  # Validate that the column selections were supplied
  if (missing(cols_city) || missing(cols_rc)) {
    rlang::abort(
      "`cols_city` and `cols_rc` must both be supplied.",
      class = "combine_cbs_muni_missing_cols"
    )
  }

  data_domain <- rlang::arg_match(data_domain)
  col_names_from <- rlang::arg_match(col_names_from)

  df_city <- read_cbs_muni(
    path = path,
    year = {{ year }},
    muni_type = "city_lc",
    data_domain =  {{ data_domain }},
    cols = {{ cols_city }}
  )

  df_rc <- read_cbs_muni(
    path = path,
    year = {{ year }},
    muni_type = "rc",
    data_domain =  {{ data_domain }},
    cols = {{ cols_rc }}
  )

  # Columns are matched by position, so the two sheets must contribute the same
  # number of columns. Otherwise `bind_rows()` would align by name and silently
  # misplace the regional-council data.
  if (ncol(df_city) != ncol(df_rc)) {
    rlang::abort(
      c(
        "`cols_city` and `cols_rc` must select the same number of columns.",
        "i" = paste0("`cols_city` selected ", ncol(df_city), " column(s)."),
        "i" = paste0("`cols_rc` selected ", ncol(df_rc), " column(s)."),
        "x" = "Columns are matched by position, so the counts must match."
      ),
      class = "combine_cbs_muni_cols_length_mismatch"
    )
  }

  if (!is.null(col_names)) {
    if (length(col_names) != ncol(df_city)) {
      rlang::abort(
        c(
          "`col_names` must have the same length as the number of selected columns.",
          "i" = paste0("`col_names` length: ", length(col_names)),
          "x" = paste0("Number of selected columns: ", ncol(df_city))
        ),
        class = "combine_cbs_muni_col_names_length"
      )
    }
    names(df_rc) <- col_names
    names(df_city) <- col_names
  } else if (col_names_from == "city_lc") {
    names(df_rc) <- names(df_city)
  } else {
    names(df_city) <- names(df_rc)
  }

  dplyr::bind_rows(df_city, df_rc)
}
