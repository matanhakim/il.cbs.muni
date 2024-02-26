## code to prepare `df_cbs_muni_params` dataset

df_cbs_muni_params <- tibble::tibble(
  year = rep(2016:2022, 2),
  data_domain = rep(c("physical", "budget"), each = length(year) / 2),
  sheet_number = rep(2:3, each = length(year) / 2),
  col_names_row_number = rep(list(4:5), length(year)),
  fill_missing = rep(c(list(c(FALSE, TRUE)), list(c(FALSE, FALSE))), each = length(year) / 2)
)

usethis::use_data(df_cbs_muni_params, overwrite = TRUE, internal = TRUE)
