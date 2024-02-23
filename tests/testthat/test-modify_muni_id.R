test_that("municipal id is modified", {
  expect_equal(modify_muni_id("0", "30"), "30")
  expect_equal(modify_muni_id(0, 30), "30")
  expect_equal(modify_muni_id("0", 30), "30")
  expect_equal(modify_muni_id(0, "30"), "30")
  expect_equal(modify_muni_id("99", "30"), "30")
  expect_equal(modify_muni_id(99, 30), "30")
  expect_equal(modify_muni_id("99", 30), "30")
  expect_equal(modify_muni_id(99, "30"), "30")
})

test_that("municipal id is kept", {
  expect_equal(modify_muni_id("10", "30"), "10")
  expect_equal(modify_muni_id(10, 30), "10")
  expect_equal(modify_muni_id("10", 30), "10")
  expect_equal(modify_muni_id(10, "30"), "10")
})
