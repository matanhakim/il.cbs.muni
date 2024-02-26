## code to prepare `df_cbs_muni_params` dataset

df_physical <- tibble::tibble(
  year = 2016:2022,
  data_domain = rep("physical", length(year)),
  sheet_number = rep(2, length(year)),
  col_names_row_number = rep(list(c(2, 4:5)), length(year)),
  fill_missing = rep(list(c(TRUE, TRUE, FALSE)), length(year))
)

df_budget <- tibble::tibble(
  year = 2016:2022,
  data_domain = rep("budget", length(year)),
  sheet_number = rep(3, length(year)),
  col_names_row_number = c(
    list(c(2, 4:5)), # 2016
    list(3:7), # 2017
    list(3:7), # 2018
    list(3:7), # 2019
    list(3:7), # 2020
    list(4), # 2021
    list(4) # 2022
  ),
  fill_missing = c(
    list(c(TRUE, TRUE, FALSE)), # 2016
    list(c(TRUE, FALSE, FALSE, FALSE, FALSE)), # 2017
    list(c(TRUE, FALSE, FALSE, FALSE, FALSE)), # 2018
    list(c(TRUE, FALSE, FALSE, FALSE, FALSE)), # 2019
    list(c(TRUE, FALSE, FALSE, FALSE, FALSE)), # 2020
    list(c(TRUE)), # 2021
    list(c(TRUE)) # 2022
  )
)

df_summary <- tibble::tibble(
  year = 2016:2022,
  data_domain = rep("summary", length(year)),
  sheet_number = rep(4, length(year)),
  col_names_row_number = rep(list(2), length(year)),
  fill_missing = rep(list(FALSE), length(year))
)

df_cbs_muni_params <- dplyr::bind_rows(
  df_physical,
  df_budget,
  df_summary
)

usethis::use_data(df_cbs_muni_params, overwrite = TRUE, internal = TRUE)
