# Changelog

## il.cbs.muni 0.2.0

- [`combine_cbs_muni()`](https://matanhakim.github.io/il.cbs.muni/reference/combine_cbs_muni.md)
  now errors when `cols_city` and `cols_rc` select different numbers of
  columns, instead of silently misaligning the regional-council data
  when the two sheets are bound together.
- [`modify_muni_id()`](https://matanhakim.github.io/il.cbs.muni/reference/modify_muni_id.md)
  gains a `rc_code` argument that chooses how a regional council code is
  written: `"xx"` (the default) keeps the 2-digit code (e.g. `38`),
  matching
  [`read_muni_id()`](https://matanhakim.github.io/il.cbs.muni/reference/read_muni_id.md)
  and CBS data up to 2023, and `"55xx"` returns the 4-digit
  `5500 + code` form (e.g. `5538`) used in the CBS 2024 municipal file.
- [`modify_muni_id()`](https://matanhakim.github.io/il.cbs.muni/reference/modify_muni_id.md)
  no longer emits a dplyr deprecation warning when recycling a length-1
  input against a longer one, and now also recognises zero-padded city
  and local-council codes such as `"00"` and `"099"`.
- [`read_cbs_index()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_index.md)
  detects the geographic level of the file (municipality, locality or
  statistical area) from its content and applies the matching header
  layout, so it no longer matters which table number the CBS used for
  that level in a given edition; the level is stored in the
  `"unit_type"` attribute of the result. Pass `unit_type` explicitly to
  override detection for a file whose level you already know.
- [`read_cbs_index()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_index.md)
  gains a `quiet` argument to silence the message that reports the
  geographic level used.
- [`read_cbs_index()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_index.md)
  no longer errors for the periphery index (any year) or for the SES
  2013 municipal index; an internal `fill_missing` parameter whose
  length did not match the header rows made those calls fail before any
  data was read.
- [`read_cbs_index()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_index.md)
  now supports the SES 2021 municipal index and is marked experimental,
  because the CBS index publications place the same geographic level in
  different table numbers across editions and alternate between xls and
  xlsx.
- [`read_cbs_index()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_index.md)
  now raises an informative error that lists the supported years when
  called with an unsupported year, index_type or unit_type combination.
- [`read_cbs_index()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_index.md),
  [`read_cbs_muni()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_muni.md),
  [`read_cbs_yishuv()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_yishuv.md)
  and
  [`combine_cbs_muni()`](https://matanhakim.github.io/il.cbs.muni/reference/combine_cbs_muni.md)
  now error informatively when `col_names` does not match the number of
  selected columns, instead of silently padding or truncating the column
  names.
- [`read_cbs_muni()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_muni.md)
  now supports 2024 for the physical, budget, labor force survey and
  social survey domains.
- [`read_cbs_muni()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_muni.md)
  drops the aggregate summary rows (national total and per
  municipal-status subtotals) that CBS added to the physical and budget
  sheets from 2022 onwards, so every returned row is a single
  municipality as documented; set the new experimental
  `keep_summary_rows = TRUE` to keep them.
- [`read_cbs_muni()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_muni.md)
  now raises an informative error that lists the supported years when
  called with an unsupported year, muni_type or data_domain combination.
- [`read_muni_id()`](https://matanhakim.github.io/il.cbs.muni/reference/read_muni_id.md)
  now returns 257 local authorities, adding the local councils צור הדסה
  and שער שומרון (these are administered under their parent authorities
  by the Ministry of Education, so their education symbol is `NA`).

## il.cbs.muni 0.1.0

CRAN release: 2026-02-12

- Initial CRAN submission
- Functions for reading and processing Israeli Central Bureau of
  Statistics municipal data
- Core utilities:
  - [`pad_yishuv_id()`](https://matanhakim.github.io/il.cbs.muni/reference/pad_yishuv_id.md):
    Pad yishuv (settlement) IDs to standard 4-character format
  - [`clean_name()`](https://matanhakim.github.io/il.cbs.muni/reference/clean_name.md):
    Clean and standardize municipality names
  - [`modify_muni_id()`](https://matanhakim.github.io/il.cbs.muni/reference/modify_muni_id.md):
    Modify municipal IDs based on yishuv IDs
  - [`combine_cbs_muni()`](https://matanhakim.github.io/il.cbs.muni/reference/combine_cbs_muni.md):
    Combine municipal data from multiple years
  - [`read_cbs_muni()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_muni.md):
    Read CBS municipal data files
  - [`read_cbs_yishuv()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_yishuv.md):
    Read CBS yishuv data files
  - [`read_cbs_index()`](https://matanhakim.github.io/il.cbs.muni/reference/read_cbs_index.md):
    Read CBS index files
  - [`read_muni_id()`](https://matanhakim.github.io/il.cbs.muni/reference/read_muni_id.md):
    Read municipal ID mapping data
  - [`row_to_names_fill()`](https://matanhakim.github.io/il.cbs.muni/reference/row_to_names_fill.md):
    Convert row to column names with filling
- Comprehensive input validation with informative error messages
- Unit tests covering all exported functions
