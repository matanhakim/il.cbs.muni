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
})
