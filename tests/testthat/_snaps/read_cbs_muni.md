# invalid keep_summary_rows errors

    Code
      read_cbs_muni(system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
      year = 2021, data_domain = "physical", keep_summary_rows = "yes")
    Condition
      Error in `read_cbs_muni()`:
      ! `keep_summary_rows` must be a single logical value (TRUE or FALSE).

# an unsupported year errors informatively

    Code
      read_cbs_muni(system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
      year = 1990, data_domain = "physical")
    Condition
      Error in `read_cbs_muni()`:
      ! No built-in parameters for this combination.
      i Requested: year = 1990, muni_type = "all", data_domain = "physical".
      i Supported years for this muni_type/data_domain: 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024.
      i See `il.cbs.muni:::df_cbs_muni_params` for all supported combinations.

# the summary domain is unsupported from 2022 onwards

    Code
      read_cbs_muni(system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
      year = 2024, data_domain = "summary")
    Condition
      Error in `read_cbs_muni()`:
      ! No built-in parameters for this combination.
      i Requested: year = 2024, muni_type = "all", data_domain = "summary".
      i Supported years for this muni_type/data_domain: 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021.
      i See `il.cbs.muni:::df_cbs_muni_params` for all supported combinations.

# an unsupported muni_type/data_domain combination errors

    Code
      read_cbs_muni(system.file("extdata", "p_libud_2021.xlsx", package = "il.cbs.muni"),
      year = 2099, muni_type = "rc", data_domain = "social_survey")
    Condition
      Error in `read_cbs_muni()`:
      ! No built-in parameters for this combination.
      i Requested: year = 2099, muni_type = "rc", data_domain = "social_survey".
      i This muni_type/data_domain combination is not supported for any year.
      i See `il.cbs.muni:::df_cbs_muni_params` for all supported combinations.

# invalid path errors

    Code
      read_cbs_muni("nonexistent_file.xlsx", year = 2021, data_domain = "physical")
    Condition
      Error in `read_cbs_muni()`:
      ! `path` does not exist.
      i Provided path: nonexistent_file.xlsx

---

    Code
      read_cbs_muni(c("file1.xlsx", "file2.xlsx"), year = 2021, data_domain = "physical")
    Condition
      Error in `read_cbs_muni()`:
      ! `path` must be a character vector of length 1.

# invalid year errors

    Code
      read_cbs_muni(path, year = "2021", data_domain = "physical")
    Condition
      Error in `read_cbs_muni()`:
      ! `year` must be a numeric vector of length 1.

---

    Code
      read_cbs_muni(path, year = c(2021, 2022), data_domain = "physical")
    Condition
      Error in `read_cbs_muni()`:
      ! `year` must be a numeric vector of length 1.

---

    Code
      read_cbs_muni(path, year = NA_real_, data_domain = "physical")
    Condition
      Error in `read_cbs_muni()`:
      ! `year` must be a numeric vector of length 1.

# invalid col_names errors

    Code
      read_cbs_muni(path, year = 2021, data_domain = "physical", col_names = 123)
    Condition
      Error in `read_cbs_muni()`:
      ! `col_names` must be NULL or a character vector.

---

    Code
      read_cbs_muni(path, year = 2021, data_domain = "physical", cols = c(1, 2),
      col_names = "only_one")
    Condition
      Error in `read_cbs_muni()`:
      ! `col_names` must have the same length as the number of selected columns.
      i `col_names` length: 1
      x Number of selected columns: 2

