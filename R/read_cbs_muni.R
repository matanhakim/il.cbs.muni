#' Read a municipal data file to a tibble
#'
#' This function is a wrapper around `readxl::readexcel()`, reading a specific
#' municipal data file for a specific year and a specific data domain. Its added
#' value is in its use of `row_to_names_fill()` and its pre-defined parameters for
#' every year and its specific quirks in the Excel headers.
#'
#' @param path A character vector of length 1, denoting the local file path to the
#'  municipal data file. A full list of available files by the CBS is at the
#'  [relevant CBS page](https://www.cbs.gov.il/he/publications/Pages/2019/%D7%94%D7%A8%D7%A9%D7%95%D7%99%D7%95%D7%AA-%D7%94%D7%9E%D7%A7%D7%95%D7%9E%D7%99%D7%95%D7%AA-%D7%91%D7%99%D7%A9%D7%A8%D7%90%D7%9C-%D7%A7%D7%95%D7%91%D7%A6%D7%99-%D7%A0%D7%AA%D7%95%D7%A0%D7%99%D7%9D-%D7%9C%D7%A2%D7%99%D7%91%D7%95%D7%93-1999-2017.aspx).
#' @param year A numeric vector of length 1 denoting which year the data file
#' pointed in `path` is for. Currently supporting only 2003 and later, since before
#' 2003 the data structure is very different.
#' @param muni_type A character vector of length 1, one of
#' `c("all", "city_lc", "rc")`. Since 2016, all municipal types are bundled together
#' in the same sheets, but before 2016 there are different sheets for cities and
#' local councils (`"city_lc"`) and regional councils (`"rc"`). This parameter
#' chooses which sheet you would read.
#' @param data_domain A character vector of length 1, one of
#' `c("physical", "budget", "summary", "labor_force_survey", "social_survey")`.
#' Every Excel municipal data file has a few different data domains, most notably
#' physical and population data, and budget data.
#' @param cols <[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)>
#'  Columns to keep. The default `NULL` keeps all columns.
#'
#' @return A tibble with municipal data for a specific year, where every row is a
#' municipality and every column is a different variable for this municipality in
#' that year. Be advised all columns are of type character, so you nee to parse
#' the data types yourself at will. Column names are merged from the relevant headers,
#' and only single whitespaces are kept.
#' @export
#' @md
#'
#' @examples
#' df <- read_cbs_muni(
#'   system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
#'   year = 2021,
#'   data_domain = "physical"
#' )
#'
#' df |>
#'   dplyr::select(1:15) |>
#'   dplyr::glimpse()
read_cbs_muni <- function(
    path, year,
    muni_type = c("all", "city_lc", "rc"),
    data_domain = c("physical", "budget", "summary", "labor_force_survey", "social_survey"),
    cols = NULL) {
  params <- df_cbs_muni_params |>
    dplyr::filter(year == {{ year }}, data_domain == {{ data_domain }})

  df <- readxl::read_excel(
    path = path,
    sheet = params$sheet_number,
    col_names = FALSE,
    col_types = "text"
  ) |>
  suppressMessages() |>
  row_to_names_fill(
    row_number = unlist(params$col_names_row_number),
    fill_missing = unlist(params$fill_missing)
  )

  if (!rlang::quo_is_null(rlang::enquo(cols))) {
    df <- df |>
      dplyr::select({{ cols }})
  }

    names(df) <- df |>
      names() |>
      stringr::str_squish()

    df
}
