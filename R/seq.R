#' @export
seq.term <- function(from, to, include = getOption("intermittent.use_terms"), ...) {
  origin <- term_origin(from)
  out <- seq_terms(from, to, include, origin = origin)
  new_term(out, origin = origin)
}

#' @export
seq_terms <- function(from, to, include, origin) {
  cs_orig <- FALSE
  if (origin == "cs") {
    from <- conv_term(from, origin)
    to <- conv_term(to, origin)
    cs_orig <- TRUE
  }
  start_year <- as.numeric(substr(from, 1, 4))
  end_year <- as.numeric(substr(to, 1, 4))
  terms <- c("2", "4")
  if (include == "all") terms <- c("2", "3", "4")
  out <- purrr::flatten_chr(purrr::map(start_year:end_year, ~paste0(.x, terms)))
  if (grepl("2$", to)) {
    out <- out[-length(out)]
    if (include == "all") {
      out <- out[-length(out)]
    }
  }
  if (grepl("3$", to)) {
    out <- out[-length(out)]
  }
  if (grepl("4$", from)) {
    out <- out[-1]
    if (include == "all") {
      out <- out[-1]
    }
  }
  if (cs_orig) out <- purrr::map_chr(out, conv_term, "sims")
  out
}
