#' Math stuff for term objects
#'
#' @importFrom stats median
#' @param x An object of class 'term'
#' @param ... Additional args passed to various functions
#' @param na.rm Logical. Should missing values be removed?
#'
#' @name mathematics
NULL

#' @rdname mathematics
#' @export
median.term <- function(x, ...) {
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
    "-" = term_minus(x, y),
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

#' @rdname vctrs-compat
#' @method vec_arith.term term
#' @export
vec_arith.term.term <- function(op, x, y, ...) {
  switch(
    op,
    # "+" = term_plus(x, y),
    "-" = term_minus_term(x, y),
    vctrs::stop_incompatible_op(op, x, y)
  )
}

term_minus_term <- function(x, y, terms = getOption("intermittent.use_terms")) {
  origins_check(x, y)
  if (length(x) > 1) {
    out <- NULL
    for (i in seq_along(x)) {
      stopifnot(x > y)
      out[i] <- length(seq(y[i], x[i], terms))
    }
  } else {
    out <- length(seq(x, y, terms))
  }
  out
}

term_plus <- function(x, y, terms = getOption("intermittent.use_terms")) {
  origin <- term_origin(x)
  out <- sapply(x, function(x) {
    as.numeric(increment_dbl(x, y, "+", terms))
  })
  names(out) <- NULL
  term(out, origin = origin)
  # increment_dbl(x, y, "+", terms)
}

term_minus <- function(x, y, terms = getOption("intermittent.use_terms")) {
  origin <- term_origin(x)
  out <- sapply(x, function(x) {
    as.numeric(increment_dbl(x, y, "-", terms))
  })
  names(out) <- NULL
  term(out, origin = origin)
  # increment_dbl(x, y, "-", terms)
}

increment_dbl <- function(x, y, op, terms) {
  stopifnot(is_term(x))
  origin <- term_origin(x)
  x_dbl <- vctrs::vec_cast(x, double())
  if (origin == "cs") x_dbl <- conv_term(x_dbl, origin)
  term_ind <- substr(x_dbl, 5, 5)
  sui <- ifelse(terms == "all", 1, NA)
  spi <- ifelse(is.na(sui), 2, 1)
  if (op == "-") {
    add_inc_rep <- switch(term_ind,
                          "2" = c(8, sui, spi),
                          "3" = c(1, 8, 1),
                          "4" = c(sui, spi, 8))
  } else {
    add_inc_rep <- switch(term_ind,
                          "2" = c(sui, spi, 8),
                          "3" = c(1, 8, 1),
                          "4" = c(8, sui, spi))
  }

  add_inc_rep <- add_inc_rep[!is.na(add_inc_rep)]
  repX <- ceiling(y / ifelse(terms == "fasp", 2, 3))
  inc_seq <- rep(add_inc_rep, repX)
  if (op == "-") {
    out <- as.numeric(x_dbl) - sum(inc_seq[1:y])
  } else {
    out <- as.numeric(x_dbl) + sum(inc_seq[1:y])
  }
  if (origin == "cs") out <- conv_term(out, "sims")
  term(out, origin = origin)
}
