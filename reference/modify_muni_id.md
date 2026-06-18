# Modify a municipal id depending on the municipal status and yishuv id

In the context of working with cbs municipal and yishuvim data, there is
a difference in the treatment of a yishuv and a municipality. In the
cases of cities and local councils the yishuv id and the municipality id
are the same. But in the case of regional councils, the municipality id
is for the regional council, while every yishuv within that municipality
has a different yishuv id. The Israeli CBS uses a concept of "municipal
status" to differentiate between the two. A municipal status of "0"
represents a city, and "99" represents a local council. Every other
2-digit number is the municipal id of a regional council. This function
modifies a municipal status based on itself and the yishuv_id. It
returns the correct municipal id after accounting for the "0" or "99"
values.

## Usage

``` r
modify_muni_id(muni_id, yishuv_id, rc_code = c("xx", "55xx"))
```

## Arguments

- muni_id:

  A character or numeric vector indicating the municipal status, where
  "0" or "99" represents a city or a local council, and every other
  two-digit number or character represents a regional council.

- yishuv_id:

  A character or numeric vector representing the yishuv id. Should be 4
  digits long according to the il.verse conventions.

- rc_code:

  A character vector of length 1, one of `c("xx", "55xx")`, choosing how
  the regional council code is written, where `xx` stands for the
  council's 2-digit code. The CBS recoded regional councils in the 2024
  municipal file from the 2-digit code (e.g. `"38"`) to a 4-digit code
  formed as `5500 +` that 2-digit code (e.g. `"5538"`).

  - `"xx"` (the default) returns the 2-digit code. It matches
    [`read_muni_id()`](https://matanhakim.github.io/il.cbs.muni/reference/read_muni_id.md)
    and CBS data up to and including 2023.

  - `"55xx"` returns the 4-digit code. Use it to match CBS data from
    2024 onwards.

  Cities and local councils are unaffected; their id is the 4-digit
  `yishuv_id` under both options. For `"55xx"`, `muni_id` is expected to
  hold a regional council's 2-digit code (or `"0"`/`"99"` for a city or
  local council); values outside that range are recoded as
  `5500 + muni_id` without further checking.

## Value

A character vector of municipal ids: the 4-digit `yishuv_id` for cities
and local councils, and the regional council code in the chosen
`rc_code` form (2 digits for `"xx"`, 4 digits for `"55xx"`).

## Examples

``` r
muni_id <- c(0, 99, 38, 69)
yishuv_id <- c("0001", "1000", NA, NA)
modify_muni_id(muni_id, yishuv_id) # regional councils as 38, 69
#> [1] "0001" "1000" "38"   "69"  
modify_muni_id(muni_id, yishuv_id, rc_code = "55xx") # as 5538, 5569
#> [1] "0001" "1000" "5538" "5569"
```
