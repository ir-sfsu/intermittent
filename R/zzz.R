.onLoad <- function(libname, pkgname) {
  op <- options()
  op.termtools <- list(
    termtools.use_terms = "fasp" # fall and spring terms
  )
  toset <- !(names(op.termtools) %in% names(op))
  if(any(toset)) options(op.termtools[toset])
  invisible()
}
