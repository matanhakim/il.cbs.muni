test_that("pad_yishu_id() pads a character vector with a single element", {
  expect_equal(pad_yishuv_id("1"), "0001")
  expect_equal(pad_yishuv_id("12"), "0012")
  expect_equal(pad_yishuv_id("123"), "0123")
  expect_equal(pad_yishuv_id("1234"), "1234")
})

test_that("pad_yishuv_id() works with numeric input", {
  expect_equal(pad_yishuv_id(1), "0001")
  expect_equal(pad_yishuv_id(123), "0123")
  expect_equal(pad_yishuv_id(1234), "1234")
})

test_that("pad_yishuv_id() works with vectors", {
  expect_equal(pad_yishuv_id(c(1, 23, 456, 7890)), c("0001", "0023", "0456", "7890"))
  expect_equal(pad_yishuv_id(c("1", "23", "456")), c("0001", "0023", "0456"))
})

test_that("pad_yishuv_id() handles NA correctly", {
  expect_equal(pad_yishuv_id(NA), NA_character_)
  expect_equal(pad_yishuv_id(c(1, NA, 123)), c("0001", NA_character_, "0123"))
  expect_equal(pad_yishuv_id(c(NA, NA)), c(NA_character_, NA_character_))
})

test_that("pad_yishuv_id() throws an error when input is too long", {
  expect_error(pad_yishuv_id("12345"), class = "pad_yishuv_id_too_long")
  expect_error(pad_yishuv_id(12345), class = "pad_yishuv_id_too_long")
  expect_error(pad_yishuv_id(c(1, 2, 12345)), class = "pad_yishuv_id_too_long")
})

test_that("pad_yishuv_id() throws an error when input is not character or numeric", {
  expect_error(pad_yishuv_id(TRUE), class = "pad_yishuv_id_invalid_type")
  expect_error(pad_yishuv_id(list(1, 2, 3)), class = "pad_yishuv_id_invalid_type")
  expect_error(pad_yishuv_id(factor(c("1", "2"))), class = "pad_yishuv_id_invalid_type")
})
