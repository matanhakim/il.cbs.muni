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
