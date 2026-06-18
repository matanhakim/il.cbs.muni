#' Read municipalities id's and names
#'
#' Israeli municipalities have different id's and sometimes even different names
#' across different government organizations. This function allows you to read
#' different municipality id's and names , so interchanging between the different
#' specifications would be easier.
#'
#' @param id_types A character vector of length between 1 and 3, containing at least
#' one (or two, or all of) of the possible values. id's (and possibly names) of
#' municipalities are kept for the selected sources:
#'
#' * `"muni"` is for CBS id's and (cleaned) names.
#'
#' * `"edu"` is for Ministry of Education municipal symbol ("Semel Reshut" in Hebrew)
#'
#' * `"tax"` is for Israel Tax Authority municipal id (also known as a "H.P. number")
#'
#' @param include_names A logical vector of length 1, denoting if the names of
#' municipalities (for each of the `id_types` chosen) should be included. Be aware
#' that some municipal names might differ between different agencies.
#'
#' @details
#' The table is a fixed reference of 257 local authorities, reflecting the set of
#' authorities current as of the 2024 CBS municipal file. It has no `year`
#' argument, so when joining to an earlier year a handful of more recently
#' created authorities will not match.
#'
#' Regional councils are returned with their 2-digit CBS code (e.g. `"38"`). The
#' CBS started encoding them as a 4-digit `5500 + code` (e.g. `"5538"`) in the
#' 2024 municipal file; to join to that data, recode the regional council ids
#' yourself, for example with [modify_muni_id()].
#'
#' @return A tibble, where every row is a municipality and the columns include id's
#' (and possibly names) of the municipalities from the chosen agencies.
#' @export
#'
#' @examples
#' read_muni_id() |>
#'   dplyr::glimpse()
#'
#' read_muni_id(id_types = c("muni", "edu"), include_names = TRUE) |>
#'   dplyr::glimpse()
read_muni_id <- function(
  id_types = c("muni", "edu", "tax"),
  include_names = FALSE
) {
  # Validate id_types
  if (!is.character(id_types)) {
    rlang::abort(
      "`id_types` must be a character vector.",
      class = "read_muni_id_invalid_id_types"
    )
  }

  valid_types <- c("muni", "edu", "tax")
  invalid_types <- setdiff(id_types, valid_types)
  if (length(invalid_types) > 0) {
    rlang::abort(
      c(
        "`id_types` must contain only valid type values.",
        "i" = paste0("Valid types: ", paste(valid_types, collapse = ", ")),
        "x" = paste0(
          "Invalid types provided: ",
          paste(invalid_types, collapse = ", ")
        )
      ),
      class = "read_muni_id_invalid_type_values"
    )
  }

  # Validate include_names
  if (
    !is.logical(include_names) ||
      length(include_names) != 1 ||
      is.na(include_names)
  ) {
    rlang::abort(
      "`include_names` must be a single logical value (TRUE or FALSE).",
      class = "read_muni_id_invalid_include_names"
    )
  }

  if (include_names) {
    df_muni_id |>
      dplyr::select(dplyr::contains(id_types))
  } else {
    df_muni_id |>
      dplyr::select(dplyr::contains(id_types) & dplyr::ends_with("id"))
  }
}
