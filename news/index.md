# Changelog

## il.cbs.muni 0.1.0

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
- Full test coverage with 126+ tests
