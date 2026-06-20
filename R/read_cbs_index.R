#' Read a CBS index data file to a tibble
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' This function is a wrapper around `readxl::read_excel()`, reading a CBS
#' socio-economic or peripherality index data file for a specific year. Its added
#' value is in figuring out the file's structure for you: by default it detects
#' the geographic level of the file (municipality, locality or statistical area)
#' from its contents and applies the matching header layout. The full set of
#' header parameters is available with `il.cbs.muni:::df_cbs_index_params`.
#'
#' This function is marked experimental because the CBS index publications are not
#' stable across editions: the same geographic level lives in different table
#' numbers in different years and the file format alternates between `xls` and
#' `xlsx`. Detecting the level from the file content rather than relying on the
#' table number makes the reader robust to that shuffle - you give it one file and
#' it works out what the file is.
#'
#' @details
#' Detection uses the raw row count and a header keyword, which separates the
#' three levels cleanly for the files published so far. It can still be wrong when
#' a file does not match the expected geometry - for example a table that is not a
#' standard index but happens to be municipality-sized, or two different tables in
#' the same edition that share a row-count band. When you know the level, pass it
#' explicitly through `unit_type` to bypass detection.
#'
#' @param path A character vector of length 1, denoting the local file path to the
#'  CBS index data file. A full list of available files by the CBS is at the
#'  relevant CBS page for either [Socio-Economic Status (SES)](https://www.cbs.gov.il/he/subjects/Pages/%D7%9E%D7%93%D7%93-%D7%97%D7%91%D7%A8%D7%AA%D7%99-%D7%9B%D7%9C%D7%9B%D7%9C%D7%99-%D7%A9%D7%9C-%D7%94%D7%A8%D7%A9%D7%95%D7%99%D7%95%D7%AA-%D7%94%D7%9E%D7%A7%D7%95%D7%9E%D7%99%D7%95%D7%AA.aspx)
#'  or for [peripheral level](https://www.cbs.gov.il/he/subjects/Pages/%D7%9E%D7%93%D7%93-%D7%A4%D7%A8%D7%99%D7%A4%D7%A8%D7%99%D7%90%D7%9C%D7%99%D7%95%D7%AA-%D7%A9%D7%9C-%D7%A8%D7%A9%D7%95%D7%99%D7%95%D7%AA-%D7%9E%D7%A7%D7%95%D7%9E%D7%99%D7%95%D7%AA.aspx).
#'  Read a single file per call; to read several files, iterate (e.g. with
#'  [purrr::map()]).
#' @param year  A numeric vector of length 1 denoting which year the data file
#' pointed in `path` is for. Be aware that the year in question is the year
#' **the data is for**, not the year **the data was published in**.
#' @param index_type A character vector of length 1, one of `c("ses", "peri")`.
#' @param unit_type `NULL` (the default) or a character vector of length 1, one of
#' `c("muni", "yishuv", "sa")`, denoting the geographic level: municipality,
#' locality or statistical area. When `NULL`, the level is detected from the file
#' content. When supplied, the given level is used as-is and detection is skipped,
#' which lets you override a misdetection for a file whose level you already know.
#' @param cols <[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)>
#' Columns to keep. The default `NULL` keeps all columns.
#' @param col_names A character vector containing the new column names of the
#' output tibble. If `NULL` then the tibble uses the original column names.
#' Must be the same length as the number of columns picked in `cols`. The names
#' are assigned by position, so they follow the data's column order.
#' @param quiet A logical vector of length 1. When `FALSE` (the default) a message
#' reports the geographic level used. Set to `TRUE` to silence it, for example
#' when iterating over many files.
#'
#' @return A tibble with CBS index data for a specific year, where every row is a
#' single geographic unit (municipality, locality or statistical area) and every
#' column is a different variable for that unit. The geographic level used is also
#' stored in the `"unit_type"` attribute of the result. Be advised all columns are
#' of type character, so you need to parse the data types yourself at will. Column
#' names are merged from the relevant headers, and only single whitespaces are
#' kept. Rows that are 80% or more empty cells (usually rows with non-data notes)
#' are removed.
#' @export
#'
#' @examples
#' read_cbs_index(
#'   path = system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
#'   year = 2019,
#'   index_type = "ses"
#' ) |>
#'   dplyr::glimpse()
read_cbs_index <- function(
  path,
  year,
  index_type = c("ses", "peri"),
  unit_type = NULL,
  cols = NULL,
  col_names = NULL,
  quiet = FALSE
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
  if (!is.numeric(year) || length(year) != 1 || is.na(year)) {
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

  # Validate quiet
  if (!is.logical(quiet) || length(quiet) != 1 || is.na(quiet)) {
    rlang::abort(
      "`quiet` must be a single logical value (TRUE or FALSE).",
      class = "read_cbs_index_invalid_quiet"
    )
  }

  index_type <- rlang::arg_match(index_type)

  # `unit_type` is an optional override. When supplied, validate it and use it
  # as-is; otherwise detect the level from the file content.
  if (!is.null(unit_type)) {
    unit_type <- rlang::arg_match(unit_type, c("muni", "yishuv", "sa"))
  }

  lifecycle::signal_stage("experimental", "read_cbs_index()")

  raw <- readxl::read_excel(
    path = path,
    sheet = 1,
    col_names = FALSE,
    col_types = "text"
  ) |>
    suppressMessages()

  detected <- detect_index_unit_type(raw)
  if (is.null(unit_type)) {
    unit_type <- detected
    verb <- "Detected"
  } else {
    verb <- "Using supplied"
  }

  if (!quiet) {
    rlang::inform(
      paste0(
        verb,
        " ",
        switch(
          unit_type,
          muni = "municipality",
          yishuv = "locality",
          sa = "statistical area"
        ),
        "-level ",
        index_type,
        " index file (",
        nrow(raw),
        " raw rows)."
      ),
      class = "il.cbs.muni_unit_type"
    )
  }

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
          "\"; unit_type = \"",
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

  df <- raw |>
    row_to_names_fill(
      row_number = unlist(params$col_names_row_number),
      fill_missing = unlist(params$fill_missing)
    ) |>
    janitor::remove_empty("rows", cutoff = 0.2)

  # Clean the merged-header column names before any selection so that selecting
  # `cols` by a column name matches the names returned to the user.
  names(df) <- stringr::str_squish(names(df))

  if (!rlang::quo_is_null(rlang::enquo(cols))) {
    df <- df |>
      dplyr::select({{ cols }})
  }

  if (!is.null(col_names)) {
    if (length(col_names) != ncol(df)) {
      rlang::abort(
        c(
          "`col_names` must have the same length as the number of selected columns.",
          "i" = paste0("`col_names` length: ", length(col_names)),
          "x" = paste0("Number of selected columns: ", ncol(df))
        ),
        class = "read_cbs_index_col_names_length"
      )
    }
    names(df) <- col_names
  }

  attr(df, "unit_type") <- unit_type
  df
}

# Detect the geographic level of a raw CBS index sheet from its contents. The
# table number that holds each level is not stable across editions, but the row
# count and a few header keywords are: municipalities are a few hundred rows,
# localities about a thousand, and statistical-area files name the unit
# explicitly and run to several thousand rows.
detect_index_unit_type <- function(raw) {
  n_rows <- nrow(raw)
  head_rows <- raw[seq_len(min(15L, n_rows)), , drop = FALSE]
  txt <- paste(unlist(head_rows), collapse = " ")
  # Statistical-area files name the unit in their bilingual header; the English
  # phrase keeps this check ASCII (R code in a portable package must be ASCII).
  # Row count alone also separates the levels, so this is a second signal.
  is_sa <- grepl("STATISTICAL AREA", txt, ignore.case = TRUE)
  if (is_sa || n_rows > 1450L) {
    "sa"
  } else if (n_rows > 600L) {
    "yishuv"
  } else {
    "muni"
  }
}
