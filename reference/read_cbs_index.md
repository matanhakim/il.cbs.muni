# Read a CBS index data file to a tibble

This function is a wrapper around
[`readxl::read_excel()`](https://readxl.tidyverse.org/reference/read_excel.html),
reading a specific CBS index data file for a specific year and a
specific data domain. Its added value is in its pre-defined parameters
for every year and its specific quirks in the Excel headers. For
advanced users,the full set of options is available with
`il.cbs.muni:::df_cbs_index_params`.

## Usage

``` r
read_cbs_index(
  path,
  year,
  index_type = c("ses", "peri"),
  unit_type = c("muni", "yishuv", "sa"),
  cols = NULL,
  col_names = NULL
)
```

## Arguments

- path:

  A character vector of length 1, denoting the local file path to the
  CBS index data file. A full list of available files by the CBS is at
  the relevant CBS page for either [Socio-Economic Status
  (SES)](https://www.cbs.gov.il/he/subjects/Pages/%D7%9E%D7%93%D7%93-%D7%97%D7%91%D7%A8%D7%AA%D7%99-%D7%9B%D7%9C%D7%9B%D7%9C%D7%99-%D7%A9%D7%9C-%D7%94%D7%A8%D7%A9%D7%95%D7%99%D7%95%D7%AA-%D7%94%D7%9E%D7%A7%D7%95%D7%9E%D7%99%D7%95%D7%AA.aspx)
  or for [peripheral
  level](https://www.cbs.gov.il/he/subjects/Pages/%D7%9E%D7%93%D7%93-%D7%A4%D7%A8%D7%99%D7%A4%D7%A8%D7%99%D7%90%D7%9C%D7%99%D7%95%D7%AA-%D7%A9%D7%9C-%D7%A8%D7%A9%D7%95%D7%99%D7%95%D7%AA-%D7%9E%D7%A7%D7%95%D7%9E%D7%99%D7%95%D7%AA.aspx).

- year:

  A numeric vector of length 1 denoting which year the data file pointed
  in `path` is for. Be aware that the year in question is the year **the
  data is for**, not the year **the data was published in**.

- index_type:

  A character vector of length 1, one of `c("ses", "peri")`.

- unit_type:

  A character vector of length 1, one of `c("muni", "yishuv", "sa")`.

  - `"muni"` - every row is a municipality.

  - `"yishuv"` - every row is a yishuv. In some years and indices this
    includes all yishuvim, in others only yishuvim within regional
    councils.

  - `"sa"` - every row is a statistical area within a city or local
    council.

- cols:

  \<[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to keep. The default `NULL` keeps all columns.

- col_names:

  A character vector containing the new column names of the output
  tibble. If `NULL` then the tibble uses the original column names. Must
  be the same length as the number of columns picked in `cols`.

## Value

A tibble with CBS index data for a specific year, where every row is a
`unit_type` and every column is a different variable for this
`unit_type` in that year. Be advised all columns are of type character,
so you need to parse the data types yourself at will. Column names are
merged from the relevant headers, and only single whitespaces are kept.
Rows with more than 90% empty cells (usually rows with non-data notes)
are removed.

## Examples

``` r
read_cbs_index(
  path = system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
  year = 2019,
  index_type = "ses",
  unit_type = "muni"
) |>
  dplyr::glimpse()
#> Rows: 255
#> Columns: 12
#> $ `מעמד מוניציפלי_MUNICIPAL STATUS`                                                <chr> …
#> $ `סמל יישוב_CODE OF LOCALITY`                                                     <chr> …
#> $ `שם רשות מקומית`                                                                 <chr> …
#> $ מחוז_DISTRICT                                                                    <chr> …
#> $ `אוכלוסיית המדד 2019[1]_INDEX POPULATION 2019[1]`                                <chr> …
#> $ `ערך מדד 2019[2]_INDEX VALUE 2019[2]`                                            <chr> …
#> $ `דירוג 2019[3]_RANK 2019[3]`                                                     <chr> …
#> $ `אשכול 2019[4]_CLUSTER 2019[4]`                                                  <chr> …
#> $ `דירוג 2017[3]_RANK 2017[3]`                                                     <chr> …
#> $ `אשכול 2017[4]_CLUSTER 2017[4]`                                                  <chr> …
#> $ `הפרש (אשכול 2019 פחות אשכול 2017)_DIFFERENCE (CLUSTER 2019 MINUS CLUSTER 2017)` <chr> …
#> $ `NAME OF LOCAL AUTHORITY`                                                        <chr> …
```
