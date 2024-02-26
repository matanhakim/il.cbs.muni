## code to prepare `df_cbs_muni_params` dataset

df_cbs_muni_params <- tibble::tibble(
  year = rep(2016:2022, each = 2),
  data_domain = rep(c("physical", "budget"), length(year) / 2),
  sheet_number = rep(2:3, length(year) / 2),
  col_names_row_number = c(
    list(c(2, 4:5)), list(c(2, 4:5)), # 2016
    list(c(2, 4:5)), list(3:7), # 2017
    list(c(2, 4:5)), list(3:7), # 2018
    list(c(2, 4:5)), list(3:7), # 2019
    list(c(2, 4:5)), list(3:7), # 2020
    list(c(2, 4:5)), list(3:4), # 2021
    list(c(2, 4:5)), list(3:4) # 2022
  ),
  fill_missing = c(
    list(c(TRUE, TRUE, FALSE)), list(c(TRUE, TRUE, FALSE)), # 2016
    list(c(TRUE, TRUE, FALSE)), list(c(TRUE, FALSE, FALSE, FALSE, FALSE)), # 2017
    list(c(TRUE, TRUE, FALSE)), list(c(TRUE, FALSE, FALSE, FALSE, FALSE)), # 2018
    list(c(TRUE, TRUE, FALSE)), list(c(TRUE, FALSE, FALSE, FALSE, FALSE)), # 2019
    list(c(TRUE, TRUE, FALSE)), list(c(TRUE, FALSE, FALSE, FALSE, FALSE)), # 2020
    list(c(TRUE, TRUE, FALSE)), list(c(TRUE, FALSE)), # 2021
    list(c(TRUE, TRUE, FALSE)), list(c(TRUE, FALSE)) # 2022
  )
)

usethis::use_data(df_cbs_muni_params, overwrite = TRUE, internal = TRUE)
