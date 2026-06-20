#' Modify a municipal id depending on the municipal status and yishuv id
#'
#' In the context of working with cbs municipal and yishuvim data, there is a
#' difference in the treatment of a yishuv and a municipality. In the cases of
#' cities and local councils the yishuv id and the municipality id are the same.
#' But in the case of regional councils, the municipality id is for the regional
#' council, while every yishuv within that municipality has a different yishuv id.
#' The Israeli CBS uses a concept of "municipal status" to differentiate between
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
#' @param rc_code A character vector of length 1, one of `c("xx", "55xx")`,
#' choosing how the regional council code is written, where `xx` stands for the
#' council's 2-digit code. The CBS recoded regional councils in the 2024 municipal
#' file from the 2-digit code (e.g. `"38"`) to a 4-digit code formed as `5500 +`
#' that 2-digit code (e.g. `"5538"`).
#'
#' * `"xx"` (the default) returns the 2-digit code. It matches [read_muni_id()]
#' and CBS data up to and including 2023.
#'
#' * `"55xx"` returns the 4-digit code. Use it to match CBS data from 2024 onwards.
#'
#' Cities and local councils are unaffected; their id is the 4-digit `yishuv_id`
#' under both options. For `"55xx"`, `muni_id` is expected to hold a regional
#' council's 2-digit code (or `"0"`/`"99"` for a city or local council); values
#' outside that range are recoded as `5500 + muni_id` without further checking.
#'
#' @return A character vector of municipal ids: the 4-digit `yishuv_id` for cities
#' and local councils, and the regional council code in the chosen `rc_code` form
#' (2 digits for `"xx"`, 4 digits for `"55xx"`).
#' @export
#'
#' @examples
#' muni_id <- c(0, 99, 38, 69)
#' yishuv_id <- c("0001", "1000", NA, NA)
#' modify_muni_id(muni_id, yishuv_id) # regional councils as 38, 69
#' modify_muni_id(muni_id, yishuv_id, rc_code = "55xx") # as 5538, 5569
modify_muni_id <- function(
  muni_id,
  yishuv_id,
  rc_code = c("xx", "55xx")
) {
  rc_code <- rlang::arg_match(rc_code)

  # Validate yishuv_id
  if (
    !is.character(yishuv_id) &&
      !is.numeric(yishuv_id) &&
      !(is.logical(yishuv_id) && all(is.na(yishuv_id)))
  ) {
    rlang::abort(
      "`yishuv_id` must be a character or numeric vector.",
      class = "modify_muni_id_invalid_yishuv_type"
    )
  }

  # Validate muni_id
  if (
    !is.character(muni_id) &&
      !is.numeric(muni_id) &&
      !(is.logical(muni_id) && all(is.na(muni_id)))
  ) {
    rlang::abort(
      "`muni_id` must be a character or numeric vector.",
      class = "modify_muni_id_invalid_muni_type"
    )
  }

  # Check vector lengths match or can be recycled
  len_muni <- length(muni_id)
  len_yishuv <- length(yishuv_id)

  if (len_muni != len_yishuv && len_muni != 1 && len_yishuv != 1) {
    rlang::abort(
      c(
        "`muni_id` and `yishuv_id` must have compatible lengths.",
        "i" = paste0("Length of `muni_id`: ", len_muni),
        "i" = paste0("Length of `yishuv_id`: ", len_yishuv)
      ),
      class = "modify_muni_id_length_mismatch"
    )
  }

  # A zero-length input yields a zero-length result. Standard recycling treats
  # size 0 combined with size 1 as size 0; without this guard the `rep_len()`
  # below would fabricate a length-1 NA.
  if (len_muni == 0L || len_yishuv == 0L) {
    return(character(0))
  }

  if (is.numeric(muni_id)) muni_id <- as.character(muni_id)
  if (is.numeric(yishuv_id)) yishuv_id <- as.character(yishuv_id)

  # Recycle to a common length first so the condition and both branches are the
  # same size. `dplyr::case_when()` warned (deprecated since dplyr 1.2.0) when a
  # length-1 condition was paired with a longer replacement.
  n <- max(length(muni_id), length(yishuv_id))
  muni_id <- rep_len(muni_id, n)
  yishuv_id <- rep_len(yishuv_id, n)

  rc_id <- if (rc_code == "55xx") {
    # CBS 2024+ form: regional council code = 5500 + the 2-digit code.
    as.character(suppressWarnings(as.integer(muni_id)) + 5500L)
  } else {
    stringr::str_pad(muni_id, width = 2, side = "left", pad = "0")
  }

  # Cities ("0") and local councils ("99") return the yishuv id. Compare
  # numerically so zero-padded forms such as "00" or "099" are also recognised.
  is_city <- suppressWarnings(as.integer(muni_id)) %in% c(0L, 99L)
  dplyr::if_else(is_city, yishuv_id, rc_id)
}
