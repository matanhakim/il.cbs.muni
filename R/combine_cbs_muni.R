combine_cbs_muni <- function(path, year, cols_city, cols_rc, data_domain = c("physical", "budget"), colnames = NULL) {
  df_city <- read_cbs_muni(
    path = path,
    year = {{ year }},
    muni_type = "city_lc",
    data_domain =  {{ data_domain }},
    cols = cols_city
  )

  df_rc <- read_cbs_muni(
    path = path,
    year = {{ year }},
    muni_type = "rc",
    data_domain =  {{ data_domain }},
    cols = cols_rc
  )

  dplyr::bind_rows(df_city, df_rc)
}
