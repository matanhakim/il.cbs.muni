## code to prepare `df_muni_id` dataset

# df_muni_tax <- read.delim("clipboard", sep = " ")
# req_muni_tax <- httr2::request("https://data.gov.il/api/3/action/datastore_search") |>
#   httr2::req_url_query(
#     resource_id = "c4916937-f5d3-4295-a22e-88a1af5cde6a"
#   )
# resp_muni_tax <- req_muni_tax |>
#   httr2::req_perform()
#
# resp_muni_tax_json <-
#
# x <- tibble::tibble(
#   data =  resp_muni_tax |>
#     httr2::resp_body_json() |>
#     purrr::pluck("result", "records")
# ) |>
#   tidyr::unnest_wider(data) |>
#   dplyr::select(
#     muni_id = CouncilCode,
#     muni_type = CouncilType,
#     tax_name = CouncilShortName,
#     tax_id = CouncilHPNumber
#   )

df_muni_id <- readr::read_csv(
  "https://raw.githubusercontent.com/matanhakim/general_files/main/muni_ids.csv",
  col_types = readr::cols(.default = readr::col_character())
) |>
  dplyr::rename(
    muni_id = cbs_id,
    muni_name = cbs_name
  )

usethis::use_data(df_muni_id, internal = TRUE, overwrite = TRUE)
