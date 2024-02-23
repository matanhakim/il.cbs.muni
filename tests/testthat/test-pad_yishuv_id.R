test_that("pad_yishu_id() pads a character vector with a single element", {
  expect_equal(pad_yishuv_id("1"), "0001")
  expect_equal(pad_yishuv_id("12"), "0012")
  expect_equal(pad_yishuv_id("123"), "0123")
  expect_equal(pad_yishuv_id("1234"), "1234")
})
