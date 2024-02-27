## code to prepare `df_cbs_muni_params` dataset

df_physical <- tibble::tibble(
  year = 2016:2022,
  muni_type = rep("all", length(year)),
  data_domain = rep("physical", length(year)),
  sheet_number = rep(2, length(year)),
  col_names_row_number = rep(list(c(2, 4:5)), length(year)),
  fill_missing = rep(list(c(TRUE, TRUE, FALSE)), length(year))
)

df_budget <- tibble::tibble(
  year = 2016:2022,
  muni_type = rep("all", length(year)),
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
  year = 2011:2022,
  muni_type = rep("all", length(year)),
  data_domain = rep("summary", length(year)),
  sheet_number = c(
    rep(1, 5), # 2011-2015
    rep(4, length(year) - 5) # 2016-2022
  ),
  col_names_row_number = c(
    rep(list(1), 3), # 2011-2013
    rep(list(2), 2), # 2014-2015
    rep(list(2), length(year) - 5) # 2016-2022
  ),
  fill_missing = rep(list(FALSE), length(year))
)

df_labor_force_survey <- tibble::tibble(
  year = 2017:2022,
  muni_type = rep("all", length(year)),
  data_domain = rep("labor_force_survey", length(year)),
  sheet_number = rep(5, length(year)),
  col_names_row_number = rep(list(c(2, 4:5)), length(year)), # 2017-2022
  fill_missing = rep(list(c(TRUE, TRUE, FALSE)), length(year)) # 2017-2022
)

df_social_survey <- tibble::tibble(
  year = 2017:2022,
  muni_type = rep("all", length(year)),
  data_domain = rep("social_survey", length(year)),
  sheet_number = rep(6, length(year)),
  col_names_row_number = rep(list(c(4:5)), length(year)), # 2017-2022
  fill_missing = rep(list(c(TRUE, FALSE)), length(year)) # 2017-2022
)

df_split_muni <- tibble::tibble(
  year = rep(2003:2015, each = 4),
  muni_type = rep(c("city_lc", "city_lc", "rc", "rc"), length(year) / 4),
  data_domain = rep(c("physical", "budget"), length(year) / 2),
  sheet_number = c(
    rep(1:4, 8), # 2003-2010
    rep(2:5, 5) # 2011-2015
  ),
  col_names_row_number = c(
    rep(list(1), 44), # 2003-2013
    rep(list(2), 8) # 2014-2015
  ),
  fill_missing = rep(list(c(FALSE)), length(year)) # 2003-2015
)

df_cbs_muni_params <- dplyr::bind_rows(
  df_physical,
  df_budget,
  df_summary,
  df_labor_force_survey,
  df_social_survey,
  df_split_muni
)
