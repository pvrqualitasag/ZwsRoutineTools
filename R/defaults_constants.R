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


## -- Defaults for ND

#' @title Default Plot Options For ND
#'
#' @description
#' Return a list with specific defaults and constants that are used
#' to produce the comparison plot report for the trait group
#' Nutzungsdauer (ND).
#'
get_default_plot_opts_nd <- function(){
  # return list of default options
  return(list(ge_dir_stem     = "/qualstorzws01/data_zws/nd/work",
              arch_dir_stem   = "/qualstorzws01/data_archiv/zws",
              rmd_templ       = system.file("templates/compare_plots.Rmd.template", package = 'zwsroutinetools'),
              rmd_report_stem = "ge_plot_report_nd",
              vec_breed       = c("bv", "rh")))
}


## -- Defaults for MAR

#' @title Default Plot Options For MAR
#'
#' @description
#' Return a list with specific defaults and constants that are used
#' to produce the comparison plot report for the trait group
#' Mastitisresistenz (MAR).
#'
get_default_plot_opts_mar <- function(){
  # return list of default options
  return(list(ge_dir_stem     = "/qualstorzws01/data_zws/health/mar/work",
              arch_dir_stem   = "/qualstorzws01/data_archiv/zws",
              rmd_templ       = system.file("templates/compare_plots.Rmd.template", package = 'zwsroutinetools'),
              rmd_report_stem = "ge_plot_report_mar",
              vec_breed       = c("bv", "rh"),
              vec_sex         = c("Bull", "Cow")))
}


## -- Defaults for LBE

#' @title Default Plot Options For LBE
#'
#' @description
#' Return a list with specific defaults and constants that are used
#' to produce the comparison plot report for the trait group
#' Lineare Beschreibung (LBE).
#'
get_default_plot_opts_lbe <- function(){
  # return list of default options
  return(list(ge_dir_stem     = "/qualstorzws01/data_zws/lbe/work",
              arch_dir_stem   = "/qualstorzws01/data_archiv/zws",
              rmd_templ       = system.file("templates/compare_plots.Rmd.template", package = 'zwsroutinetools'),
              rmd_report_stem = "ge_plot_report_lbe",
              vec_breed       = c("bv", "je"),
              vec_sex         = c("Bull", "Cow")))
}


## -- Defaults for LBE_RH

#' @title Default Plot Options For LBE_RH
#'
#' @description
#' Return a list with specific defaults and constants that are used
#' to produce the comparison plot report for the trait group
#' Lineare Beschreibung for RH (LBE_RH).
#'
get_default_plot_opts_lbe_rh <- function(){
  # return list of default options
  return(list(ge_dir_stem     = "/qualstorzws01/data_zws/lbe_rh/work",
              arch_dir_stem   = "/qualstorzws01/data_archiv/zws",
              rmd_templ       = system.file("templates/compare_plots.Rmd.template", package = 'zwsroutinetools'),
              rmd_report_stem = "ge_plot_report_lbe_rh",
              vec_breed       = c("rh"),
              vec_sex         = c("Bull", "Cow")))
}


## -- Defaults for PROD

#' @title Default Plot Options For PROD
#'
#' @description
#' Return a list with specific defaults and constants that are used
#' to produce the comparison plot report for the trait group
#' Production (PROD).
#'
get_default_plot_opts_prod <- function(){
  # return list of default options
  return(list(ge_dir_stem     = "/qualstorzws01/data_zws/prod/work",
              arch_dir_stem   = "/qualstorzws01/data_archiv/zws",
              rmd_templ       = system.file("templates/compare_plots.Rmd.template", package = 'zwsroutinetools'),
              rmd_report_stem = "ge_plot_report_prod",
              vec_breed       = c("bv", "je", "rh"),
              vec_sex         = c("Bull", "Cow")))
}


## -- Defaults for VRDGGOZW

#' @title Default Plot Options For VRDGGOZW
#'
#' @description
#' Return a list with specific defaults and constants that are used
#' to produce the comparison plot report for the trait group
#' Lineare Beschreibung (VRDGGOZW).
#'
get_default_plot_opts_vrdggozw <- function(){
  # return list of default options
  return(list(ge_dir_stem     = "/qualstorzws01/data_projekte/projekte/calcVRDGGOZW/result",
              arch_dir_stem   = "/qualstorzws01/data_archiv/zws",
              rmd_templ       = system.file("templates/compare_plots.Rmd.template", package = 'zwsroutinetools'),
              rmd_report_stem = "ge_plot_report_vrdggozw",
              vec_breed       = c("bv", "ob", "rh", "sf", "si"),
              vec_zw_type     = c("VRZW", "DGZW", "GOZW")))
}


