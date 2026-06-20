# throws error for invalid input type

    Code
      clean_name(1)
    Condition
      Error in `clean_name()`:
      ! `name` must be a character vector.

---

    Code
      clean_name(TRUE)
    Condition
      Error in `clean_name()`:
      ! `name` must be a character vector.

---

    Code
      clean_name(list("a", "b"))
    Condition
      Error in `clean_name()`:
      ! `name` must be a character vector.

