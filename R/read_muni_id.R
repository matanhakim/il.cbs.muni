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
#' municipalites (for each of the `id_types` chosen) should be included. Be aware
#' that some munipilati names might differ between different agencies.
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
read_muni_id <- function(id_types = c("muni", "edu", "tax"), include_names = FALSE) {

  if (include_names) {
    df_muni_id |>
      dplyr::select(dplyr::contains(id_types))
  } else {
    df_muni_id |>
      dplyr::select(dplyr::contains(id_types) & dplyr::ends_with("id"))
  }
}
