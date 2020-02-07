## Checks ##

#' @export
origins_check <- function(x, y) {
  if (!identical(term_origin(x), term_origin(y))) {
    stop(call. = FALSE, "terms must share origins.")
  }
}
