pad_yishuv_id <- function(yishuv_id) {
  stringr::str_pad(yishuv_id, width = 4, side = "left", pad = "0")
}
