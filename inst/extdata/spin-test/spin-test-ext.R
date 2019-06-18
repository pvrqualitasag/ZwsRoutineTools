#' ---
#' title: A Documented Bash Script
#' author: Peter von Rohr
#' date: 2019-06-18
#' ---
#'
#' This is an example of a documented bash script.
#+ setup, include=FALSE
knitr::opts_chunk$set(collapse = TRUE)

#' The report begins here.

#+ test-a, cache=FALSE
# boring examples as usual
set.seed(123)
n_nr_obs <- 5
x = rnorm(n_nr_obs)
mean(x)

#+ test-b, fig.width=5, fig.height=5
par(mar = c(4, 4, .1, .1)); plot(x)

#' Actually you do not have to write chunk options, in which case knitr will use
#' default options. For example, the code below has no options attached:

var(x)
quantile(x)


#' ## Regression Data
#' From the $x$-values, we generate some $y$ using a fixed slope
b <- rnorm(1)
intercept <- rnorm(1)
y <- intercept + b * x + rnorm(n_nr_obs)
#' 
#' Generate a plot to verify
plot(x,y)

#' ## Bash chunks
#' The following section aims at executing a bash chunk
#' ```{bash}
#' echo 'Hello Bash'
#' ```
#' 
#' This is the line after the bash command.
