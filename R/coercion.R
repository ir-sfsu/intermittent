## Coercion for term prototypes ##

#' @rdname vctrs-compat
#' @importFrom vctrs vec_ptype2 vec_ptype2.double
#' @method vec_ptype2 term
#' @export
#' @export vec_ptype2.term
vec_ptype2.term <- function(x, y, ...) {
  UseMethod("vec_ptype2.term", y)
}

#' @method vec_ptype2.term default
#' @export
vec_ptype2.term.default <- function(x, y, ..., x_arg = "x", y_arg = "y") {
  vctrs::vec_default_ptype2(x, y, x_arg = x_arg, y_arg = y_arg)
}

#' @method vec_ptype2.term term
#' @export
vec_ptype2.term.term <- function(x, y, ...) {
  # origin <- term_origin(y)
  # if (is_term(y)) {
  #   y <- vec_cast(y, double())
  # }
  # new_term(y, origin = origin)
  # new_term(origin = term_origin(x))
}

#' @method vec_ptype2.term double
#' @export
vec_ptype2.term.double <- function(x, y, ...) x

#' @method vec_ptype2.double term
#' @export
vec_ptype2.double.term <- function(x, y, ...) x
