# an unsupported year/unit_type combination errors informatively

    Code
      read_cbs_index(system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
      year = 2099, index_type = "ses", quiet = TRUE)
    Condition
      Error in `read_cbs_index()`:
      ! No built-in parameters for this combination.
      i Requested: year = 2099, index_type = "ses"; unit_type = "muni".
      i Supported years for this index_type/unit_type: 2013, 2015, 2017, 2019, 2021.
      i See `il.cbs.muni:::df_cbs_index_params` for all supported combinations.

---

    Code
      read_cbs_index(system.file("extdata", "24_22_420t1.xlsx", package = "il.cbs.muni"),
      year = 2099, index_type = "peri", unit_type = "sa", quiet = TRUE)
    Condition
      Error in `read_cbs_index()`:
      ! No built-in parameters for this combination.
      i Requested: year = 2099, index_type = "peri"; unit_type = "sa".
      i This index_type/unit_type combination is not supported for any year.
      i See `il.cbs.muni:::df_cbs_index_params` for all supported combinations.

# invalid path, year, col_names and quiet error

    Code
      read_cbs_index(c("a", "b"), 2019, "ses")
    Condition
      Error in `read_cbs_index()`:
      ! `path` must be a character vector of length 1.

---

    Code
      read_cbs_index("nonexistent.xlsx", 2019, "ses")
    Condition
      Error in `read_cbs_index()`:
      ! `path` does not exist.
      i Provided path: nonexistent.xlsx

---

    Code
      read_cbs_index(path, "2019", "ses")
    Condition
      Error in `read_cbs_index()`:
      ! `year` must be a numeric vector of length 1.

---

    Code
      read_cbs_index(path, NA_real_, "ses")
    Condition
      Error in `read_cbs_index()`:
      ! `year` must be a numeric vector of length 1.

---

    Code
      read_cbs_index(path, 2019, "ses", col_names = 1)
    Condition
      Error in `read_cbs_index()`:
      ! `col_names` must be NULL or a character vector.

---

    Code
      read_cbs_index(path, 2019, "ses", quiet = "yes")
    Condition
      Error in `read_cbs_index()`:
      ! `quiet` must be a single logical value (TRUE or FALSE).

# col_names length must match the selected columns

    Code
      read_cbs_index(system.file("extdata", "24_22_375t1.xlsx", package = "il.cbs.muni"),
      2019, "ses", cols = c(1, 2), col_names = "only_one", quiet = TRUE)
    Condition
      Error in `read_cbs_index()`:
      ! `col_names` must have the same length as the number of selected columns.
      i `col_names` length: 1
      x Number of selected columns: 2

