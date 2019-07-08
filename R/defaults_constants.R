###
###
###
###    Purpose:   Collection Of Functions Returning Global Constants
###    started:   2019-07-08 (pvr)
###
### ################################################################### ###

## -- Default Plot Options for different traits --- ###

#' @title Default Plot Options For FBK
#'
#' @description
#' Return a list with specific defaults and constants that are used
#' to produce the plot comparison report for the trait group
#' Fruchtbarkeit (FBK).
#'
get_default_plot_opts_fbk <- function(){
  # return list of default options
  return(list(ge_dir_stem     = "/qualstorzws01/data_zws/fbk/work",
              arch_dir_stem   = "/qualstorzws01/data_archiv/zws",
              rmd_templ       = system.file("templates/compare_plots.Rmd.template", package = 'zwsroutinetools'),
              rmd_report_stem = "ge_plot_report_fbk",
              vec_breed       = c("bv", "rh"),
              vec_sex         = c("Bull", "Cow")))
}
