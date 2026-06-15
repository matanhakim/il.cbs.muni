test_that("reading an ses index file works", {
  df <- read_cbs_index(
    path = system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
    year = 2019,
    index_type = "ses",
    unit_type = "muni"
  )
  expect_equal(df |> names() |> dplyr::nth(3), "שם רשות מקומית")
  expect_equal(df |> ncol(), 12)
  expect_equal(df |> nrow(), 255)
})

test_that("reading a periphery index file works", {
  df <- read_cbs_index(
    path = system.file("extdata", "24_22_420t1.xlsx", package = "il.cbs.muni"),
    year = 2020,
    index_type = "peri",
    unit_type = "muni"
  )
  expect_equal(
    df |> names() |> dplyr::nth(1),
    "מעמד מוניציפלי_MUNICIPAL STATUS"
  )
  expect_equal(df |> nrow(), 259)
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
      index_type = "ses",
      unit_type = "muni"
    ),
    class = "read_cbs_index_unsupported"
  )
})
