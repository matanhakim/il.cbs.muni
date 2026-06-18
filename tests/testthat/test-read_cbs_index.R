test_that("reading an ses index file works and auto-detects municipality level", {
  df <- read_cbs_index(
    path = system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
    year = 2019,
    index_type = "ses"
  )
  expect_equal(df |> names() |> dplyr::nth(3), "שם רשות מקומית")
  expect_equal(ncol(df), 12)
  expect_equal(nrow(df), 255)
  expect_equal(attr(df, "unit_type"), "muni")
})

test_that("reading a periphery index file works and auto-detects municipality level", {
  df <- read_cbs_index(
    path = system.file("extdata", "24_22_420t1.xlsx", package = "il.cbs.muni"),
    year = 2020,
    index_type = "peri"
  )
  expect_equal(
    df |> names() |> dplyr::nth(1),
    "מעמד מוניציפלי_MUNICIPAL STATUS"
  )
  expect_equal(nrow(df), 259)
  expect_equal(attr(df, "unit_type"), "muni")
})

test_that("unit_type overrides detection and drives the matching read path", {
  path <- system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni")

  df_m <- read_cbs_index(path, 2019, "ses", unit_type = "muni", quiet = TRUE)
  expect_equal(attr(df_m, "unit_type"), "muni")
  expect_equal(nrow(df_m), 255)

  df_y <- read_cbs_index(path, 2019, "ses", unit_type = "yishuv", quiet = TRUE)
  expect_equal(attr(df_y, "unit_type"), "yishuv")
  expect_equal(ncol(df_y), 12)

  df_s <- read_cbs_index(path, 2019, "ses", unit_type = "sa", quiet = TRUE)
  expect_equal(attr(df_s, "unit_type"), "sa")
  expect_equal(ncol(df_s), 12)
})

test_that("an invalid unit_type is rejected", {
  expect_error(
    read_cbs_index(
      system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
      2019,
      "ses",
      unit_type = "district",
      quiet = TRUE
    ),
    class = "rlang_error"
  )
})

test_that("quiet controls the unit-type message", {
  path <- system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni")
  expect_message(
    read_cbs_index(path, 2019, "ses"),
    class = "il.cbs.muni_unit_type"
  )
  expect_no_message(read_cbs_index(path, 2019, "ses", quiet = TRUE))
})

test_that("detect_index_unit_type classifies by row count", {
  expect_equal(detect_index_unit_type(data.frame(a = rep("x", 260))), "muni")
  expect_equal(detect_index_unit_type(data.frame(a = rep("x", 1013))), "yishuv")
  expect_equal(detect_index_unit_type(data.frame(a = rep("x", 1651))), "sa")
})

test_that("detect_index_unit_type uses thresholds at the band boundaries", {
  expect_equal(detect_index_unit_type(data.frame(a = rep("x", 600))), "muni")
  expect_equal(detect_index_unit_type(data.frame(a = rep("x", 601))), "yishuv")
  expect_equal(detect_index_unit_type(data.frame(a = rep("x", 1450))), "yishuv")
  expect_equal(detect_index_unit_type(data.frame(a = rep("x", 1451))), "sa")
})

test_that("detect_index_unit_type detects statistical areas by keyword even when small", {
  d <- data.frame(a = c("CODE OF STATISTICAL AREA", rep("x", 90)))
  expect_equal(detect_index_unit_type(d), "sa")
})

test_that("detect_index_unit_type misreads a municipality-sized non-index table as muni", {
  # Regression marker for the known heuristic limitation: a wide non-index table
  # with few rows (e.g. the SES 2021 table 2) is classified muni and would parse
  # silently. Pass unit_type explicitly to override detection for such files.
  wide <- as.data.frame(matrix("x", nrow = 270, ncol = 50))
  expect_equal(detect_index_unit_type(wide), "muni")
})

test_that("throws an informative error for an unsupported combination", {
  expect_error(
    read_cbs_index(
      path = system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
      year = 2099,
      index_type = "ses",
      quiet = TRUE
    ),
    class = "read_cbs_index_unsupported"
  )
})

test_that("validates path, year, col_names and quiet", {
  path <- system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni")
  expect_error(
    read_cbs_index(c("a", "b"), 2019, "ses"),
    class = "read_cbs_index_invalid_path"
  )
  expect_error(
    read_cbs_index("nonexistent.xlsx", 2019, "ses"),
    class = "read_cbs_index_path_not_found"
  )
  expect_error(
    read_cbs_index(path, "2019", "ses"),
    class = "read_cbs_index_invalid_year"
  )
  expect_error(
    read_cbs_index(path, NA_real_, "ses"),
    class = "read_cbs_index_invalid_year"
  )
  expect_error(
    read_cbs_index(path, 2019, "ses", col_names = 1),
    class = "read_cbs_index_invalid_col_names"
  )
  expect_error(
    read_cbs_index(path, 2019, "ses", quiet = "yes"),
    class = "read_cbs_index_invalid_quiet"
  )
})

test_that("cols selects and col_names renames; mismatched length errors", {
  path <- system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni")
  df <- read_cbs_index(
    path,
    2019,
    "ses",
    cols = c(1, 3),
    col_names = c("status", "name"),
    quiet = TRUE
  )
  expect_equal(names(df), c("status", "name"))
  expect_error(
    read_cbs_index(
      path,
      2019,
      "ses",
      cols = c(1, 2),
      col_names = "only_one",
      quiet = TRUE
    ),
    class = "read_cbs_index_col_names_length"
  )
})
