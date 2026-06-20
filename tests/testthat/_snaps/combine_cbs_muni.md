# invalid path errors

    Code
      combine_cbs_muni("nonexistent_file.xls", year = 2009, cols_city = 1:5, cols_rc = 1:
        5)
    Condition
      Error in `read_cbs_muni()`:
      ! `path` does not exist.
      i Provided path: nonexistent_file.xls

---

    Code
      combine_cbs_muni(c("file1.xls", "file2.xls"), year = 2009, cols_city = 1:5,
      cols_rc = 1:5)
    Condition
      Error in `combine_cbs_muni()`:
      ! `path` must be a character vector of length 1.

# invalid year errors

    Code
      combine_cbs_muni(path, year = "2009", cols_city = 1:5, cols_rc = 1:5)
    Condition
      Error in `combine_cbs_muni()`:
      ! `year` must be a numeric vector of length 1.

---

    Code
      combine_cbs_muni(path, year = c(2009, 2010), cols_city = 1:5, cols_rc = 1:5)
    Condition
      Error in `combine_cbs_muni()`:
      ! `year` must be a numeric vector of length 1.

# invalid col_names errors

    Code
      combine_cbs_muni(system.file("extdata", "2009.xls", package = "il.cbs.muni"),
      year = 2009, cols_city = 1:5, cols_rc = 1:5, col_names = 123)
    Condition
      Error in `combine_cbs_muni()`:
      ! `col_names` must be NULL or a character vector.

# mismatched cols_city / cols_rc length errors

    Code
      combine_cbs_muni(system.file("extdata", "2009.xls", package = "il.cbs.muni"),
      year = 2009, cols_city = c(1, 2, 3), cols_rc = c(1, 2))
    Condition
      Error in `combine_cbs_muni()`:
      ! `cols_city` and `cols_rc` must select the same number of columns.
      i `cols_city` selected 3 column(s).
      i `cols_rc` selected 2 column(s).
      x Columns are matched by position, so the counts must match.

# missing column selections error

    Code
      combine_cbs_muni(system.file("extdata", "2009.xls", package = "il.cbs.muni"),
      year = 2009)
    Condition
      Error in `combine_cbs_muni()`:
      ! `cols_city` and `cols_rc` must both be supplied.

# col_names length must match the selected columns

    Code
      combine_cbs_muni(system.file("extdata", "2009.xls", package = "il.cbs.muni"),
      year = 2009, cols_city = 1:3, cols_rc = 1:3, col_names = c("a", "b"))
    Condition
      Error in `combine_cbs_muni()`:
      ! `col_names` must have the same length as the number of selected columns.
      i `col_names` length: 2
      x Number of selected columns: 3

