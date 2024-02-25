test_that("fill and cast rows to names of a data frame", {
  df_1 <- data.frame(
    a = 1:6,
    b = rep(c("x", NA), 3),
    c = letters[1:6]
  )
  expect_equal(row_to_names_fill(df_1, 1) |> names(), c("1", "x", "a"))
})
