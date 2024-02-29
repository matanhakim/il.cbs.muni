#' Pad a yishuv id to a 4-digit character vector
#'
#' @param yishuv_id a character vector containing only characters and numbers, where each
#' element is no longer than 4 characters or digits.
#'
#' @return A character or numeric vector, where each element is 4 characters long,
#' containing only numbers and left-padded with 0's.
#' @export
#'
#' @examples
#' x <- c(1, "23", "4000", 5600)
#' pad_yishuv_id(x)
pad_yishuv_id <- function(yishuv_id) {
  stopifnot(
    is.character(yishuv_id) | is.numeric(yishuv_id),
    max(stringr::str_length(yishuv_id), na.rm = TRUE) <= 4
  )
  stringr::str_pad(yishuv_id, width = 4, side = "left", pad = "0")
}
