#' Clean a string from characters unwanted in (mostly) yishuv names
#'
#' @param name a character vector
#'
#' @return a character vector without leading and trailing white space, and with
#' characters that are only letters and digits, excluding the following: `'-()"`
#' @export
#'
#' @examples
#' clean_name("test-123_test*456")
#' clean_name("אילון תבור*")
#' clean_name("ג'סר א-זרקא")
clean_name <- function(name) {
  stopifnot(is.character(name))
  name |>
    stringr::str_remove_all("[[:punct:][:symbol:]&&[^'\\-()\"]]") |>
    stringr::str_squish()
}
