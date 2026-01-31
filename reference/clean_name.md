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
clean_name("אילון תבור*")
#> [1] "אילון תבור"
clean_name("ג'סר א-זרקא")
#> [1] "ג'סר א-זרקא"
```
