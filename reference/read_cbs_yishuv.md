# Read a yishuvim data file to a tibble

This function is a wrapper around
[`readxl::read_excel()`](https://readxl.tidyverse.org/reference/read_excel.html),
reading a specific yishuvim data file or a part of it. A yishuv, or a
point of residence, is a geographically defined place where people live.
Some yishuvim are municipalities, in the case of of cities and local
councils, but most are not. most yishuvim are part of municipalities
that are regional councils. Also, some yishuvim are not themselves and
are not part of a municipality, like some Bedouin places in southern
Israel, some industry areas, Mikveh Israel, and more.

## Usage

``` r
read_cbs_yishuv(path, cols = NULL, col_names = NULL)
```

## Arguments

- path:

  A character vector of length 1, denoting the local file path to the
  yishuvim data file. A full list of available files by the CBS is at
  the [relevant CBS
  page](https://www.cbs.gov.il/he/publications/Pages/2019/%D7%99%D7%99%D7%A9%D7%95%D7%91%D7%99%D7%9D-%D7%91%D7%99%D7%A9%D7%A8%D7%90%D7%9C.aspx).

- cols:

  \<[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to keep. The default `NULL` keeps all columns.

- col_names:

  A character vector containing the new column names of the output
  tibble. If `NULL` then the tibble uses the original column names. Must
  be the same length as the number of columns picked in `cols`.

## Value

A tibble with yishuvim data for a specific year, where every row is a
yishuv and every column is a different variable for this yishuv in that
year. Be advised all columns are of type character, so you need to parse
the data types yourself at will. Column names are cleaned so only single
whitespaces are kept.

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
read_cbs_yishuv(system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni")) |>
  dplyr::glimpse()
#> Rows: 1,483
#> Columns: 26
#> $ `שם יישוב`              <chr> "אבו ג'ווייעד (שבט)", "אבו גוש", "אבו סנאן", "…
#> $ `סמל יישוב`             <chr> "967", "472", "473", "935", "958", "1042", "93…
#> $ תעתיק                   <chr> "ABU JUWEI'ID", "ABU GHOSH", "ABU SINAN", "ABU…
#> $ `סמל מחוז`              <chr> "6", "1", "2", "6", "6", "6", "6", "6", "6", "…
#> $ `שם מחוז`               <chr> "הדרום", "ירושלים", "הצפון", "הדרום", "הדרום",…
#> $ `סמל נפה`               <chr> "62", "11", "24", "62", "62", "62", "62", "62"…
#> $ `שם נפה`                <chr> "באר שבע", "ירושלים", "עכו", "באר שבע", "באר ש…
#> $ `אזור טבעי`             <chr> "623", "111", "245", "623", "623", "623", "623…
#> $ `סמל מעמד מונציפאלי`    <chr> NA, "99", "99", NA, NA, NA, NA, "68", NA, NA, …
#> $ `שם מעמד מונציפאלי`     <chr> "חסר מעמד מוניציפלי", "מועצה מקומית", "מועצה מ…
#> $ `שיוך מטרופוליני`       <chr> NA, "444", NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ `דת יישוב`              <chr> "3", "2", "2", "3", "3", "3", "3", "2", "3", "…
#> $ `סך הכל אוכלוסייה 2021` <chr> NA, "7881", "14455", NA, NA, NA, NA, "2081", N…
#> $ `יהודים ואחרים`         <chr> NA, "83", "31", NA, NA, NA, NA, "0", NA, NA, N…
#> $ `מזה: יהודים`           <chr> NA, "64", "14", NA, NA, NA, NA, "0", NA, NA, N…
#> $ ערבים                   <chr> NA, "7798", "14424", NA, NA, NA, NA, "2081", N…
#> $ `שנת ייסוד`             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ `צורת יישוב שוטפת`      <chr> "460", "280", "270", "460", "460", "460", "460…
#> $ `השתייכות ארגונית`      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ קואורדינטות             <chr> "2040057100", "2105263481", "2161876289", "186…
#> $ `גובה ממוצע`            <chr> NA, "686", "71", NA, NA, NA, NA, "449", NA, NA…
#> $ `ועדת תכנון`            <chr> "699", "152", "252", "699", "699", "699", "699…
#> $ `תחנת משטרה`            <chr> NA, "10002475", "15002143", NA, NA, NA, NA, "1…
#> $ שנה                     <chr> "2021", "2021", "2021", "2021", "2021", "2021"…
#> $ `שם יישוב באנגלית`      <chr> "Abu Juway'ad", "Abu Ghosh", "Abu Sinan", "Abu…
#> $ `אשכול רשויות מקומיות`  <chr> NA, NA, NA, NA, NA, NA, NA, "610", NA, NA, NA,…

read_cbs_yishuv(
  system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni"),
  cols = c(1, 2, 5, 13)
) |>
  mutate(across(2, pad_yishuv_id)) |>
  glimpse()
#> Rows: 1,483
#> Columns: 4
#> $ `שם יישוב`              <chr> "אבו ג'ווייעד (שבט)", "אבו גוש", "אבו סנאן", "…
#> $ `סמל יישוב`             <chr> "0967", "0472", "0473", "0935", "0958", "1042"…
#> $ `שם מחוז`               <chr> "הדרום", "ירושלים", "הצפון", "הדרום", "הדרום",…
#> $ `סך הכל אוכלוסייה 2021` <chr> NA, "7881", "14455", NA, NA, NA, NA, "2081", N…
```
