test_that("removes unwanted characters", {
  expect_equal(clean_name("ab`c"), "abc")
  expect_equal(clean_name("ab~c"), "abc")
  expect_equal(clean_name("ab!c"), "abc")
  expect_equal(clean_name("ab@c"), "abc")
  expect_equal(clean_name("ab#c"), "abc")
  expect_equal(clean_name("ab$c"), "abc")
  expect_equal(clean_name("ab%c"), "abc")
  expect_equal(clean_name("ab^c"), "abc")
  expect_equal(clean_name("ab&c"), "abc")
  expect_equal(clean_name("ab_c"), "abc")
  expect_equal(clean_name("ab=c"), "abc")
  expect_equal(clean_name("ab+c"), "abc")
  expect_equal(clean_name("ab[c"), "abc")
  expect_equal(clean_name("ab]c"), "abc")
  expect_equal(clean_name("ab{c"), "abc")
  expect_equal(clean_name("ab}c"), "abc")
  expect_equal(clean_name("ab|c"), "abc")
  expect_equal(clean_name("ab/c"), "abc")
  expect_equal(clean_name("ab\\c"), "abc")
  expect_equal(clean_name("ab?c"), "abc")
  expect_equal(clean_name("ab.c"), "abc")
  expect_equal(clean_name("ab<c"), "abc")
  expect_equal(clean_name("ab>c"), "abc")
  expect_equal(clean_name("ab,c"), "abc")
  expect_equal(clean_name("ab?c"), "abc")
})

test_that("preserves allowed characters", {
  expect_equal(clean_name("ab'c"), "ab'c")
  expect_equal(clean_name("ab-c"), "ab-c")
  expect_equal(clean_name("ab(c)"), "ab(c)")
  expect_equal(clean_name('ab"c'), 'ab"c')
})

test_that("handles whitespace correctly", {
  expect_equal(clean_name("  abc  "), "abc")
  expect_equal(clean_name("ab  c"), "ab c")
  expect_equal(clean_name("ab\tc"), "ab c")
})

test_that("works with vectors", {
  expect_equal(clean_name(c("ab*c", "xy_z")), c("abc", "xyz"))
  expect_equal(clean_name(c("  a  ", "  b  ")), c("a", "b"))
})

test_that("handles NA correctly", {
  expect_equal(clean_name(NA_character_), NA_character_)
  expect_equal(clean_name(c("abc", NA, "xyz")), c("abc", NA, "xyz"))
})

test_that("throws error for invalid input type", {
  expect_error(clean_name(1), class = "clean_name_invalid_type")
  expect_error(clean_name(TRUE), class = "clean_name_invalid_type")
  expect_error(clean_name(list("a", "b")), class = "clean_name_invalid_type")
})
