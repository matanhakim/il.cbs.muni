# il.cbs.muni

il.cbs.muni is an analyst-oriented utility package for working with
Israeli Central Bureau of Statistics (CBS) municipal data. It provides
tools to read the CBS data files, handle the quirks of their formats,
harmonize IDs across different years, and combine data points from
multiple sources.

## Installation

You can install the released version of il.cbs.muni from
[CRAN](https://CRAN.R-project.org) with:

``` r

install.packages("il.cbs.muni")
```

Or install the development version from
[GitHub](https://github.com/matanhakim/il.cbs.muni) with:

``` r

# install.packages("devtools")
devtools::install_github("matanhakim/il.cbs.muni")
```

## Reading municipal data

[`read_cbs_muni()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_muni.md)
reads a CBS municipal data file for a given year and data domain. It
knows the per-year layout quirks - which sheet holds each domain, which
rows form the (often multi-row) headers, and the aggregate summary rows
that CBS added from 2022 onwards - so every returned row is a single
municipality. Years 2003 through 2024 are supported.

``` r

library(il.cbs.muni)
suppressMessages(library(dplyr))

df_muni <- read_cbs_muni(
  system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
  year = 2021,
  data_domain = "physical"
)

df_muni |>
  select(1:4) |>
  glimpse()
#> Rows: 255
#> Columns: 4
#> $ `שם הרשות`            <chr> "אום אל-פחם", "אופקים", "אור יהודה", "אור עקיבא"…
#> $ `כללי_סמל הרשות`      <chr> "2710", "0031", "2400", "1020", "2600", "1309", …
#> $ כללי_מחוז             <chr> "חיפה", "הדרום", "תל אביב", "חיפה", "הדרום", "המ…
#> $ `כללי_מעמד מוניציפלי` <chr> "עירייה", "עירייה", "עירייה", "עירייה", "עירייה"…
```

## Reading index data

[`read_cbs_index()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_index.md)
reads the socio-economic or peripherality index files. The CBS places
the same geographic level in different table numbers across editions, so
by default the function detects the level (municipality, locality or
statistical area) from the file content and applies the matching header
layout. When you already know the level, pass `unit_type` to override
detection.

``` r

df_index <- read_cbs_index(
  system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
  year = 2019,
  index_type = "ses",
  quiet = TRUE
)

attr(df_index, "unit_type")
#> [1] "muni"

df_index |>
  select(1:4) |>
  glimpse()
#> Rows: 255
#> Columns: 4
#> $ `מעמד מוניציפלי_MUNICIPAL STATUS` <chr> "68", "99", "99", "99", "69", "0", "…
#> $ `סמל יישוב_CODE OF LOCALITY`      <chr> NA, "1192", "1054", "1059", NA, "379…
#> $ `שם רשות מקומית`                  <chr> "נווה מדבר", "ערערה-בנגב", "תל שבע",…
#> $ מחוז_DISTRICT                     <chr> "6", "6", "6", "6", "6", "7", "6", "…
```

## Harmonizing identifiers

CBS files use a numeric locality ID with a variable length, while the
il.verse convention is a 4-character string.
[`pad_yishuv_id()`](https://matanhakim.github.io/il.cbs.muni/reference/pad_yishuv_id.md)
fixes that:

``` r

df_yishuvim <- read_cbs_yishuv(
  system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni"),
  cols = c(1, 2)
) |>
  rename(yishuv_name = 1, yishuv_id = 2) |>
  mutate(yishuv_id = pad_yishuv_id(yishuv_id))

df_yishuvim
#> # A tibble: 1,483 × 2
#>    yishuv_name         yishuv_id
#>    <chr>               <chr>    
#>  1 אבו ג'ווייעד (שבט)  0967     
#>  2 אבו גוש             0472     
#>  3 אבו סנאן            0473     
#>  4 אבו סריחאן (שבט)    0935     
#>  5 אבו עבדון (שבט)     0958     
#>  6 אבו עמאר (שבט)      1042     
#>  7 אבו עמרה (שבט)      0932     
#>  8 אבו קורינאת (יישוב) 1342     
#>  9 אבו קורינאת (שבט)   0968     
#> 10 אבו רובייעה (שבט)   0966     
#> # ℹ 1,473 more rows
```

This matters because there is no difference between `67` and `0067` once
stored as a number, which creates clashes between some cities and
regional councils when working with municipal data. For example, `31` is
the **yishuv** ID of Ofakim, but also the **municipal** ID of Nahal
Sorek regional council, so the convention is a 4-character ID for
**every** yishuv.

For regional councils,
[`modify_muni_id()`](https://matanhakim.github.io/il.cbs.muni/reference/modify_muni_id.md)
builds the municipal ID from the municipal status and locality ID, and
its `rc_code` argument switches between the historical 2-digit code
(e.g. `38`) and the 4-digit `5500 + code` form (e.g. `5538`) that CBS
introduced in the 2024 municipal file.
