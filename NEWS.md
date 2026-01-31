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
