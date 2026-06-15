## code to prepare `df_cbs_index_params` dataset
##
## One row per (index_type, year, unit_type). `col_names_row_number` lists the
## Excel rows that together form the column headers. `fill_missing` says, per
## header row, whether merged-cell gaps should be filled left-to-right.
##
## `fill_missing` is a single `FALSE` (length 1, recycled to the length of
## `col_names_row_number`). It used to be a fixed length-2 vector, which silently
## mismatched the 4-row periphery headers and the 4-row SES 2013 header and made
## `read_cbs_index()` error for every periphery year and for SES 2013. The
## length-1 form is correct for every header height. The invariant
## (`length(fill_missing) == 1 || == length(col_names_row_number)`) is guarded by
## tests/testthat/test-cbs_params.R so the mismatch cannot return.

df_cbs_index_params <- tibble::tibble(
  year = c(
    2021, # ses muni (added; structurally identical to 2019)
    2019,
    2019,
    2019,
    2017,
    2017,
    2017,
    2015,
    2015,
    2013,
    2013,
    2020,
    2020,
    2015,
    2015,
    2004
  ),
  index_type = c(rep("ses", 11), rep("peri", 5)),
  unit_type = c(
    "muni", # 2021 ses
    "muni",
    "yishuv",
    "sa", # 2019 ses
    "muni",
    "yishuv",
    "sa", # 2017 ses
    "muni",
    "yishuv", # 2015 ses
    "muni",
    "yishuv", # 2013 ses
    "muni",
    "yishuv", # 2020 peri
    "muni",
    "yishuv", # 2015 peri
    "muni" # 2004 peri
  ),
  col_names_row_number = list(
    5:6, # 2021 ses muni
    5:6,
    8:9,
    9:10, # 2019 ses muni / yishuv / sa
    5:6,
    10:11,
    8:9, # 2017 ses muni / yishuv / sa
    5:6,
    6:7, # 2015 ses muni / yishuv
    5:8,
    7:8, # 2013 ses muni / yishuv
    6:9,
    4:7, # 2020 peri muni / yishuv
    6:9,
    4:7, # 2015 peri muni / yishuv
    5:8 # 2004 peri muni
  ),
  fill_missing = rep(list(FALSE), 16)
)
