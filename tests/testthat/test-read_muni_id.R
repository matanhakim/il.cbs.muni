test_that("read_muni_id() works", {
  expect_equal(read_muni_id() |> nrow(), 257)
  expect_equal(read_muni_id(include_names = TRUE) |> ncol(), 6)
  expect_equal(read_muni_id(id_types = c("tax", "edu")) |> ncol(), 2)
  expect_equal(
    read_muni_id(id_types = c("tax", "edu"), include_names = TRUE) |> ncol(),
    4
  )
})

test_that("read_muni_id() returns regional councils as 2-digit codes", {
  d <- read_muni_id()
  expect_equal(sum(nchar(d$muni_id) == 2), 54)
})
