#' Pad a yishuv id to a 4-digit character vector
#'
#' @param yishuv_id a character vector containing only characters and numbers, where each
#' element is no longer than 4 characters or digits.
#'
#' @return A character vector the same length as `yishuv_id`, where each element is
#' 4 characters long and left-padded with `"0"`.
#' @export
#'
#' @examples
#' x <- c(1, "23", "4000", 5600)
#' pad_yishuv_id(x)
pad_yishuv_id <- function(yishuv_id) {
  # Validate input type
  if (!is.character(yishuv_id) && !is.numeric(yishuv_id) && 
      !(is.logical(yishuv_id) && all(is.na(yishuv_id)))) {
    rlang::abort(
      "`yishuv_id` must be a character or numeric vector.",
      class = "pad_yishuv_id_invalid_type"
    )
  }
  
  # Check maximum length (excluding NAs)
  lengths <- stringr::str_length(yishuv_id)
  max_length <- if (all(is.na(lengths))) -Inf else max(lengths, na.rm = TRUE)
  if (!is.infinite(max_length) && max_length > 4) {
    rlang::abort(
      c(
        "`yishuv_id` elements must be no longer than 4 characters.",
        "i" = paste0("Found element(s) with length ", max_length, ".")
      ),
      class = "pad_yishuv_id_too_long"
    )
  }
  
  stringr::str_pad(yishuv_id, width = 4, side = "left", pad = "0")
}
