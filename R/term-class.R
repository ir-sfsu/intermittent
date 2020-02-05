## Define term class ##

# The term class must have an 'origin', either 'cs' or 'sims'

# 1. Constructor ----------------------------------------------------------

#' Internal constructor to create term type
#' Can be cast from either character or double
#' @keywords internal

new_term <- function(x, origin = "sims") {
  # stopifnot(vctrs::vec_is(x, character()) | vctrs::vec_is(x, double()) | vctrs::vec_is(x, term()))
  x_len <- nchar(x)
  # origin <- match.arg(origin)
  if (origin == "cs" & all(x_len != 4)) {
    stop("Terms w/'cs' origin are 4 digits, e.g. '2123'")
  }
  if (origin == "sims" & all(x_len != 5)) {
    stop("Terms w/'sims' origin are 5 digits, e.g. '20144'")
  }
  vctrs::new_vctr(x, origin = origin, class = "term")
  # attr(out, "acad_year") <- acad_year(out)
  # attr(out, "cal_year") <- cal_year(out)
  # return(out)
}

# 2. Helper ---------------------------------------------------------------

#' A class for SIS terms
#'
#' @param x A character or double vector
#' @param origin either 'cs' or 'sims'
#' @export
term <- function(x, origin = c("sims", "cs")) {
  origin <- match.arg(origin)
  new_term(x, origin)
}

# 3. Formally declare S3 class --------------------------------------------

#' @importFrom methods setOldClass
setOldClass(c("term", "vctrs_vctr"))

#' Get term origin
#'
#' @param x a term object
#'
#' @export
term_origin <- function(x) {
  stopifnot(is_term(x))
  attr(x, "origin")
}

#' Test if an object is of class 'term'
#'
#' @param x An object
#'
#' @export
is_term <- function(x) {inherits(x, "term")}


#' Cast an object to term
#'
#' @param x An object
#' @param origin Either 'cs' or 'sims'
#'
#' @return An object of class 'term'
#' @export
as_term <- function(x, origin = c("sims", "cs")) {
  origin <- match.arg(origin)
  new_term(x, origin = origin)
}

#' @export
format.term <- function(x, ...) {
  origin <- term_origin(x)
  digits <- ifelse(origin == "cs", 4, 5)
  out <- formatC(vctrs::vec_data(x), digits = digits)
  out
}

vec_ptype_abbr.term <- function(x, ...) {
  origin <- term_origin(x)
  paste0("term (", origin, ")")
}

