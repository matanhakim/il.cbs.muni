test_that("Reading a yishuvim file works", {
  df <- read_cbs_yishuv(system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni"))
  expect_equal(df |> names() |> dplyr::nth(2), "סמל יישוב")
  expect_equal(df |> names() |> dplyr::nth(26), "אשכול רשויות מקומיות")
  expect_equal(df |> ncol(), 26)
  expect_equal(df |> nrow(), 1483)
})

test_that("throws error for invalid path", {
  expect_error(
    read_cbs_yishuv("nonexistent_file.xlsx"),
    class = "read_cbs_yishuv_path_not_found"
  )
  expect_error(
    read_cbs_yishuv(c("file1.xlsx", "file2.xlsx")),
    class = "read_cbs_yishuv_invalid_path"
  )
})

test_that("col_names length must match the selected columns", {
  expect_error(
    read_cbs_yishuv(
      system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni"),
      cols = c(1, 2),
      col_names = "only_one"
    ),
    class = "read_cbs_yishuv_col_names_length"
  )
})
