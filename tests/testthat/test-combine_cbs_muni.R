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
