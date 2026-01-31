# Read a municipal data file to a tibble

This function is a wrapper around
[`readxl::read_excel()`](https://readxl.tidyverse.org/reference/read_excel.html),
reading a specific municipal data file for a specific year and a
specific data domain. Its added value is in its use of
[`row_to_names_fill()`](https://matanhakim.github.io/il.cbs.muni/reference/row_to_names_fill.md)
and its pre-defined parameters for every year and its specific quirks in
the Excel headers. For advanced users, the full set of options is
available with `il.cbs.muni:::df_cbs_muni_params`.

## Usage

``` r
read_cbs_muni(
  path,
  year,
  muni_type = c("all", "city_lc", "rc"),
  data_domain = c("physical", "budget", "summary", "labor_force_survey", "social_survey"),
  cols = NULL,
  col_names = NULL
)
```

## Arguments

- path:

  A character vector of length 1, denoting the local file path to the
  municipal data file. A full list of available files by the CBS is at
  the [relevant CBS
  page](https://www.cbs.gov.il/he/publications/Pages/2019/%D7%94%D7%A8%D7%A9%D7%95%D7%99%D7%95%D7%AA-%D7%94%D7%9E%D7%A7%D7%95%D7%9E%D7%99%D7%95%D7%AA-%D7%91%D7%99%D7%A9%D7%A8%D7%90%D7%9C-%D7%A7%D7%95%D7%91%D7%A6%D7%99-%D7%A0%D7%AA%D7%95%D7%A0%D7%99%D7%9D-%D7%9C%D7%A2%D7%99%D7%91%D7%95%D7%93-1999-2017.aspx).

- year:

  A numeric vector of length 1 denoting which year the data file pointed
  in `path` is for. Currently supporting only 2003 and later, since
  before 2003 the data structure is very different.

- muni_type:

  A character vector of length 1, one of `c("all", "city_lc", "rc")`.
  Since 2016, all municipal types are bundled together in the same
  sheets, but before 2016 there are different sheets for cities and
  local councils (`"city_lc"`) and regional councils (`"rc"`). This
  parameter chooses which sheet you would read.

- data_domain:

  A character vector of length 1, one of
  `c("physical", "budget", "summary", "labor_force_survey", "social_survey")`.
  Every Excel municipal data file has a few different data domains, most
  notably physical and population data, and budget data.

- cols:

  \<[tidy-select](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to keep. The default `NULL` keeps all columns.

- col_names:

  A character vector containing the new column names of the output
  tibble. If `NULL` then the tibble uses the original column names. Must
  be the same length as the number of columns picked in `cols`.

## Value

A tibble with municipal data for a specific year, where every row is a
municipality and every column is a different variable for this
municipality in that year. Be advised all columns are of type character,
so you need to parse the data types yourself at will. Column names are
merged from the relevant headers, and only single whitespaces are kept.
Rows with more than 90% empty cells (usually rows with non-data notes)
are removed.

## Examples

``` r
df <- read_cbs_muni(
  system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
  year = 2021,
  data_domain = "physical"
)

df |>
  dplyr::select(1:15) |>
  dplyr::glimpse()
#> Rows: 255
#> Columns: 15
#> $ `שם הרשות`                                                          <chr> "א…
#> $ `כללי_סמל הרשות`                                                    <chr> "2…
#> $ כללי_מחוז                                                           <chr> "ח…
#> $ `כללי_מעמד מוניציפלי`                                               <chr> "ע…
#> $ `כללי_מרחק מגבול מחוז תל אביב (ק"מ)`                                <chr> "6…
#> $ `כללי_שנת קבלת מעמד מוניציפלי`                                      <chr> "1…
#> $ `כללי_מרחב ימי, רשויות מקומיות הגובלות בחוף הים`                    <chr> "0…
#> $ `כללי_מספר חברי מועצה`                                              <chr> "1…
#> $ `כללי_סמל ועדת תכנון ובנייה`                                        <chr> "3…
#> $ `כללי_שם ועדת תכנון ובנייה`                                         <chr> "ע…
#> $ `כללי_שטח (קמ"ר)`                                                   <chr> "2…
#> $ `דמוגרפיה_צפיפות אוכלוסייה לקמ''ר ביישובים שמנו 5,000 תושבים ויותר` <chr> "2…
#> $ `דמוגרפיה_סה"כ אוכלוסייה בסוף השנה`                                 <chr> "5…
#> $ `דמוגרפיה_יהודים ואחרים (אחוזים)`                                   <chr> "-…
#> $ `דמוגרפיה_יהודים (אחוזים מתוך יהודים ואחרים)`                       <chr> "-…
```
