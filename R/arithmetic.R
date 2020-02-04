#' @rdname mathematics
#' @export
median.term <- function(x) {
  to <- seq(min(x), max(x))
  lt <- length(to)
  to[ceiling(lt/2)]
}

#' @rdname mathematics
#' @export
min.term <- function(x, na.rm = FALSE, ...) {
  origin <- term_origin(x)
  dbls <- vctrs::vec_cast(x, double())
  out <- min(dbls)
  term(out, origin = origin)
}

#' @rdname mathematics
#' @export
max.term <- function(x, na.rm = FALSE, ...) {
  origin <- term_origin(x)
  dbls <- vctrs::vec_cast(x, double())
  out <- max(dbls)
  term(out, origin = origin)
}



#' @rdname vctrs-compat
#' @importFrom vctrs vec_arith
#' @method vec_arith term
#' @export
#' @export vec_arith.term
vec_arith.term <- function(op, x, y, ...) {
  UseMethod("vec_arith.term", y)
}

#' @rdname vctrs-compat
#' @method vec_arith.term default
#' @export
vec_arith.term.default <- function(op, x, y, ...) {
  vctrs::stop_incompatible_op(op, x, y)
}

#' @rdname vctrs-compat
#' @method vec_arith.term numeric
#' @export
vec_arith.term.numeric <- function(op, x, y, ...) {
  switch(
    op,
    "+" = term_plus(x, y),
    vctrs::stop_incompatible_op(op, x, y)
  )
}

#' @rdname vctrs-compat
#' @importFrom vctrs vec_arith.numeric
#' @method vec_arith.numeric term
#' @export
vec_arith.numeric.term <- function(op, x, y, ...) {
  switch(
    op,
    "+" = term_plus(y, x),
    vctrs::stop_incompatible_op(op, x, y)
  )
}

term_plus <- function(x, y, terms = getOption("termtools.use_terms")) {

  stopifnot(is_term(x))
  # stopifnot(rlang::is_double(y))
  origin <- term_origin(x)
  x_dbl <- vctrs::vec_cast(x, double())
  if (origin == "cs") x_dbl <- conv_term(x_dbl)
  term_ind <- substr(x_dbl, 5, 5)

  sui <- ifelse(terms == "all", 1, NA)
  spi <- ifelse(is.na(sui), 2, 1)
  add_inc_rep <- switch(term_ind,
                        "2" = c(sui, spi, 8),
                        "3" = c(1, 8, 1),
                        "4" = c(8, sui, spi))

  add_inc_rep <- add_inc_rep[!is.na(add_inc_rep)]
  repX <- ceiling(y / ifelse(terms == "fasp", 2, 3))
  inc_seq <- rep(add_inc_rep, repX)
  out <- as.numeric(x_dbl) + sum(inc_seq[1:y])
  if (origin == "cs") out <- conv_term(out)
  term(out, origin = origin)
}
