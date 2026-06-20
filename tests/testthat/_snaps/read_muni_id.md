# read_muni_id() validates id_types and include_names

    Code
      read_muni_id(id_types = 1)
    Condition
      Error in `read_muni_id()`:
      ! `id_types` must be a character vector.

---

    Code
      read_muni_id(id_types = c("muni", "foo"))
    Condition
      Error in `read_muni_id()`:
      ! `id_types` must contain only valid type values.
      i Valid types: muni, edu, tax
      x Invalid types provided: foo

---

    Code
      read_muni_id(include_names = "yes")
    Condition
      Error in `read_muni_id()`:
      ! `include_names` must be a single logical value (TRUE or FALSE).

---

    Code
      read_muni_id(include_names = NA)
    Condition
      Error in `read_muni_id()`:
      ! `include_names` must be a single logical value (TRUE or FALSE).

