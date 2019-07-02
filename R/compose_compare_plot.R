###
###
###
###   Purpose:   Create a Rmd report with plots from two GE
###   started:   2019-07-02 (pvr)
###
### ########################################################## ###

#' Create Report With Plots From Two GE Periods
#'
#' Based on a Rmarkdown Template (ps_templ) document all plots
#' in given GE directory (ps_gedir) are taken. For a given plot
#' in directory ps_gedir, a corresponding plot with the same
#' filename is searched in an archive directory (ps_archdir).
#' If such a plot is found, the two corresponding plots are
#' shown side-by-side in the generated Rmarkdown report.
#'
#' @param ps_gedir  directory with plots of current GE round
#' @param ps_archdir  archive directory with plots from previous GE
#' @param ps_templ  path to Rmarkdown template file
#'
create_ge_plot_report <- function(ps_gedir,
                                  ps_archdir,
                                  ps_templ,
                                  ps_rmd_report = 'ge_plot_report.Rmd'){

  # ps_templ must exist
  if (!file.exists(ps_templ))
    stop("[ERROR -- create_ge_plot_report] Cannot find Rmd template: ", ps_templ)

  # rename the template into the result report
  file.rename(from = ps_templ, to = ps_rmd_report)

  # loop over the plot files in ps_gedir
  vec_plot_files_ge <- list.files(ps_gedir, pattern = "\\.png$|\\.pdf$", full.names = TRUE)
}

### # Testing stuff


create_ge_plot_report(ps_gedir = "inst/extdata/compare-plot",
                      ps_archdir = "inst/extdata/archive/compare-plot",
                      ps_templ   = "inst/templates/compare_plots.Rmd.template")
