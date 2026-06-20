# throws error for invalid input types

    Code
      row_to_names_fill("not_a_df", 1)
    Condition
      Error in `row_to_names_fill()`:
      ! `data` must be a data.frame.

---

    Code
      row_to_names_fill(df_1, "not_numeric")
    Condition
      Error in `row_to_names_fill()`:
      ! `row_number` must be a numeric vector.

---

    Code
      row_to_names_fill(df_1, 1, fill_missing = "not_logical")
    Condition
      Error in `row_to_names_fill()`:
      ! `fill_missing` must be a logical vector.

# throws error for out of range row numbers

    Code
      row_to_names_fill(df_1, 10)
    Condition
      Error in `row_to_names_fill()`:
      ! `row_number` must contain valid row indices.
      i Data has 3 rows.
      x Invalid row numbers: 10

---

    Code
      row_to_names_fill(df_1, 0)
    Condition
      Error in `row_to_names_fill()`:
      ! `row_number` must contain valid row indices.
      i Data has 3 rows.
      x Invalid row numbers: 0

# throws error for length mismatch

    Code
      row_to_names_fill(df_1, 1:2, fill_missing = c(TRUE, FALSE, TRUE))
    Condition
      Error in `row_to_names_fill()`:
      ! `fill_missing` must have length 1 or equal to length of `row_number`.
      i Length of `row_number`: 2
      x Length of `fill_missing`: 3

# validates remove_row, remove_rows_above and sep

    Code
      row_to_names_fill(df_1, 1, remove_row = "yes")
    Condition
      Error in `row_to_names_fill()`:
      ! `remove_row` must be a single logical value (TRUE or FALSE).

---

    Code
      row_to_names_fill(df_1, 1, remove_rows_above = NA)
    Condition
      Error in `row_to_names_fill()`:
      ! `remove_rows_above` must be a single logical value (TRUE or FALSE).

---

    Code
      row_to_names_fill(df_1, 1, sep = 1)
    Condition
      Error in `row_to_names_fill()`:
      ! `sep` must be a character vector of length 1.

