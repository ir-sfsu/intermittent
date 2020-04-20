#' @export
conv_term <- function(x, origin) {
  # origin <- term_origin(x)
  nc <- nchar(x)
  # stopifnot(nc %in% 4:5)
  bits <- strsplit(as.character(x), "")[[1]]
  if (origin == "cs") {
    bits[4] <- switch(bits[4],
                      "3" = "2",
                      "5" = "3",
                      "7" = "4")
    return(paste0("20", paste0(bits[2:4], collapse = "")))
  }
  bits[5] <- switch(bits[5],
                    "2" = "3",
                    "3" = "5",
                    "4" = "7")
  paste0("2", paste0(bits[3:5], collapse = ""))
}

#' Get the academic year of a term
#'
#' @param x An object of class 'term'
#'
#' @return Character
#' @export
acad_year <- function(x) {
  stopifnot(is_term(x))
  origin <- term_origin(x)
  x <- vctrs::vec_cast(x, character())

  if (origin == "sims") {
    term <- substr(x, 5, 5)
    y <- as.numeric(substr(x, 1, 4))
    ay <- purrr::map2_chr(term, y, ~{
      if (.x == "2") {
        y1 <- .y - 1
        y2 <- substr(.y, 3, 4)
        out <- paste0(y1, "-", y2)
      } else {
        y2 <- .y + 1
        y2s <- substr(y2, 3, 4)
        out <- paste0(.y, "-", y2s)
      }
      out
    })

  } else {
    term <- substr(x, 4, 4)
    y <- as.numeric(substr(x, 2, 3))
    ay <- purrr::map2_chr(term, y, ~{
      if (.x == "3") {
        y1 <- .y - 1
        y1 <- paste0("20", y1)
        out <- paste0(y1, "-", .y)
      } else {
        y2 <- .y + 1
        out <- paste0("20", .y, "-", y2)
      }
      out
    })
  }
  ay
}

#' Get the calendar year of a term
#'
#' @param x An object of class 'term'
#'
#' @return Numeric
#' @export
cal_year <- function(x) {
  stopifnot(is_term(x))
  origin <- term_origin(x)
  if (origin == "sims") out <- substr(x, 1, 4)
  else {
    xchar <- vctrs::vec_cast(x, character())
    bits <- strsplit(xchar, "")
    out <- lapply(bits, function(x) paste0(x[1], 0, x[2], x[3]))
  }
  as.numeric(as.numeric(out))
}

#' Label a term object
#'
#' @param x An object of class 'term'
#'
#' @return Character, e.g. "Fall 2018"
#' @export
#'
#' @examples
#' label_term(term(20194))
label_term <- function(x) {
  if (length(x) > 1) {
    out <- sapply(x, format_term)
  } else {
    out <- format_term(x)
  }
  names(out) <- NULL
  out
}

format_term <- function(x) {
  stopifnot(is_term(x))
  origin <- term_origin(x)
  if (origin == "cs") x <- conv_term(x, "cs")
  char_term <- as.character(x)
  term <- substr(char_term, 5, 5)
  year <- substr(char_term, 1, 4)
  term <- switch(term,
                 # `1` = "Winter",
                 `2` = "Spring",
                 `3` = "Summer",
                 `4` = "Fall")
  paste(term, year)
}

# current_term <- function(origin = "cs") {
#   ops <- getOption("intermittent.use_terms")
#   bits <- as.numeric(strsplit(as.character(Sys.Date()), "-")[[1]][1:2])
#   y <- bits[1]
#   m <- bits[2]
#   ## TODO ##
#   ## Maybe
# }

#' Get the number of terms in between two terms
#'
#' @param x a term object
#' @param y a term object
#'
#' @return integer
#' @export
#'
#' @examples
#' x <- term(20104)
#' y <- term(20144)
#' term_duration(x, y)
#' term_duration(y, x)
term_duration <- function(x, y) {
  ifelse(x > y, x - y, y - x)
}
