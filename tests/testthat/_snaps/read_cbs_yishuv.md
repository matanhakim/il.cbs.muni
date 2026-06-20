# invalid path errors

    Code
      read_cbs_yishuv("nonexistent_file.xlsx")
    Condition
      Error in `read_cbs_yishuv()`:
      ! `path` does not exist.
      i Provided path: nonexistent_file.xlsx

---

    Code
      read_cbs_yishuv(c("file1.xlsx", "file2.xlsx"))
    Condition
      Error in `read_cbs_yishuv()`:
      ! `path` must be a character vector of length 1.

# invalid col_names type errors

    Code
      read_cbs_yishuv(system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni"),
      col_names = 123)
    Condition
      Error in `read_cbs_yishuv()`:
      ! `col_names` must be NULL or a character vector.

# col_names length must match the selected columns

    Code
      read_cbs_yishuv(system.file("extdata", "bycode2021.xlsx", package = "il.cbs.muni"),
      cols = c(1, 2), col_names = "only_one")
    Condition
      Error in `read_cbs_yishuv()`:
      ! `col_names` must have the same length as the number of selected columns.
      i `col_names` length: 1
      x Number of selected columns: 2

