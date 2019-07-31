###
###
###
###   Purpose:   Helper Functions
###   started:   2019-07-31 (pvr)
###
### ############################################################### ###

#' @title Substitution Of Text-Markers With Replacement Values In Report Text
#'
#' @description
#' Given a report text with placeholders and a list of placeholderpattern-
#' replacement-value pairs, the function loops through the list and replaces the
#' placeholders by the replacement values. The single elements of the replacement
#' list must be a list again with two elements having names 'pattern' and
#' 'replacement' where the former contains the placeholder pattern and the latter
#' contains the replacement value.
#'
replace_plh <- function(ps_report_text, pl_replacement, pb_debug = FALSE){
  # initialise the result text
  s_result_text <- ps_report_text
  # loop over the entries in pl_replacement
  for (i in seq_along(pl_replacement)){
    if (pb_debug) log_info(ps_caller = "replace_plh", ps_msg = paste0("Replacing ", pl_replacement[i][[1]]$pattern, " with ",  pl_replacement[i][[1]]$replacement))
    s_result_text <- gsub(pattern = pl_replacement[i][[1]]$pattern,
                          replacement = pl_replacement[i][[1]]$replacement,
                          s_result_text,
                          fixed = TRUE)
  }
  return(s_result_text)
}
