.onLoad <- function(libname, pkgname) {
  op <- options()
  op.intermittent <- list(
    intermittent.use_terms = "fasp" # fall and spring terms
  )
  toset <- !(names(op.intermittent) %in% names(op))
  if(any(toset)) options(op.intermittent[toset])
  invisible()
}
