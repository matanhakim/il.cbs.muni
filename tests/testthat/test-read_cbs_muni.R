test_that("read a municipal data frame well", {
  df_1 <- read_cbs_muni(
    system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
    year = 2021,
    data_domain = "physical"
  )

  df_2 <- read_cbs_muni(
    system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
    year = 2021,
    data_domain = "budget"
  )

  df_3 <- read_cbs_muni(
    system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
    year = 2021,
    data_domain = "physical",
    cols = c(1:4, dplyr::last_col())
  )

  expect_equal(
    df_1[[1, 1]] |> unlist(),
    "אום אל-פחם"
  )
  expect_equal(
    df_1 |> names() |> dplyr::nth(20),
    "דמוגרפיה_סה\"כ גברים בסוף השנה"
  )
  expect_equal(
    df_1 |> names() |> dplyr::nth(22),
    "דמוגרפיה_אחוז באוכלוסייה בסוף השנה_בני 4-0"
  )

  expect_equal(
    df_2 |> names() |> dplyr::nth(20),
    "ארנונה למגורים: סה\"כ גביות"
  )
  expect_equal(
    df_2 |> names() |> dplyr::nth(22),
    "ארנונה למגורים: יחס גבייה ב-% לכלל החיובים"
  )

  expect_equal(
    df_3 |> names(),
    c(
      "שם הרשות",
      "כללי_סמל הרשות",
      "כללי_מחוז",
      "כללי_מעמד מוניציפלי",
      "בחירות מוניציפליות וארציות_בחירות לכנסת ה-25 01/11/22_אחוזי הצבעה"
    )
  )
})

test_that("returns one row per municipality for a pre-2022 file", {
  df <- read_cbs_muni(
    system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
    year = 2021,
    data_domain = "physical"
  )
  expect_equal(nrow(df), 255)
})

test_that("drop_summary_rows removes rows with an empty authority symbol", {
  df <- data.frame(
    name = c("כלל ארצי", "עיריות", "אום אל-פחם", "אופקים"),
    symbol = c(NA, "", "2710", "0031"),
    district = c(NA, NA, "חיפה", "הדרום"),
    stringsAsFactors = FALSE
  )
  out <- drop_summary_rows(df, symbol_col = 2)
  expect_equal(nrow(out), 2)
  expect_equal(out[[2]], c("2710", "0031"))
})

test_that("drop_summary_rows is a no-op without a symbol column", {
  df <- data.frame(only = c("a", "b"))
  expect_equal(drop_summary_rows(df, symbol_col = 2), df)
})

test_that("throws error for invalid keep_summary_rows", {
  expect_error(
    read_cbs_muni(
      system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
      year = 2021,
      data_domain = "physical",
      keep_summary_rows = "yes"
    ),
    class = "read_cbs_muni_invalid_keep_summary_rows"
  )
})

test_that("throws an informative error for an unsupported year", {
  expect_error(
    read_cbs_muni(
      system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
      year = 1990,
      data_domain = "physical"
    ),
    class = "read_cbs_muni_unsupported"
  )
})

test_that("throws error for invalid path", {
  expect_error(
    read_cbs_muni(
      "nonexistent_file.xlsx",
      year = 2021,
      data_domain = "physical"
    ),
    class = "read_cbs_muni_path_not_found"
  )

  expect_error(
    read_cbs_muni(
      c("file1.xlsx", "file2.xlsx"),
      year = 2021,
      data_domain = "physical"
    ),
    class = "read_cbs_muni_invalid_path"
  )
})

test_that("throws error for invalid year", {
  expect_error(
    read_cbs_muni(
      system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
      year = "2021",
      data_domain = "physical"
    ),
    class = "read_cbs_muni_invalid_year"
  )

  expect_error(
    read_cbs_muni(
      system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
      year = c(2021, 2022),
      data_domain = "physical"
    ),
    class = "read_cbs_muni_invalid_year"
  )

  expect_error(
    read_cbs_muni(
      system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
      year = NA_real_,
      data_domain = "physical"
    ),
    class = "read_cbs_muni_invalid_year"
  )
})

test_that("reads the labor force and social survey domains", {
  path <- system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni")
  lfs <- read_cbs_muni(path, year = 2021, data_domain = "labor_force_survey")
  expect_equal(nrow(lfs), 39)
  expect_equal(ncol(lfs), 27)
  ss <- read_cbs_muni(path, year = 2021, data_domain = "social_survey")
  expect_equal(nrow(ss), 292)
  expect_equal(ncol(ss), 7)
})

test_that("the summary domain is unsupported from 2022 onwards", {
  expect_error(
    read_cbs_muni(
      system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
      year = 2024,
      data_domain = "summary"
    ),
    class = "read_cbs_muni_unsupported"
  )
})

test_that("col_names length must match the selected columns", {
  expect_error(
    read_cbs_muni(
      system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
      year = 2021,
      data_domain = "physical",
      cols = c(1, 2),
      col_names = "only_one"
    ),
    class = "read_cbs_muni_col_names_length"
  )
})

test_that("drop_summary_rows treats whitespace-only symbols as summary rows", {
  df <- data.frame(
    name = c("total", "אום אל-פחם", "אופקים"),
    symbol = c("  ", "2710", "0031"),
    stringsAsFactors = FALSE
  )
  out <- drop_summary_rows(df, symbol_col = 2)
  expect_equal(nrow(out), 2)
  expect_equal(out[[2]], c("2710", "0031"))
})

test_that("throws error for invalid col_names", {
  expect_error(
    read_cbs_muni(
      system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
      year = 2021,
      data_domain = "physical",
      col_names = 123
    ),
    class = "read_cbs_muni_invalid_col_names"
  )
})
