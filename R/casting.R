## Casting for term ##


#' @rdname vctrs-compat
#' @importFrom vctrs vec_cast vec_proxy_compare vec_proxy_equal
#' @method vec_cast term
#' @export
#' @export vec_cast.term
vec_cast.term <- function(x, to, ...) UseMethod("vec_cast.term")

#' @method vec_cast.term default
#' @export
vec_cast.term.default <- function(x, to, ...) vctrs::vec_default_cast(x, to)

#' @importFrom vctrs vec_cast.double
#' @method vec_cast.term double
#' @export
vec_cast.term.double <- function(x, to, origin = c("sims", "cs"), ...) {
  origin <- match.arg(origin)
  term(x, origin)
}

#' @method vec_cast.term double
#' @export
vec_cast.term.term <- function(x, to, ...) x

#' @method vec_cast.term character
#' @export
vec_cast.term.character <- function(x, to, origin = c("sims", "cs"), ...) {
  origin <- match.arg(origin)
  term(x, origin)
}

#' @method vec_cast.double term
#' @export
vec_cast.double.term <- function(x, to, ...) vctrs::vec_data(x)

#' @importFrom vctrs vec_cast.character
#' @method vec_cast.character term
#' @export
vec_cast.character.term <- function(x, to, ...) as.character(vctrs::vec_data(x))
