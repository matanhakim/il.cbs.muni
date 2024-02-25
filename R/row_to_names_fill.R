row_to_names_fill <- function(data, row_number, fill_missing = TRUE, remove_row = TRUE,
                              remove_rows_above = TRUE, sep = "_") {
  if (all(fill_missing)) {
    fill_missing <- rep(TRUE, length(row_number))
  }

  col_names <- data[row_number, ] |>
    dplyr::mutate(
      dplyr::across(dplyr::everything(), as.character)
    ) |>
    tidyr::pivot_longer(!1, names_to = ".names", values_to = ".value") |>
    tidyr::pivot_wider(names_from = 1, values_from = ".value") |>
    dplyr::select(!.names) |>
    tidyr::fill(
      which(fill_missing), .direction = "down"
    ) |>
    tidyr::unite(
      "names",
      dplyr::everything(),
      remove = TRUE,
      na.rm = TRUE
    ) |>
    dplyr::pull(names)

  data |>
    janitor::row_to_names(
      row_number = row_number,
      remove_row = remove_row,
      remove_rows_above = remove_rows_above
    ) |>
    setNames(col_names)
}

