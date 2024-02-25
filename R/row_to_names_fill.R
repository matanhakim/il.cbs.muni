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
      dplyr::pull(var_names)

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
      tidyr::pivot_longer(dplyr::everything()) |>
      dplyr::select(value)

    if (fill_missing) {
      data <- data |>
        tidyr::fill(value)
    }

    data |>
      dplyr::pull(value)
  }
