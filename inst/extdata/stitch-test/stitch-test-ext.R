## title: Extended Version of test script for the function stitch()
## author: Peter von Rohr
#'
#' This is a test script for experiments of extending the documentation capabilities of the stiching function.
#' 
#' In what follows a few random numbers are generated.
set.seed(1121)
(x = rnorm(20))

#' descriptive statistics are computed.
mean(x);var(x)

#' A few plots are generated.
boxplot(x)
hist(x, main = '')