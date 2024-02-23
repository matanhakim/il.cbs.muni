#' Modify a municipal id depending on the municipal status and yishuv id
#'
#' @param muni_id a character or numeric vector indicating the municipal status,
#' where "0" or "99" represents a city or a local council, and every other two-digit
#' number or character represents a regional council.
#' @param yishuv_id a character or numeric vector representing the yishuv id.
#' should be 4 digits long according to the il.verse conventions.
#'
#' @return a character vector with 4 digits municipal id for cities and local councils
#' and 2 digits municipal id for regional councils.
#' @export
#'
#' @examples
#' muni_id <- c(0, 99, 1, 2)
#' yishuv_id <- c("0001", "1000", "1234", "1567")
#' modify_muni_id(muni_id, yishuv_id)
modify_muni_id <- function(muni_id, yishuv_id){
  stopifnot(is.character(yishuv_id) | is.numeric(yishuv_id))
  if (is.numeric(muni_id))
    muni_id <- as.character(muni_id)
  if (is.numeric(yishuv_id))
    yishuv_id <- as.character(yishuv_id)
  dplyr::case_when(
    (muni_id == "0" | muni_id == "99") ~ yishuv_id,
    TRUE ~ stringr::str_pad(muni_id, width = 2, side = "left", pad = "0")
  )
}
