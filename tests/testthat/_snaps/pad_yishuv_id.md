# pad_yishuv_id() throws an error when input is too long

    Code
      pad_yishuv_id("12345")
    Condition
      Error in `pad_yishuv_id()`:
      ! `yishuv_id` elements must be no longer than 4 characters.
      i Found element(s) with length 5.

---

    Code
      pad_yishuv_id(12345)
    Condition
      Error in `pad_yishuv_id()`:
      ! `yishuv_id` elements must be no longer than 4 characters.
      i Found element(s) with length 5.

---

    Code
      pad_yishuv_id(c(1, 2, 12345))
    Condition
      Error in `pad_yishuv_id()`:
      ! `yishuv_id` elements must be no longer than 4 characters.
      i Found element(s) with length 5.

# pad_yishuv_id() throws an error when input is not character or numeric

    Code
      pad_yishuv_id(TRUE)
    Condition
      Error in `pad_yishuv_id()`:
      ! `yishuv_id` must be a character or numeric vector.

---

    Code
      pad_yishuv_id(list(1, 2, 3))
    Condition
      Error in `pad_yishuv_id()`:
      ! `yishuv_id` must be a character or numeric vector.

---

    Code
      pad_yishuv_id(factor(c("1", "2")))
    Condition
      Error in `pad_yishuv_id()`:
      ! `yishuv_id` must be a character or numeric vector.

