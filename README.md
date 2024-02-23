
<!-- README.md is generated from README.Rmd. Please edit that file -->

# il.cbs.muni

<!-- badges: start -->
<!-- badges: end -->

il.cbs.muni is an analyst oriented utility package to handle the
different quirks of the Israeli CBS municipal data, harmonize id’s and
bring together data points from different years.

## Installation

You can install the development version of il.cbs.muni from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("matanhakim/il.cbs.muni")
```

## Example

Let’s say we would like to work with the (2021 yishuvim
data)\[<https://www.cbs.gov.il/he/publications/doclib/2019/ishuvim/bycode2021.xlsx>\]
(‘yishuvim’ = points of residence) of the Israeli CBS. We will read the
first two columns:

``` r
library(il.cbs.muni)
library(readxl)
suppressMessages(library(dplyr))

# This is the specific path to the file in this package, but you can store it
# anywhere you want.
df_yishuvim <- read_excel("inst/extdata/bycode2021.xlsx", range = cell_cols("A:B")) |> 
  rename(yishuv_name = 1, yishuv_id = 2)
df_yishuvim
#> # A tibble: 1,483 × 2
#>    yishuv_name         yishuv_id
#>    <chr>                   <dbl>
#>  1 אבו ג'ווייעד (שבט)        967
#>  2 אבו גוש                   472
#>  3 אבו סנאן                  473
#>  4 אבו סריחאן (שבט)          935
#>  5 אבו עבדון (שבט)           958
#>  6 אבו עמאר (שבט)           1042
#>  7 אבו עמרה (שבט)            932
#>  8 אבו קורינאת (יישוב)      1342
#>  9 אבו קורינאת (שבט)         968
#> 10 אבו רובייעה (שבט)         966
#> # ℹ 1,473 more rows
```

As you can see, the id column has two problems:

1.  It’s a numeric vector. This is problematic as our convention for an
    id throughout the il.verse is to have id’s as characters.

2.  Each yishuv id has a different length, ranging between 1-4. This is
    problematic since there is no difference between `67` and `0067`,
    and creates potential clashes between some cities and regional
    councils when working with municipal data. For example, `31` is the
    **yishuv** id of Ofakim, but also the **municipal** id of Nahal
    Sorek regional council. Therefore, the convention is to use
    4-character-long id for **every** yishuv.

using the `pad_yishuv_id()` function, we can fix this problem:

``` r
df_yishuvim <- df_yishuvim |> 
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

Now every yishuv id is a string exactly 4 characters long.

We can verify this:

``` r
df_yishuvim$yishuv_id |> 
  stringr::str_length() |> 
  range()
#> [1] 4 4
```

This solves a common problem when working with yishuvim data.
