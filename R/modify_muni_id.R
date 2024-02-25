#' Modify a municipal id depending on the municipal status and yishuv id
#'
#' In the context of working with cbs municipal and yishuvim data, there is a
#' difference in the treatment of a yishuv and a municipality. In the cases of
#' cities and local councils the yishuv id and the municipality id are the same.
#' But in the case of regional councils, the municipality id is for the regional
#' council, while every yishuv within that municipality has a different yishuv id.
#' The Israeli CBS uses a concept of "municipal status" to differntiate between
#' the two. A municipal status of "0" represents a city, and "99" represents a local
#' council. Every other 2-digit number is the municipal id of a regional council.
#' This function modifies a municipal status based on itself and the yishuv_id.
#' It returns the correct municipal id after accounting for the "0" or "99" values.
#'
#' @param muni_id A character or numeric vector indicating the municipal status,
#' where "0" or "99" represents a city or a local council, and every other two-digit
#' number or character represents a regional council.
#' @param yishuv_id A character or numeric vector representing the yishuv id.
#' Should be 4 digits long according to the il.verse conventions.
#'
#' @return A character vector with 4 digits municipal id for cities and local councils
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
