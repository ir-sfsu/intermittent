#' @rdname vctrs-compat
#' @method vec_proxy_compare term
#' @export
#' @export vec_proxy_compare.term
vec_proxy_compare.term <- function(x, ...) {
  vctrs::vec_cast(x, double()) / vctrs::vec_cast(x, double())
}


#' @rdname vctrs-compat
#' @method vec_proxy_equal term
#' @export
#' @export vec_proxy_equal.term
vec_proxy_equal.term <- function(x, ...) {
  vctrs::vec_cast(x, double())
}
