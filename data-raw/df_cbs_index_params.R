df_ses <- tibble::tibble(
  year = c(
    rep(2019, 3),
    rep(2017, 3),
    rep(2015, 2),
    rep(2013, 2)
  ),
  index_type = rep("ses", 10),
  unit_type = c(
    rep(c("muni", "yishuv", "sa"), 2), # 2017, 2019
    rep(c("muni", "yishuv"), 2) # 2015, 2013
  ),
  col_names_row_number = c(
    list(5:6), list(8:9), list(9:10), # 2019
    list(5:6), list(10:11), list(8:9), # 2017
    list(5:6), list(6:7), # 2015
    list(5:8), list (7:8) # 2013
  ),
  fill_missing = rep(list(c(FALSE, FALSE)), 10)
)

df_peri <-  tibble::tibble(
  year = c(
    rep(2020, 2),
    rep(2015, 2),
    2004
  ),
  index_type = rep("peri", 5),
  unit_type = c(
    rep(c("muni", "yishuv"), 2), # 2020, 2015
    "muni" # 2004
  ),
  col_names_row_number = c(
    rep(c(list(6:9), list(4:7)), 2), # 2020, 2015
    list(5:8) #2004
  ),
  fill_missing = rep(list(c(FALSE, FALSE)), 5)
)

df_cbs_index_params <- dplyr::bind_rows(df_ses, df_peri)
