#' Read a municipal data file to a tibble
#'
#' This function is a wrapper around `readxl::read_excel()`, reading a specific
#' municipal data file for a specific year and a specific data domain. Its added
#' value is in its use of `row_to_names_fill()` and its pre-defined parameters for
#' every year and its specific quirks in the Excel headers. For advanced users,
#' the full set of options is available with `il.cbs.muni:::df_cbs_muni_params`.
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
#' @param keep_summary_rows `r lifecycle::badge("experimental")` A logical vector
#' of length 1. From 2022 onwards the `"physical"` and `"budget"` sheets open with
#' aggregate summary rows (national total and one row per municipal status) that
#' have no authority symbol. When `FALSE` (the default) these rows are dropped so
#' that every returned row is a single municipality, matching earlier years. Set
#' to `TRUE` to keep them. Has no effect on other data domains.
#' @param cols <[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)>
#'  Columns to keep. The default `NULL` keeps all columns.
#' @param col_names A character vector containing the new column names of the
#' output tibble. If `NULL` then the tibble uses the original column names.
#' Must be the same length as the number of columns picked in `cols`.
#'
#' @return A tibble with municipal data for a specific year, where every row is a
#' municipality and every column is a different variable for this municipality in
#' that year. Be advised all columns are of type character, so you need to parse
#' the data types yourself at will. Column names are merged from the relevant headers,
#' and only single whitespaces are kept. Rows with more than 90% empty cells (usually
#' rows with non-data notes) are removed.
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
  path,
  year,
  muni_type = c("all", "city_lc", "rc"),
  data_domain = c(
    "physical",
    "budget",
    "summary",
    "labor_force_survey",
    "social_survey"
  ),
  keep_summary_rows = FALSE,
  cols = NULL,
  col_names = NULL
) {
  # Validate path
  if (!is.character(path) || length(path) != 1) {
    rlang::abort(
      "`path` must be a character vector of length 1.",
      class = "read_cbs_muni_invalid_path"
    )
  }

  if (!file.exists(path)) {
    rlang::abort(
      c(
        "`path` does not exist.",
        "i" = paste0("Provided path: ", path)
      ),
      class = "read_cbs_muni_path_not_found"
    )
  }

  # Validate year
  if (!is.numeric(year) || length(year) != 1) {
    rlang::abort(
      "`year` must be a numeric vector of length 1.",
      class = "read_cbs_muni_invalid_year"
    )
  }

  # Validate col_names if provided
  if (!is.null(col_names) && !is.character(col_names)) {
    rlang::abort(
      "`col_names` must be NULL or a character vector.",
      class = "read_cbs_muni_invalid_col_names"
    )
  }

  # Validate keep_summary_rows
  if (
    !is.logical(keep_summary_rows) ||
      length(keep_summary_rows) != 1 ||
      is.na(keep_summary_rows)
  ) {
    rlang::abort(
      "`keep_summary_rows` must be a single logical value (TRUE or FALSE).",
      class = "read_cbs_muni_invalid_keep_summary_rows"
    )
  }

  muni_type <- rlang::arg_match(muni_type)
  data_domain <- rlang::arg_match(data_domain)

  params <- df_cbs_muni_params |>
    dplyr::filter(
      year == {{ year }},
      muni_type == {{ muni_type }},
      data_domain == {{ data_domain }}
    )

  if (nrow(params) != 1) {
    supported <- df_cbs_muni_params |>
      dplyr::filter(
        muni_type == {{ muni_type }},
        data_domain == {{ data_domain }}
      ) |>
      dplyr::pull("year") |>
      sort()
    rlang::abort(
      c(
        "No built-in parameters for this combination.",
        "i" = paste0(
          "Requested: year = ",
          year,
          ", muni_type = \"",
          muni_type,
          "\", data_domain = \"",
          data_domain,
          "\"."
        ),
        "i" = if (length(supported) > 0) {
          paste0(
            "Supported years for this muni_type/data_domain: ",
            paste(supported, collapse = ", "),
            "."
          )
        } else {
          "This muni_type/data_domain combination is not supported for any year."
        },
        "i" = "See `il.cbs.muni:::df_cbs_muni_params` for all supported combinations."
      ),
      class = "read_cbs_muni_unsupported"
    )
  }

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
    ) |>
    janitor::remove_empty("rows", cutoff = 0.1)

  # From 2022 the physical and budget sheets open with aggregate summary rows
  # (national total and one per municipal status) that carry no authority symbol
  # in the second column. Drop them unless the user asks to keep them, so every
  # row is a single municipality as documented.
  if (!keep_summary_rows && data_domain %in% c("physical", "budget")) {
    df <- drop_summary_rows(df, symbol_col = 2)
  }

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

# Drop CBS aggregate summary rows (national total and per municipal-status
# subtotals). They are identified by an empty authority symbol in `symbol_col`,
# whereas every real municipality has a symbol there. Returns `df` unchanged if
# it has fewer than `symbol_col` columns.
drop_summary_rows <- function(df, symbol_col = 2) {
  if (ncol(df) < symbol_col) {
    return(df)
  }
  symbol <- df[[symbol_col]]
  keep <- !is.na(symbol) & trimws(symbol) != ""
  df[keep, , drop = FALSE]
}
