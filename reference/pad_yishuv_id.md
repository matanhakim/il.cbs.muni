# Pad a yishuv id to a 4-digit character vector

Pad a yishuv id to a 4-digit character vector

## Usage

``` r
pad_yishuv_id(yishuv_id)
```

## Arguments

- yishuv_id:

  a character vector containing only characters and numbers, where each
  element is no longer than 4 characters or digits.

## Value

A character or numeric vector, where each element is 4 characters long,
containing only numbers and left-padded with 0's.

## Examples

``` r
x <- c(1, "23", "4000", 5600)
pad_yishuv_id(x)
#> [1] "0001" "0023" "4000" "5600"
```
