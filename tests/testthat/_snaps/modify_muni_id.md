# throws error for invalid input types

    Code
      modify_muni_id(TRUE, "1234")
    Condition
      Error in `modify_muni_id()`:
      ! `muni_id` must be a character or numeric vector.

---

    Code
      modify_muni_id("0", TRUE)
    Condition
      Error in `modify_muni_id()`:
      ! `yishuv_id` must be a character or numeric vector.

---

    Code
      modify_muni_id(list(1), "1234")
    Condition
      Error in `modify_muni_id()`:
      ! `muni_id` must be a character or numeric vector.

# throws error for length mismatch

    Code
      modify_muni_id(c(0, 99), c("100", "200", "300"))
    Condition
      Error in `modify_muni_id()`:
      ! `muni_id` and `yishuv_id` must have compatible lengths.
      i Length of `muni_id`: 2
      i Length of `yishuv_id`: 3

---

    Code
      modify_muni_id(c(0, 99, 10), c("100", "200"))
    Condition
      Error in `modify_muni_id()`:
      ! `muni_id` and `yishuv_id` must have compatible lengths.
      i Length of `muni_id`: 3
      i Length of `yishuv_id`: 2

