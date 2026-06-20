test_that("cities and local councils return the yishuv id", {
  expect_equal(modify_muni_id("0", "30"), "30")
  expect_equal(modify_muni_id(0, 30), "30")
  expect_equal(modify_muni_id("99", "30"), "30")
  expect_equal(modify_muni_id(99, 30, rc_code = "55xx"), "30")
})

test_that("regional councils use the 2-digit code by default", {
  expect_equal(modify_muni_id("38", "1234"), "38")
  expect_equal(modify_muni_id("10", "30"), "10")
  expect_equal(modify_muni_id("1", "1234"), "01")
  expect_equal(modify_muni_id(5, "1234"), "05")
})

test_that("regional councils use the 4-digit 55xx code when asked", {
  expect_equal(modify_muni_id("38", "1234", rc_code = "55xx"), "5538")
  expect_equal(modify_muni_id(69, "1234", rc_code = "55xx"), "5569")
  expect_equal(modify_muni_id("1", "1234", rc_code = "55xx"), "5501")
})

test_that("works with vectors", {
  expect_equal(
    modify_muni_id(c("0", "99", "38"), c("100", "200", "300")),
    c("100", "200", "38")
  )
  expect_equal(
    modify_muni_id(c(0, 99, 38), c(100, 200, 300), rc_code = "55xx"),
    c("100", "200", "5538")
  )
})

test_that("recognises zero-padded city and local-council codes", {
  expect_equal(modify_muni_id("00", "1234"), "1234")
  expect_equal(modify_muni_id("099", "1234"), "1234")
  expect_equal(modify_muni_id("00", "1234", rc_code = "55xx"), "1234")
})

test_that("handles NA correctly", {
  expect_equal(modify_muni_id(NA, "1234"), NA_character_)
  expect_equal(modify_muni_id("0", NA), NA_character_)
  expect_equal(
    modify_muni_id(c(0, NA, 38), c("100", "200", "300")),
    c("100", NA, "38")
  )
})

test_that("recycling works", {
  expect_equal(modify_muni_id(0, c("100", "200")), c("100", "200"))
  expect_equal(modify_muni_id(c("0", "99"), "100"), c("100", "100"))
})

test_that("throws error for invalid rc_code", {
  # `rc_code` is validated by rlang::arg_match(); assert the class rather than
  # snapshotting rlang-owned message text.
  expect_error(
    modify_muni_id("38", "1234", rc_code = "xxx"),
    class = "rlang_error"
  )
})

test_that("throws error for invalid input types", {
  expect_snapshot(error = TRUE, modify_muni_id(TRUE, "1234"))
  expect_snapshot(error = TRUE, modify_muni_id("0", TRUE))
  expect_snapshot(error = TRUE, modify_muni_id(list(1), "1234"))
})

test_that("throws error for length mismatch", {
  expect_snapshot(error = TRUE, modify_muni_id(c(0, 99), c("100", "200", "300")))
  expect_snapshot(error = TRUE, modify_muni_id(c(0, 99, 10), c("100", "200")))
})

test_that("a zero-length input returns a zero-length result", {
  expect_identical(modify_muni_id(character(0), "1000"), character(0))
  expect_identical(modify_muni_id("0", character(0)), character(0))
  expect_identical(modify_muni_id(numeric(0), "1000"), character(0))
  expect_identical(modify_muni_id(character(0), character(0)), character(0))
})
