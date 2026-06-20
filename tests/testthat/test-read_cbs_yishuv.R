test_that("Reading a yishuvim file works", {
  df <- read_cbs_yishuv(system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni"))
  expect_equal(df |> names() |> dplyr::nth(2), "סמל יישוב")
  expect_equal(df |> names() |> dplyr::nth(26), "אשכול רשויות מקומיות")
  expect_equal(df |> ncol(), 26)
  expect_equal(df |> nrow(), 1483)
})

test_that("applies valid col_names", {
  df <- read_cbs_yishuv(
    system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni"),
    cols = c(1, 2),
    col_names = c("name", "id")
  )
  expect_equal(names(df), c("name", "id"))
})

test_that("invalid path errors", {
  expect_snapshot(error = TRUE, read_cbs_yishuv("nonexistent_file.xlsx"))
  expect_snapshot(error = TRUE, read_cbs_yishuv(c("file1.xlsx", "file2.xlsx")))
})

test_that("invalid col_names type errors", {
  expect_snapshot(
    error = TRUE,
    read_cbs_yishuv(
      system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni"),
      col_names = 123
    )
  )
})

test_that("col_names length must match the selected columns", {
  expect_snapshot(
    error = TRUE,
    read_cbs_yishuv(
      system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni"),
      cols = c(1, 2),
      col_names = "only_one"
    )
  )
})

test_that("cols honors full tidy-select (predicate and negative)", {
  path <- system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni")
  full <- read_cbs_yishuv(path)
  all_chr <- read_cbs_yishuv(path, cols = dplyr::where(is.character))
  expect_identical(ncol(all_chr), ncol(full))
  neg <- read_cbs_yishuv(path, cols = -1)
  expect_identical(ncol(neg), ncol(full) - 1L)
})
