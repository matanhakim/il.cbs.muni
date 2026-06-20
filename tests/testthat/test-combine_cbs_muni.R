test_that("combine a municipal data frame well", {
  df_1 <- combine_cbs_muni(
    system.file("extdata", "2009.xls", package = "il.cbs.muni"),
    year = 2009,
    cols_city = c(1:7, 11),
    cols_rc = c(1:7, 25),
    data_domain = "physical"
  )

  expect_equal(
    df_1[[1, 1]] |> unlist(),
    "אום אל-פחם"
  )

  expect_equal(
    df_1 |> names(),
    c("שם הרשות", "סמל הרשות 2009", "מחוז 2009",
      "מעמד מוניציפלי 2009", "מרחק מגבול מחוז תל אביב (ק\"מ) 2004",
      "שנת קבלת מעמד מוניציפלי", "מספר חברי מועצה 2008",
      "סה\"כ אוכלוסייה בסוף 2009 (אלפים)")
  )
})

test_that("throws error for invalid path", {
  expect_error(
    combine_cbs_muni(
      "nonexistent_file.xls",
      year = 2009,
      cols_city = 1:5,
      cols_rc = 1:5
    ),
    class = "read_cbs_muni_path_not_found"
  )
  
  expect_error(
    combine_cbs_muni(
      c("file1.xls", "file2.xls"),
      year = 2009,
      cols_city = 1:5,
      cols_rc = 1:5
    ),
    class = "combine_cbs_muni_invalid_path"
  )
})

test_that("throws error for invalid year", {
  expect_error(
    combine_cbs_muni(
      system.file("extdata", "2009.xls", package = "il.cbs.muni"),
      year = "2009",
      cols_city = 1:5,
      cols_rc = 1:5
    ),
    class = "combine_cbs_muni_invalid_year"
  )
  
  expect_error(
    combine_cbs_muni(
      system.file("extdata", "2009.xls", package = "il.cbs.muni"),
      year = c(2009, 2010),
      cols_city = 1:5,
      cols_rc = 1:5
    ),
    class = "combine_cbs_muni_invalid_year"
  )
})

test_that("throws error for invalid col_names", {
  expect_error(
    combine_cbs_muni(
      system.file("extdata", "2009.xls", package = "il.cbs.muni"),
      year = 2009,
      cols_city = 1:5,
      cols_rc = 1:5,
      col_names = 123
    ),
    class = "combine_cbs_muni_invalid_col_names"
  )
})

test_that("combines the budget domain and takes names from the rc sheet", {
  df <- combine_cbs_muni(
    system.file("extdata", "2009.xls", package = "il.cbs.muni"),
    year = 2009,
    cols_city = 1:5,
    cols_rc = 1:5,
    data_domain = "budget",
    col_names_from = "rc"
  )
  expect_equal(ncol(df), 5)
  expect_equal(nrow(df), 242)
  expect_equal(df |> names() |> dplyr::nth(1), "שם הרשות")
})

test_that("explicit col_names override both sheets", {
  df <- combine_cbs_muni(
    system.file("extdata", "2009.xls", package = "il.cbs.muni"),
    year = 2009,
    cols_city = 1:3,
    cols_rc = 1:3,
    col_names = c("name", "symbol", "district")
  )
  expect_equal(names(df), c("name", "symbol", "district"))
})

test_that("errors when cols_city and cols_rc select different numbers of columns", {
  expect_error(
    combine_cbs_muni(
      system.file("extdata", "2009.xls", package = "il.cbs.muni"),
      year = 2009,
      cols_city = c(1, 2, 3),
      cols_rc = c(1, 2)
    ),
    class = "combine_cbs_muni_cols_length_mismatch"
  )
})

test_that("errors when the column selections are missing", {
  expect_error(
    combine_cbs_muni(
      system.file("extdata", "2009.xls", package = "il.cbs.muni"),
      year = 2009
    ),
    class = "combine_cbs_muni_missing_cols"
  )
})

test_that("errors when col_names length does not match the selected columns", {
  expect_error(
    combine_cbs_muni(
      system.file("extdata", "2009.xls", package = "il.cbs.muni"),
      year = 2009,
      cols_city = 1:3,
      cols_rc = 1:3,
      col_names = c("a", "b")
    ),
    class = "combine_cbs_muni_col_names_length"
  )
})
