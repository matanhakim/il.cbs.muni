test_that("Reading a yishuvim file works", {
  df <- read_cbs_yishuv(system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni"))
  expect_equal(df |> names() |> dplyr::nth(2), "סמל יישוב")
  expect_equal(df |> names() |> dplyr::nth(26), "אשכול רשויות מקומיות")
  expect_equal(df |> ncol(), 26)
  expect_equal(df |> nrow(), 1483)
})
