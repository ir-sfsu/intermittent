
<!-- README.md is generated from README.Rmd. Please edit that file -->

# intermittent

<!-- badges: start -->

![](https://camo.githubusercontent.com/ea6e0ff99602c3563e3dd684abf60b30edceaeef/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c6966656379636c652d6578706572696d656e74616c2d6f72616e67652e737667)
<!-- badges: end -->

The goal of intermittent is to assist IR analysts with ‘term’ data
formats originating in various student information systems (SIS).
Currently, two origins are supported: SIMS and Campus Solutions.

## Installation

You can install intermittent from GitHub with:

``` r
remotes::install_github("daranzolin/intermittent")
```

## The ‘term’ class

Create a term object with `term` and indicate an origin.

``` r
library(intermittent)
getOption("intermittent.use_terms")
#> [1] "fasp"
x <- term(2123, origin = "cs")
x
#> <term[1]>
#> [1]  2123
attributes(x)
#> $origin
#> [1] "cs"
#> 
#> $class
#> [1] "term"       "vctrs_vctr"
```

R ‘understands’ term 2123 to be equivilent of ‘Spring 2012’.

``` r
### Increment the term
x + 1 # To Summer 2012
#> <term[1]>
#> [1] 2127
x + 2 # To Fall 2012
#> <term[1]>
#> [1] 2133
x + 5 # To Fall 2014
#> <term[1]>
#> [1] 2147

x - 1 # To Fall 2011
#> <term[1]>
#> [1] 2117
x - 3 # To Fall 2010
#> <term[1]>
#> [1] 2107

### Comparison
y <- term(2133, "cs")
x < y 
#> Error: Can't cast `x` <term> to `to` <term>.
```

Get the academic or calendar year for any term object.

``` r
acad_year(x)
#> [1] "2011-12"
cal_year(x)
#> [1] 2012
```

Create a sequence of terms with a `seq` method.

``` r
# Fall 2010 to Spring 2016 with a "sims" origin
sims_terms <- seq(term(20104), 20162)
sims_terms
#> <term[12]>
#>  [1] 20104 20112 20114 20122 20124 20132 20134 20142 20144 20152 20154
#> [12] 20162

min(sims_terms)
#> <term[1]>
#> [1] 20104
max(sims_terms)
#> <term[1]>
#> [1] 20162
median(sims_terms) # Retrieve the 'middle' term
#> <term[1]>
#> [1] 20132
```

Use with packages like `dplyr`.

``` r
library(dplyr)
#> Warning: package 'dplyr' was built under R version 3.6.1
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(tibble)

tibble(term = c(2123, 2127, 2133, 2137)) %>% 
  mutate(
    term = as_term(term, "cs"),
    year = cal_year(term),
    ay = acad_year(term)
  ) %>% 
  rowwise() %>% 
  mutate(next_term = as.numeric(term + 1)) %>% # rowwise() and as.numeric() to avoid annoying warnings
  ungroup() %>% 
  mutate(next_term = as_term(next_term, "cs"))
#> # A tibble: 4 x 4
#>     term  year ay      next_term
#>   <term> <dbl> <chr>   <term>   
#> 1   2123  2012 2011-12 2127     
#> 2   2127  2012 2012-13 2133     
#> 3   2133  2013 2012-13 2137     
#> 4   2137  2013 2013-14 2143
```
