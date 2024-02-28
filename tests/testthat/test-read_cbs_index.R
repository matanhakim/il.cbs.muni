test_that("reading an ses index file works", {
  df <- read_cbs_index(
    path = system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
    year = 2019,
    index_type = "ses",
    unit_type = "muni"
  )
  expect_equal(df |> names() |> dplyr::nth(3) , "שם רשות מקומית")
  expect_equal(df |> ncol() , 12)
  expect_equal(df |> nrow() , 255)
})
