#' Elevate rows to be the column names of a data.frame and fill row-wise if needed
#'
#' Casts data from rows to the column names of a data frame, with the option to fill
#' missing values row-wise. This utility is helpful in the case of merged cells in
#' Microsoft Excel, where the merged range has data only in the first (unmerged) cell.
#' This function is similar to `janitor::row_to_names()`, with the exception of
#' the fill utility.
#'
#' @param data A data frame.
#'
#' @param row_number A numeric vector with he row indices of `data` containing the
#' variable names. Allows for multiple rows input as a numeric vector. If multiple
#' rows, values in the same column would be pasted with the `sep` argument as a
#' separator. NA's are ignored.
#'
#' @param fill_missing A logical vector of length 1 or of length `length(row_number)`.
#' Every value in the vector denotes for the matching row in `data[row_number, ]` if
#' the row should fill missing values (from left to right). If `TRUE` for a row,
#' all missing values following a non-missing value will be replaced with that
#' preceding non-missing value.
#'
#' @param remove_row A logical vector of length 1, denoting if the row `row_number`
#' should be removed from the resulting data.frame.
#'
#' @param remove_rows_above A logical vector of length 1, denoting if the rows above
#' `row_number` - that is, between `1:(row_number-1)` - should be removed
#' from the resulting data.frame, in the case that `row_number != 1`.
#'
#' @param sep A character vector of length 1 to separate the values in the case of
#' multiple rows input to `row_number`.
#'
#' @examples
#' df <- data.frame(
#'   a = 1:6,
#'   b = rep(c("x", NA), 3),
#'   c = letters[1:6]
#' )
#'
#' row_to_names_fill(df, 2:3)
#' row_to_names_fill(df, 2:3, sep = ".")
#' row_to_names_fill(df, 2:4, fill_missing = c(TRUE, FALSE, FALSE))
#'
#' @importFrom rlang .data
row_to_names_fill <- function(data, row_number, fill_missing = TRUE, remove_row = TRUE,
                          remove_rows_above = TRUE, sep = "_") {
    col_names <- purrr::map2(
      row_number,
      fill_missing,
      \(i, fill_missing) fill_row(data, row_number = i, fill_missing, sep = sep)
    ) |>
      dplyr::bind_cols() |>
      suppressMessages() |>
      tidyr::unite(col = "var_names", sep = sep, na.rm = TRUE) |>
      dplyr::pull("var_names")

    if (remove_row) {
      data <- data |>
        dplyr::slice(-row_number)
    }

    if (remove_rows_above & min(row_number) > 1) {
      data <- data |>
        dplyr::slice(-1:(-min(row_number) + 1))
    }

    names(data) <- col_names

    data
  }

  fill_row <- function(data, row_number, fill_missing, sep = "_") {
    data <- data |>
      dplyr::slice(row_number) |>
      dplyr::mutate(dplyr::across(dplyr::everything(), as.character)) |>
      tidyr::pivot_longer(dplyr::everything(), values_to = "value") |>
      dplyr::select("value")

    if (fill_missing) {
      data <- data |>
        tidyr::fill("value")
    }

    data |>
      dplyr::pull("value")
  }
