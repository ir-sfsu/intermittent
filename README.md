
<!-- README.md is generated from README.Rmd. Please edit that file -->

# intermittent

<!-- badges: start -->

![](https://camo.githubusercontent.com/ea6e0ff99602c3563e3dd684abf60b30edceaeef/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c6966656379636c652d6578706572696d656e74616c2d6f72616e67652e737667)
<!-- badges: end -->

The goal of intermittent is to assist IR analysts with ‘term’ data
formats originating in various student information systems (SIS).
Currently, two origins are supported: SIMS and Campus Solutions.

intermittent is built [with vctrs, a package that makes it easy to
create S3 vectors.](https://github.com/r-lib/vctrs)

|  Sims |   CS | Label       |
| ----: | ---: | :---------- |
| 20124 | 2127 | Fall 2012   |
| 20132 | 2133 | Spring 2013 |
| 20133 | 2135 | Summer 2013 |
| 20134 | 2137 | Fall 2013   |

## Installation

You can install intermittent from GitHub with:

``` r
remotes::install_github("daranzolin/intermittent")
```

## The ‘term’ class

Create a term object with `term` and indicate an origin.

``` r
library(intermittent)
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

## Arithmetic

R ‘understands’ term 2123 to be equivilent of ‘Spring 2012’.

``` r
### Increment the term
x + 1 # To Fall 2012
#> <term[1]>
#> [1]  2127
x + 2 # To Spring 2013
#> <term[1]>
#> [1]  2133
x + 5 # To Fall 2014
#> <term[1]>
#> [1]  2147

x - 1 # To Fall 2011
#> <term[1]>
#> [1]  2117
x - 3 # To Fall 2010
#> <term[1]>
#> [1]  2107

### Comparison
y <- term(2133, "cs")
x < y 
#> [1] TRUE
```

Subtract a term from a term to count the terms in-between. This is
useful when counting the number of terms to graduation.

``` r
grad_term <- term(20182, "sims") # Spring 2018
matric_term <- term(20144, "sims") # Fall 2014
grad_term - matric_term 
#> [1] 10
```

## Helpers

Get the label, academic year, or calendar year for any term object.

``` r
label_term(x)
#> [1] "Spring 2012"
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
#> [1]  20104
max(sims_terms)
#> <term[1]>
#> [1]  20162
median(sims_terms) # Retrieve the 'middle' term
#> <term[1]>
#> [1] 20132
```

Use with packages like `dplyr`.

``` r
library(dplyr)
library(tibble)

tibble(term = c(2123, 2127, 2133, 2137)) %>% 
  mutate(
    term = as_term(term, "cs"),
    term_label = label_term(term),
    next_term = term + 1,
    year = cal_year(term),
    academic_year = acad_year(term)
  )
#> # A tibble: 4 x 5
#>          term term_label    next_term  year academic_year
#>   <term (cs)> <chr>       <term (cs)> <dbl> <chr>        
#> 1        2123 Spring 2012        2127  2012 2011-12      
#> 2        2127 Fall 2012          2133  2012 2012-13      
#> 3        2133 Spring 2013        2137  2013 2012-13      
#> 4        2137 Fall 2013          2143  2013 2013-14
```

## Package Options - Include Summer Terms?

You may have noticed that the default sequencing, addition, and
subtraction do not account for Summer terms. To change this behavior,
change the package options:

``` r
getOption("intermittent.use_terms")
#> [1] "fasp"
seq(term(2127, "cs"), 2173)
#> <term[10]>
#>  [1] 2127 2133 2137 2143 2147 2153 2157 2163 2167 2173

options(intermittent.use_terms = "all")
seq(term(2127, "cs"), 2173)
#> <term[14]>
#>  [1] 2127 2133 2135 2137 2143 2145 2147 2153 2155 2157 2163 2165 2167 2173
```

## Future work

  - Other SIS origins?
  - Other methods?
  - Tests
