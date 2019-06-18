#' ---
#' title: A Documented Bash Script
#' author: Peter von Rohr
#' date: 2019-06-18
#' ---
#'
#' ## Disclaimer
#' This is an experiment of a literate bash script. It contains R code chunks and bash commands.
#'
#+ data-gen
set.seed(123)
n_nr_obs <- 5
x = rnorm(n_nr_obs)
mean(x)
b <- rnorm(1)
intercept <- rnorm(1)
y <- intercept + b * x + rnorm(n_nr_obs)
readr::write_csv2(tibble::tibble(x=x,y=y), path = "data.csv")
#'
#' ## Bash Chunks
#' Because we will mostly be using bash commands to run files and we want to document them, we insert them here. 
#' The first chunk shows the input of the data file.
#'
#' ```{bash}
#'cat data.csv
#' ```
#'
#' In a second junk, we count the number of lines of the data file.
#'
#' ```{bash}
#'wc -l data.csv
#' ```
#' 
#' This is the end of our experimental script.


