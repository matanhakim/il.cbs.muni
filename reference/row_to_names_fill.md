# Elevate rows to be the column names of a data.frame and fill row-wise if needed

Casts data from rows to the column names of a data frame, with the
option to fill missing values row-wise. This utility is helpful in the
case of merged cells in Microsoft Excel, where the merged range has data
only in the first (unmerged) cell. This function is similar to
[`janitor::row_to_names()`](https://sfirke.github.io/janitor/reference/row_to_names.html),
with the exception of the fill utility.

## Usage

``` r
row_to_names_fill(
  data,
  row_number,
  fill_missing = TRUE,
  remove_row = TRUE,
  remove_rows_above = TRUE,
  sep = "_"
)
```

## Arguments

- data:

  A data frame.

- row_number:

  A numeric vector with he row indices of `data` containing the variable
  names. Allows for multiple rows input as a numeric vector. If multiple
  rows, values in the same column would be pasted with the `sep`
  argument as a separator. NAs are ignored.

- fill_missing:

  A logical vector of length 1 or of length `length(row_number)`. Every
  value in the vector denotes for the matching row in
  `data[row_number, ]` if the row should fill missing values (from left
  to right). If `TRUE` for a row, all missing values following a
  non-missing value will be replaced with that preceding non-missing
  value.

- remove_row:

  A logical vector of length 1, denoting if the row `row_number` should
  be removed from the resulting data.frame.

- remove_rows_above:

  A logical vector of length 1, denoting if the rows above
  `row_number` - that is, between `1:(row_number-1)` - should be removed
  from the resulting data.frame, in the case that `row_number != 1`.

- sep:

  A character vector of length 1 to separate the values in the case of
  multiple rows input to `row_number`.

## Value

A data frame with the same structure and class as the input `data` (a
tibble in returns a tibble; a data.frame in returns a data.frame), with
column names derived from the specified row(s). The returned data frame
has the same number of columns as the input, with rows removed according
to the `remove_row` and `remove_rows_above` parameters. All data types
and values are preserved from the original data frame.

## Examples

``` r
df <- data.frame(
  a = 1:6,
  b = rep(c("x", NA), 3),
  c = letters[1:6]
)

df
#>   a    b c
#> 1 1    x a
#> 2 2 <NA> b
#> 3 3    x c
#> 4 4 <NA> d
#> 5 5    x e
#> 6 6 <NA> f

row_to_names_fill(df, 2:3)
#>   2_3  2_x b_c
#> 1   4 <NA>   d
#> 2   5    x   e
#> 3   6 <NA>   f
row_to_names_fill(df, 2:3, sep = ".")
#>   2.3  2.x b.c
#> 1   4 <NA>   d
#> 2   5    x   e
#> 3   6 <NA>   f
row_to_names_fill(df, 2:4, fill_missing = c(TRUE, FALSE, FALSE))
#>   2_3_4  2_x b_c_d
#> 1     5    x     e
#> 2     6 <NA>     f
```
