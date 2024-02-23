test_that("pad_yishu_id() pads a character vector with a single element", {
  expect_equal(pad_yishuv_id("1"), "0001")
  expect_equal(pad_yishuv_id("12"), "0012")
  expect_equal(pad_yishuv_id("123"), "0123")
  expect_equal(pad_yishuv_id("1234"), "1234")
})

test_that("pad_yishuv_id() throws an error when input is too long", {
  expect_error(pad_yishuv_id("12345"))
})

test_that("pad_yishuv_id() throws an error when input is  not character or numeric", {
  expect_error(pad_yishuv_id(TRUE))
})
