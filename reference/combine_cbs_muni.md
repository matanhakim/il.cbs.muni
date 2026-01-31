# Combine municipalities data frames from different sheets

This function is a wrapper around
[`read_cbs_muni()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_muni.md)
to help in combining data for cities, local councils and regional
councils. From 2015 and earlier, the Israeli CBS publishes municipal
data on different sheets and formats for cities and local councils, and
for regional councils. This function enables the user to combine the two
data frames for selected columns. It is up to the user to take care of
the specific match between specific columns.

## Usage

``` r
combine_cbs_muni(
  path,
  year,
  cols_city,
  cols_rc,
  data_domain = c("physical", "budget"),
  col_names = NULL,
  col_names_from = c("city_lc", "rc")
)
```

## Arguments

- path:

  A character vector of length 1, denoting the local file path to the
  municipal data file. A full list of available files by the CBS is at
  the [relevant CBS
  page](https://www.cbs.gov.il/he/publications/Pages/2019/%D7%94%D7%A8%D7%A9%D7%95%D7%99%D7%95%D7%AA-%D7%94%D7%9E%D7%A7%D7%95%D7%9E%D7%99%D7%95%D7%AA-%D7%91%D7%99%D7%A9%D7%A8%D7%90%D7%9C-%D7%A7%D7%95%D7%91%D7%A6%D7%99-%D7%A0%D7%AA%D7%95%D7%A0%D7%99%D7%9D-%D7%9C%D7%A2%D7%99%D7%91%D7%95%D7%93-1999-2017.aspx).

- year:

  A numeric vector of length 1 denoting which year the data file pointed
  in `path` is for. Currently supporting 2003-2015, since before 2003
  the data structure is very different, and after 2015 the file is
  already combined.

- cols_city:

  \<[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to keep from the cities and local councils sheet.

- cols_rc:

  \<[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to keep from the regional councils sheet. Should be in the
  same order of desired columns as in `cols_city`, since the columns are
  matched by order.

- data_domain:

  A character vector of length 1, one of `c("physical", "budget")`.
  Every Excel municipal data file has a few different data domains, most
  notably physical and population data, and budget data.

- col_names:

  A character vector containing the new column names of the output
  tibble. If `NULL` then the tibble uses the original column names. Must
  be the same length as the number of columns picked in `cols`. If not
  `NULL`, overrides the choice in `col_names_from`.

- col_names_from:

  A character vector of length 1, one of `c("city_lc", "rc")`. Denotes
  which column names should be kept - those from the cities and local
  councils sheet, or those from the regional councils sheet.

## Value

A tibble with municipal data for a specific year, with the columns from
`cols_city` and `cols_rc` bound by rows and matched by order of columns.
Every row is a municipality and every column is a different variable for
this municipality in that year. Be advised all columns are of type
character, so you need to parse the data types yourself at will. Column
names are merged from the relevant headers, and only single whitespaces
are kept. Rows with more than 90% empty cells (usually rows with
non-data notes) are removed.

## Examples

``` r
df_1 <- combine_cbs_muni(
  system.file("extdata", "2009.xls", package = "il.cbs.muni"),
  year = 2009,
  cols_city = c(1:7, 11),
  cols_rc = c(1:7, 25)
)

df_1 |>
  dplyr::glimpse()
#> Rows: 253
#> Columns: 8
#> $ `שם הרשות`                           <chr> "אום אל-פחם", "אופקים", "אור יהוד…
#> $ `סמל הרשות 2009`                     <chr> "2710", "0031", "2400", "1020", "…
#> $ `מחוז 2009`                          <chr> "חיפה", "הדרום", "תל אביב", "חיפה…
#> $ `מעמד מוניציפלי 2009`                <chr> "עירייה", "עירייה", "עירייה", "עי…
#> $ `מרחק מגבול מחוז תל אביב (ק"מ) 2004` <chr> "58.600000000000001", "85.7999999…
#> $ `שנת קבלת מעמד מוניציפלי`            <chr> "1984", "1995", "1988", "2001", "…
#> $ `מספר חברי מועצה 2008`               <chr> "16", "13", "17", "15", "17", "13…
#> $ `סה"כ אוכלוסייה בסוף 2009 (אלפים)`   <chr> "46.100000000000001", "24", "34.3…

df_2 <- combine_cbs_muni(
  system.file("extdata", "2009.xls", package = "il.cbs.muni"),
  year = 2009,
  cols_city = c(1:12),
  cols_rc = c(1:12),
  data_domain = "budget",
  col_names_from = "rc"
)

df_2 |>
  dplyr::glimpse()
#> Rows: 242
#> Columns: 12
#> $ `שם הרשות`                                                               <chr> …
#> $ `סמל הרשות 2009`                                                         <chr> …
#> $ `סך כולל הכנסות של הרשות (אלפי ש"ח) 2009`                                <chr> …
#> $ `סך כולל הכנסות של הרשות - אחוז שינוי ראלי 2009 לעומת 2008`              <chr> …
#> $ `סה"כ הכנסות של הרשות מן התקציב הרגיל (אלפי ש"ח) 2009`                   <chr> …
#> $ `סה"כ הכנסות של הרשות מן התקציב הרגיל - אחוז שינוי ראלי 2009 לעומת 2008` <chr> …
#> $ `הכנסות של הרשות מחינוך (אלפי ש"ח) 2009`                                 <chr> …
#> $ `הכנסות של הרשות מחינוך - אחוז שינוי ראלי 2009 לעומת 2008`               <chr> …
#> $ `הכנסות של הרשות מרווחה (אלפי ש"ח) 2009`                                 <chr> …
#> $ `הכנסות של הרשות מרווחה - אחוז שינוי ראלי 2009 לעומת 2008`               <chr> …
#> $ `הכנסות של הרשות ממפעל המים (אלפי ש"ח) 2009`                             <chr> …
#> $ `הכנסות של הרשות ממפעל המים - אחוז שינוי ראלי 2009 לעומת 2008`           <chr> …
```
