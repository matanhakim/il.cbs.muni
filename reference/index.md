# Package index

## Read CBS data files

Read municipal, locality and index data files into tidy tibbles.

- [`read_cbs_muni()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_muni.md)
  : Read a municipal data file to a tibble
- [`read_cbs_index()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_index.md)
  **\[experimental\]** : Read a CBS index data file to a tibble
- [`read_cbs_yishuv()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_yishuv.md)
  : Read a yishuvim data file to a tibble
- [`combine_cbs_muni()`](https://matanhakim.github.io/il.cbs.muni/reference/combine_cbs_muni.md)
  : Combine municipalities data frames from different sheets

## Identifiers

Harmonize and reshape Israeli local-authority and locality identifiers.

- [`read_muni_id()`](https://matanhakim.github.io/il.cbs.muni/reference/read_muni_id.md)
  : Read municipalities id's and names
- [`modify_muni_id()`](https://matanhakim.github.io/il.cbs.muni/reference/modify_muni_id.md)
  : Modify a municipal id depending on the municipal status and yishuv
  id
- [`pad_yishuv_id()`](https://matanhakim.github.io/il.cbs.muni/reference/pad_yishuv_id.md)
  : Pad a yishuv id to a 4-digit character vector

## Helpers

Lower-level utilities used by the readers.

- [`clean_name()`](https://matanhakim.github.io/il.cbs.muni/reference/clean_name.md)
  : Clean a string from characters unwanted in (mostly) yishuv names
- [`row_to_names_fill()`](https://matanhakim.github.io/il.cbs.muni/reference/row_to_names_fill.md)
  : Elevate rows to be the column names of a data.frame and fill
  row-wise if needed
