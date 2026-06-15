# Guards on the internal parameter tables. The original periphery / SES 2013
# crash came from a `fill_missing` whose length did not match
# `col_names_row_number`; these invariants make that class of bug fail at test
# time instead of when a user reads a file.

test_that("every index param row has a valid fill_missing length", {
  p <- df_cbs_index_params
  row_lens <- lengths(p$col_names_row_number)
  fill_lens <- lengths(p$fill_missing)
  invalid <- p[
    !(fill_lens == 1L | fill_lens == row_lens),
    c("year", "index_type", "unit_type")
  ]
  expect_equal(nrow(invalid), 0L)
})

test_that("every muni param row has a valid fill_missing length", {
  p <- df_cbs_muni_params
  row_lens <- lengths(p$col_names_row_number)
  fill_lens <- lengths(p$fill_missing)
  invalid <- p[
    !(fill_lens == 1L | fill_lens == row_lens),
    c("year", "muni_type", "data_domain")
  ]
  expect_equal(nrow(invalid), 0L)
})

test_that("index params have unique year / index_type / unit_type keys", {
  p <- df_cbs_index_params
  expect_equal(anyDuplicated(paste(p$year, p$index_type, p$unit_type)), 0L)
})

test_that("muni params have unique year / muni_type / data_domain keys", {
  p <- df_cbs_muni_params
  expect_equal(anyDuplicated(paste(p$year, p$muni_type, p$data_domain)), 0L)
})

test_that("muni param sheet numbers are all present", {
  expect_equal(sum(is.na(df_cbs_muni_params$sheet_number)), 0L)
})

test_that("physical and budget params cover 2016 through 2024", {
  p <- df_cbs_muni_params
  expect_equal(
    sort(p$year[p$muni_type == "all" & p$data_domain == "physical"]),
    2016:2024
  )
  expect_equal(
    sort(p$year[p$muni_type == "all" & p$data_domain == "budget"]),
    2016:2024
  )
})

test_that("ses muni index params cover the 2013-2021 editions", {
  p <- df_cbs_index_params
  years <- sort(p$year[p$index_type == "ses" & p$unit_type == "muni"])
  expect_equal(years, c(2013, 2015, 2017, 2019, 2021))
})

test_that("periphery index params exist for muni and yishuv", {
  p <- df_cbs_index_params
  expect_setequal(
    p$year[p$index_type == "peri" & p$unit_type == "muni"],
    c(2004, 2015, 2020)
  )
  expect_setequal(
    p$year[p$index_type == "peri" & p$unit_type == "yishuv"],
    c(2015, 2020)
  )
})
