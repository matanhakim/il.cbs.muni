# Read municipalities id's and names

Israeli municipalities have different id's and sometimes even different
names across different government organizations. This function allows
you to read different municipality id's and names , so interchanging
between the different specifications would be easier.

## Usage

``` r
read_muni_id(id_types = c("muni", "edu", "tax"), include_names = FALSE)
```

## Arguments

- id_types:

  A character vector of length between 1 and 3, containing at least one
  (or two, or all of) of the possible values. id's (and possibly names)
  of municipalities are kept for the selected sources:

  - `"muni"` is for CBS id's and (cleaned) names.

  - `"edu"` is for Ministry of Education municipal symbol ("Semel
    Reshut" in Hebrew)

  - `"tax"` is for Israel Tax Authority municipal id (also known as a
    "H.P. number")

- include_names:

  A logical vector of length 1, denoting if the names of municipalities
  (for each of the `id_types` chosen) should be included. Be aware that
  some municipal names might differ between different agencies.

## Value

A tibble, where every row is a municipality and the columns include id's
(and possibly names) of the municipalities from the chosen agencies.

## Details

The table is a fixed reference of 257 local authorities, reflecting the
set of authorities current as of the 2024 CBS municipal file. It has no
`year` argument, so when joining to an earlier year a handful of more
recently created authorities will not match.

Regional councils are returned with their 2-digit CBS code (e.g.
`"38"`). The CBS started encoding them as a 4-digit `5500 + code` (e.g.
`"5538"`) in the 2024 municipal file; to join to that data, recode the
regional council ids yourself, for example with
[`modify_muni_id()`](https://matanhakim.github.io/il.cbs.muni/reference/modify_muni_id.md).

## Examples

``` r
read_muni_id() |>
  dplyr::glimpse()
#> Rows: 257
#> Columns: 3
#> $ muni_id <chr> "0472", "0473", "0182", "2710", "0031", "2400", "1020", "3760"…
#> $ edu_id  <chr> "4721", "4739", "1826", "27102", "315", "24000", "10207", "376…
#> $ tax_id  <chr> "500204722", "500204730", "500201827", "500227103", "500200316…

read_muni_id(id_types = c("muni", "edu"), include_names = TRUE) |>
  dplyr::glimpse()
#> Rows: 257
#> Columns: 4
#> $ muni_id   <chr> "0472", "0473", "0182", "2710", "0031", "2400", "1020", "376…
#> $ muni_name <chr> "אבו גוש", "אבו סנאן", "אבן יהודה", "אום אל-פחם", "אופקים", …
#> $ edu_id    <chr> "4721", "4739", "1826", "27102", "315", "24000", "10207", "3…
#> $ edu_name  <chr> "אבו גוש", "אבו סנאן", "אבן יהודה", "אום אל-פחם", "אופקים", …
```
