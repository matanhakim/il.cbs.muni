read_cbs_muni <- function(path, year, data_domain = c("physical", "budget")) {
  params <- df_cbs_muni_params |>
    dplyr::filter(year == {{ year }}, data_domain == {{ data_domain }})

  readxl::read_excel(
    path = path,
    sheet = params$sheet_number,
    col_names = FALSE
  ) |>
  suppressMessages() |>
  row_to_names_fill(
    row_number = unlist(params$col_names_row_number),
    fill_missing = unlist(params$fill_missing)
  )
}
