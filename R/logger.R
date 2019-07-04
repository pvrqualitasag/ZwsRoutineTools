###
###
###
###   Purpose:   Logging and Other System Functions
###   started:   2019-07-03 (pvr)
###
### ################################################### ###

#' @title Generic Logging Function
#'
#' @description
#' This function provides the generic loggin mechanism
#' It is mostly used through level-specific wrapper functions.
#'
generic_logger <- function(ps_level, ps_caller, ps_msg){
  cat("[", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), ps_caller, ps_level, "]", ps_msg, "\n")
  return(invisible(NULL))
}

#' @title Info Level Logger
#'
#' @description
#' Produce log messages at the info level
#'
#' @export log_info
log_info <- function(ps_caller, ps_msg){
  generic_logger(ps_level = "INFO", ps_caller = ps_caller, ps_msg = ps_msg)
  return(invisible(NULL))
}
