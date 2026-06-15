# il.cbs.muni 0.2.0

* `modify_muni_id()` no longer emits a dplyr deprecation warning when recycling a length-1 input against a longer one.
* `read_cbs_index()` no longer errors for the periphery index (any year) or for the SES 2013 municipal index; an internal `fill_missing` parameter whose length did not match the header rows made those calls fail before any data was read.
* `read_cbs_index()` now supports the SES 2021 municipal index and is marked experimental, because the CBS index publications place the same geographic level in different table numbers across editions and alternate between xls and xlsx.
* `read_cbs_index()` now raises an informative error that lists the supported years when called with an unsupported year, index_type or unit_type combination.
* `read_cbs_muni()` now supports 2024 for the physical, budget, labor force survey and social survey domains.
* `read_cbs_muni()` drops the aggregate summary rows (national total and per municipal-status subtotals) that CBS added to the physical and budget sheets from 2022 onwards, so every returned row is a single municipality as documented; set the new experimental `keep_summary_rows = TRUE` to keep them.
* `read_cbs_muni()` now raises an informative error that lists the supported years when called with an unsupported year, muni_type or data_domain combination.

# il.cbs.muni 0.1.0

* Initial CRAN submission
* Functions for reading and processing Israeli Central Bureau of Statistics municipal data
* Core utilities:
  - `pad_yishuv_id()`: Pad yishuv (settlement) IDs to standard 4-character format
  - `clean_name()`: Clean and standardize municipality names
  - `modify_muni_id()`: Modify municipal IDs based on yishuv IDs
  - `combine_cbs_muni()`: Combine municipal data from multiple years
  - `read_cbs_muni()`: Read CBS municipal data files
  - `read_cbs_yishuv()`: Read CBS yishuv data files
  - `read_cbs_index()`: Read CBS index files
  - `read_muni_id()`: Read municipal ID mapping data
  - `row_to_names_fill()`: Convert row to column names with filling
* Comprehensive input validation with informative error messages
* Full test coverage with 126+ tests
