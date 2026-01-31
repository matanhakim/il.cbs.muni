# Clean a string from characters unwanted in (mostly) yishuv names

Clean a string from characters unwanted in (mostly) yishuv names

## Usage

``` r
clean_name(name)
```

## Arguments

- name:

  a character vector

## Value

a character vector without leading and trailing white space, and with
characters that are only letters and digits, excluding the following:
`'-()\"`

## Examples

``` r
clean_name("test-123_test*456")
#> [1] "test-123test456"
x <- read_cbs_yishuv(system.file("extdata", "bycode2021.xlsx",
 package = "il.cbs.muni"))[[1]][c(153, 342)]
x
#> [1] "אילון תבור*" "ג'סר א-זרקא"
clean_name(x)
#> [1] "אילון תבור"  "ג'סר א-זרקא"
```
