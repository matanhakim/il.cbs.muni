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
  # `unit_type` is validated by rlang::arg_match(); the message text is owned by
  # rlang, so assert the class rather than snapshotting third-party wording.
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

test_that("reads a real locality (yishuv) index fixture via the override", {
  df <- read_cbs_index(
    test_path("fixtures", "ses_2019_yishuv_sample.xlsx"),
    year = 2019,
    index_type = "ses",
    unit_type = "yishuv",
    quiet = TRUE
  )
  expect_equal(attr(df, "unit_type"), "yishuv")
  expect_equal(ncol(df), 8)
  expect_equal(nrow(df), 9)
  expect_equal(df |> names() |> dplyr::nth(7), "שם יישוב")
})

test_that("reads a real statistical-area (sa) index fixture via the override", {
  df <- read_cbs_index(
    test_path("fixtures", "ses_2019_sa_sample.xlsx"),
    year = 2019,
    index_type = "ses",
    unit_type = "sa",
    quiet = TRUE
  )
  expect_equal(attr(df, "unit_type"), "sa")
  expect_equal(ncol(df), 8)
  expect_equal(nrow(df), 8)
  expect_equal(
    df |> names() |> dplyr::nth(7),
    "סמל אזור סטטיסטי_CODE OF STATISTICAL AREA"
  )
})

test_that("cols selects and col_names renames", {
  df <- read_cbs_index(
    system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
    2019,
    "ses",
    cols = c(1, 3),
    col_names = c("status", "name"),
    quiet = TRUE
  )
  expect_equal(names(df), c("status", "name"))
})

test_that("an unsupported year/unit_type combination errors informatively", {
  expect_snapshot(
    error = TRUE,
    read_cbs_index(
      system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
      year = 2099,
      index_type = "ses",
      quiet = TRUE
    )
  )
  expect_snapshot(
    error = TRUE,
    read_cbs_index(
      system.file("extdata", "24_22_420t1.xlsx", package = "il.cbs.muni"),
      year = 2099,
      index_type = "peri",
      unit_type = "sa",
      quiet = TRUE
    )
  )
})

test_that("invalid path, year, col_names and quiet error", {
  path <- system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni")
  expect_snapshot(error = TRUE, read_cbs_index(c("a", "b"), 2019, "ses"))
  expect_snapshot(error = TRUE, read_cbs_index("nonexistent.xlsx", 2019, "ses"))
  expect_snapshot(error = TRUE, read_cbs_index(path, "2019", "ses"))
  expect_snapshot(error = TRUE, read_cbs_index(path, NA_real_, "ses"))
  expect_snapshot(error = TRUE, read_cbs_index(path, 2019, "ses", col_names = 1))
  expect_snapshot(
    error = TRUE,
    read_cbs_index(path, 2019, "ses", quiet = "yes")
  )
})

test_that("col_names length must match the selected columns", {
  expect_snapshot(
    error = TRUE,
    read_cbs_index(
      system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
      2019,
      "ses",
      cols = c(1, 2),
      col_names = "only_one",
      quiet = TRUE
    )
  )
})
