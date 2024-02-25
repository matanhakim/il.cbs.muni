test_that("fill and cast rows to names of a data frame", {
  df_1 <- data.frame(
    a = 1:6,
    b = rep(c("x", NA), 3),
    c = letters[1:6]
  )
  expect_equal(row_to_names_fill(df_1, 1) |> names(), c("1", "x", "a"))
  expect_equal(row_to_names_fill(df_1, 1:2) |> names(), c("1_2", "x_2", "a_b"))
  expect_equal(row_to_names_fill(df_1, 2:4) |> names(), c("2_3_4", "2_x_4", "b_c_d"))
})

test_that("fill and cast rows to names of a data frame and keeps data well", {
  df_1 <- data.frame(
    a = 1:6,
    b = rep(c("x", NA), 3),
    c = letters[1:6]
  )
  expect_equal(row_to_names_fill(df_1, 1) |> unname(), dplyr::slice(df_1, 2:6) |> unname())
  expect_equal(row_to_names_fill(df_1, 1:2, ) |> unname(), dplyr::slice(df_1, 3:6) |> unname())
  expect_equal(row_to_names_fill(df_1, 2:5, ) |> unname(), dplyr::slice(df_1, 6) |> unname())
})

test_that("fill and cast rows to names of a data frame in a real data set", {
  df_1 <- readxl::read_excel(system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"), sheet = 2, col_types = "text", col_names = FALSE) |>
    suppressMessages()
  expect_equal(
    row_to_names_fill(df_1, 4:5, fill_missing = c(TRUE, FALSE)) |> names() |> dplyr::nth(20),
    "סה\"כ גברים בסוף השנה"
  )
  expect_equal(
    row_to_names_fill(df_1, 4:5, fill_missing = c(TRUE, FALSE)) |> names() |> dplyr::nth(22),
    "אחוז באוכלוסייה בסוף השנה_בני 4-0"
  )
})
