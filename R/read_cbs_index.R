#' Read a CBS index data file to a tibble
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' This function is a wrapper around `readxl::read_excel()`, reading a specific
#' CBS index data file for a specific year and a specific data domain. Its added
#' value is in its pre-defined parameters for every year and its specific quirks
#' in the Excel headers. For advanced users,the full set of options is available
#' with `il.cbs.muni:::df_cbs_index_params`.
#'
#' This function is marked experimental because the CBS index publications are
#' not stable across editions: the same geographic level (`unit_type`) is found
#' in different table numbers in different years, the file format alternates
#' between `xls` and `xlsx`, and some editions split a level across several
#' tables. The function does not pick the file for you - it only knows how to
#' read the headers - so you must download the file that matches `unit_type` for
#' the requested `year`. Always sanity-check the row count after reading
#' (municipalities are about 255 rows, localities about 1,000, statistical areas
#' about 1,600).
#'
#' @param path A character vector of length 1, denoting the local file path to the
#'  CBS index data file. A full list of available files by the CBS is at the
#'  relevant CBS page for either [Socio-Economic Status (SES)](https://www.cbs.gov.il/he/subjects/Pages/%D7%9E%D7%93%D7%93-%D7%97%D7%91%D7%A8%D7%AA%D7%99-%D7%9B%D7%9C%D7%9B%D7%9C%D7%99-%D7%A9%D7%9C-%D7%94%D7%A8%D7%A9%D7%95%D7%99%D7%95%D7%AA-%D7%94%D7%9E%D7%A7%D7%95%D7%9E%D7%99%D7%95%D7%AA.aspx)
#'  or for [peripheral level](https://www.cbs.gov.il/he/subjects/Pages/%D7%9E%D7%93%D7%93-%D7%A4%D7%A8%D7%99%D7%A4%D7%A8%D7%99%D7%90%D7%9C%D7%99%D7%95%D7%AA-%D7%A9%D7%9C-%D7%A8%D7%A9%D7%95%D7%99%D7%95%D7%AA-%D7%9E%D7%A7%D7%95%D7%9E%D7%99%D7%95%D7%AA.aspx).
#' @param year  A numeric vector of length 1 denoting which year the data file
#' pointed in `path` is for. Be aware that the year in question is the year
#' **the data is for**, not the year **the data was published in**.
#' @param index_type A character vector of length 1, one of `c("ses", "peri")`.
#' @param unit_type A character vector of length 1, one of `c("muni", "yishuv", "sa")`.
#'
#' * `"muni"` - every row is a municipality.
#'
#' * `"yishuv"` - every row is a yishuv. In some years and indices this includes all yishuvim,
#' in others only yishuvim within regional councils.
#'
#' * `"sa"` - every row is a statistical area within a city or local council.
#' @param cols <[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)>
#' Columns to keep. The default `NULL` keeps all columns.
#' @param col_names A character vector containing the new column names of the
#' output tibble. If `NULL` then the tibble uses the original column names.
#' Must be the same length as the number of columns picked in `cols`.
#'
#' @return A tibble with CBS index data for a specific year, where every row is a
#' `unit_type` and every column is a different variable for this `unit_type` in
#' that year. Be advised all columns are of type character, so you need to parse
#' the data types yourself at will. Column names are merged from the relevant headers,
#' and only single whitespaces are kept. Rows with more than 90% empty cells (usually
#' rows with non-data notes) are removed.
#' @export
#'
#' @examples
#' read_cbs_index(
#'   path = system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
#'   year = 2019,
#'   index_type = "ses",
#'   unit_type = "muni"
#' ) |>
#'   dplyr::glimpse()
read_cbs_index <- function(
  path,
  year,
  index_type = c("ses", "peri"),
  unit_type = c("muni", "yishuv", "sa"),
  cols = NULL,
  col_names = NULL
) {
  # Validate path
  if (!is.character(path) || length(path) != 1) {
    rlang::abort(
      "`path` must be a character vector of length 1.",
      class = "read_cbs_index_invalid_path"
    )
  }

  if (!file.exists(path)) {
    rlang::abort(
      c(
        "`path` does not exist.",
        "i" = paste0("Provided path: ", path)
      ),
      class = "read_cbs_index_path_not_found"
    )
  }

  # Validate year
  if (!is.numeric(year) || length(year) != 1) {
    rlang::abort(
      "`year` must be a numeric vector of length 1.",
      class = "read_cbs_index_invalid_year"
    )
  }

  # Validate col_names if provided
  if (!is.null(col_names) && !is.character(col_names)) {
    rlang::abort(
      "`col_names` must be NULL or a character vector.",
      class = "read_cbs_index_invalid_col_names"
    )
  }

  index_type <- rlang::arg_match(index_type)
  unit_type <- rlang::arg_match(unit_type)

  lifecycle::signal_stage("experimental", "read_cbs_index()")

  params <- df_cbs_index_params |>
    dplyr::filter(
      year == {{ year }},
      index_type == {{ index_type }},
      unit_type == {{ unit_type }}
    )

  if (nrow(params) != 1) {
    supported <- df_cbs_index_params |>
      dplyr::filter(
        index_type == {{ index_type }},
        unit_type == {{ unit_type }}
      ) |>
      dplyr::pull("year") |>
      sort()
    rlang::abort(
      c(
        "No built-in parameters for this combination.",
        "i" = paste0(
          "Requested: year = ",
          year,
          ", index_type = \"",
          index_type,
          "\", unit_type = \"",
          unit_type,
          "\"."
        ),
        "i" = if (length(supported) > 0) {
          paste0(
            "Supported years for this index_type/unit_type: ",
            paste(supported, collapse = ", "),
            "."
          )
        } else {
          "This index_type/unit_type combination is not supported for any year."
        },
        "i" = "See `il.cbs.muni:::df_cbs_index_params` for all supported combinations."
      ),
      class = "read_cbs_index_unsupported"
    )
  }

  df <- readxl::read_excel(
    path = path,
    sheet = 1,
    col_names = FALSE,
    col_types = "text"
  ) |>
    suppressMessages() |>
    row_to_names_fill(
      row_number = unlist(params$col_names_row_number),
      fill_missing = unlist(params$fill_missing)
    ) |>
    janitor::remove_empty("rows", cutoff = 0.2)

  if (!rlang::quo_is_null(rlang::enquo(cols))) {
    df <- df |>
      dplyr::select(dplyr::all_of({{ cols }}))
  }

  if (!is.null(col_names)) {
    names(df) <- col_names
  } else {
    names(df) <- df |>
      names() |>
      stringr::str_squish()
  }

  df
}
