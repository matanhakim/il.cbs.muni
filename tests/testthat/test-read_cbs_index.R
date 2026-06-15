test_that("reading an ses index file works and auto-detects municipality level", {
  df <- read_cbs_index(
    path = system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
    year = 2019,
    index_type = "ses"
  )
  expect_equal(df |> names() |> dplyr::nth(3), "שם רשות מקומית")
  expect_equal(df |> ncol(), 12)
  expect_equal(df |> nrow(), 255)
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
  expect_equal(df |> nrow(), 259)
  expect_equal(attr(df, "unit_type"), "muni")
})

test_that("detect_index_unit_type classifies by row count", {
  expect_equal(detect_index_unit_type(data.frame(a = rep("x", 260))), "muni")
  expect_equal(detect_index_unit_type(data.frame(a = rep("x", 1013))), "yishuv")
  expect_equal(detect_index_unit_type(data.frame(a = rep("x", 1651))), "sa")
})

test_that("detect_index_unit_type detects statistical areas by keyword even when small", {
  d <- data.frame(a = c("CODE OF STATISTICAL AREA", rep("x", 90)))
  expect_equal(detect_index_unit_type(d), "sa")
})

test_that("unit_type is deprecated and ignored in favour of detection", {
  rlang::local_options(lifecycle_verbosity = "warning")
  expect_warning(
    df <- read_cbs_index(
      system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
      year = 2019,
      index_type = "ses",
      unit_type = "sa"
    ),
    regexp = "deprecated"
  )
  # detection still wins over the ignored argument
  expect_equal(attr(df, "unit_type"), "muni")
})

test_that("throws an informative error for an unsupported combination", {
  expect_error(
    read_cbs_index(
      path = system.file(
        "extdata",
        "24_22_375t1.xlsx",
        package = "il.cbs.muni"
      ),
      year = 2099,
      index_type = "ses"
    ),
    class = "read_cbs_index_unsupported"
  )
})
