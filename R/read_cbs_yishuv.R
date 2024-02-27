#' Read a yishuvim data file to a tibble
#'
#' This function is a wrapper around `readxl::read_excel()`, reading a specific
#' yishuvim data file or a part of it. A yishuv, or a point of residence, is a
#' geographically defined place where people live. Some yishuvim are municipalities,
#' in the case of of cities and local councils, but most are not. most yishuvim are
#' part of municipalities that are regional councils. Also, some yishuvim are not
#' themselves and are not part of a municipality, like some Bedouin places in
#' southern Israel, some industry areas, Mikveh Israel, and more.
#'
#' @param path A character vector of length 1, denoting the local file path to the
#'  yishuvim data file. A full list of available files by the CBS is at the
#'  [relevant CBS page](https://www.cbs.gov.il/he/publications/Pages/2019/%D7%99%D7%99%D7%A9%D7%95%D7%91%D7%99%D7%9D-%D7%91%D7%99%D7%A9%D7%A8%D7%90%D7%9C.aspx).
#' @param cols <[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)>
#'  Columns to keep. The default `NULL` keeps all columns.
#'
#' @return A tibble with yishuvim data for a specific year, where every row is a
#' yishuv and every column is a different variable for this yishuv in
#' that year. Be advised all columns are of type character, so you need to parse
#' the data types yourself at will. Column names are cleaned so only single
#' whitespaces are kept.
#' @export
#'
#' @examples
#' library(dplyr)
#' read_cbs_yishuv(system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni")) |>
#'   dplyr::glimpse()
#'
#' read_cbs_yishuv(
#'   system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni"),
#'   cols = c(1, 2, 5, 13)
#' ) |>
#'   mutate(across(2, pad_yishuv_id)) |>
#'   glimpse()
read_cbs_yishuv <- function(path, cols = NULL) {
  df <- readxl::read_excel(
    path = path,
    sheet = 1,
    col_names = TRUE,
    col_types = "text"
  )

  if (!rlang::quo_is_null(rlang::enquo(cols))) {
    df <- df |>
      dplyr::select(dplyr::all_of({{ cols }}))
  }

  names(df) <- df |>
    names() |>
    stringr::str_squish()

  df
}
