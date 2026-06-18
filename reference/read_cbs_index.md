# Read a CBS index data file to a tibble

**\[experimental\]**

This function is a wrapper around
[`readxl::read_excel()`](https://readxl.tidyverse.org/reference/read_excel.html),
reading a CBS socio-economic or peripherality index data file for a
specific year. Its added value is in figuring out the file's structure
for you: by default it detects the geographic level of the file
(municipality, locality or statistical area) from its contents and
applies the matching header layout. The full set of header parameters is
available with `il.cbs.muni:::df_cbs_index_params`.

This function is marked experimental because the CBS index publications
are not stable across editions: the same geographic level lives in
different table numbers in different years and the file format
alternates between `xls` and `xlsx`. Detecting the level from the file
content rather than relying on the table number makes the reader robust
to that shuffle - you give it one file and it works out what the file
is.

## Usage

``` r
read_cbs_index(
  path,
  year,
  index_type = c("ses", "peri"),
  unit_type = NULL,
  cols = NULL,
  col_names = NULL,
  quiet = FALSE
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
  Read a single file per call; to read several files, iterate (e.g. with
  [`purrr::map()`](https://purrr.tidyverse.org/reference/map.html)).

- year:

  A numeric vector of length 1 denoting which year the data file pointed
  in `path` is for. Be aware that the year in question is the year **the
  data is for**, not the year **the data was published in**.

- index_type:

  A character vector of length 1, one of `c("ses", "peri")`.

- unit_type:

  `NULL` (the default) or a character vector of length 1, one of
  `c("muni", "yishuv", "sa")`, denoting the geographic level:
  municipality, locality or statistical area. When `NULL`, the level is
  detected from the file content. When supplied, the given level is used
  as-is and detection is skipped, which lets you override a misdetection
  for a file whose level you already know.

- cols:

  \<[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to keep. The default `NULL` keeps all columns.

- col_names:

  A character vector containing the new column names of the output
  tibble. If `NULL` then the tibble uses the original column names. Must
  be the same length as the number of columns picked in `cols`. The
  names are assigned by position, so they follow the data's column
  order.

- quiet:

  A logical vector of length 1. When `FALSE` (the default) a message
  reports the geographic level used. Set to `TRUE` to silence it, for
  example when iterating over many files.

## Value

A tibble with CBS index data for a specific year, where every row is a
single geographic unit (municipality, locality or statistical area) and
every column is a different variable for that unit. The geographic level
used is also stored in the `"unit_type"` attribute of the result. Be
advised all columns are of type character, so you need to parse the data
types yourself at will. Column names are merged from the relevant
headers, and only single whitespaces are kept. Rows that are 80% or more
empty cells (usually rows with non-data notes) are removed.

## Details

Detection uses the raw row count and a header keyword, which separates
the three levels cleanly for the files published so far. It can still be
wrong when a file does not match the expected geometry - for example a
table that is not a standard index but happens to be municipality-sized,
or two different tables in the same edition that share a row-count band.
When you know the level, pass it explicitly through `unit_type` to
bypass detection.

## Examples

``` r
read_cbs_index(
  path = system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
  year = 2019,
  index_type = "ses"
) |>
  dplyr::glimpse()
#> Detected municipality-level ses index file (266 raw rows).
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
