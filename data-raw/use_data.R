# Run this file after running other scripts in this `data-raw` folder

usethis::use_data(
  df_cbs_muni_params,
  df_muni_id,
  df_cbs_index_params,
  internal = TRUE, overwrite = TRUE
)
