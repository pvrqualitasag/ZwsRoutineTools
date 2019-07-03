###
###
###
###   Purpose:   Create a Rmd report with plots from two GE
###   started:   2019-07-02 (pvr)
###
### ########################################################## ###

## -- Generic Comparison Plot Creator Function

#' @title Create Report With Plots From Two GE Periods
#'
#' @description
#' Based on a Rmarkdown Template (ps_templ) document all plots
#' in given GE directory (ps_gedir) are taken. For a given plot
#' in directory ps_gedir, a corresponding plot with the same
#' filename is searched in an archive directory (ps_archdir).
#' If such a plot is found, the two corresponding plots are
#' shown side-by-side in the generated Rmarkdown report.
#'
#' @param ps_gedir  directory with plots of current GE round
#' @param ps_archdir  archive directory with plots from previous GE
#' @param pstrgdir    target directory where plot files from archive are extracted, relative to ps_gedir
#' @param ps_templ  path to Rmarkdown template file
#' @param ps_report_text text that is included in the report before plotting
#' @param ps_rmd_report name of report source file
#' @param pb_debug flag indicating whether debug info is printed
#'
#' @examples
#' \dontrun{
#' create_ge_plot_report(ps_gedir       = "/Volumes/data_zws/fbk/work/bv/YearMinus0/compareBull",
#'                     ps_archdir     = "/Volumes/data_archiv/zws/1904/fbk/work/bv/YearMinus0/compareBull",
#'                     ps_trgdir      = "1904/compareBull",
#'                     ps_templ       = "inst/templates/compare_plots.Rmd.template",
#'                     ps_report_text = "## Comparison Of Plots\nPlots compare estimates of fbk for bulls of breed BV between GE-1904 on the left and the current GE-1908 on the right.",
#'                     ps_rmd_report  = 'ge_plot_report_fbk_compareBulls_bv.Rmd',
#'                     pb_debug       = TRUE)
#'
#' }
#' @export create_ge_plot_report
create_ge_plot_report <- function(ps_gedir,
                                  ps_archdir,
                                  ps_trgdir,
                                  ps_templ,
                                  ps_report_text,
                                  ps_rmd_report = 'ge_plot_report.Rmd',
                                  pb_debug      = FALSE){

  if (pb_debug) cat(" * Starting create_ge_plot_report ... \n")

  # ps_gedir and ps_archdir must esits
  if (!dir.exists(ps_gedir))
    stop("[ERROR -- create_ge_plot_report] Cannot find plot directory: ", ps_gedir, "\n")

  if (!dir.exists(ps_archdir))
    stop("[ERROR -- create_ge_plot_report] Cannot find archive directory: ", ps_archdir, "\n")

  # ps_templ must exist
  if (!file.exists(ps_templ))
    stop("[ERROR -- create_ge_plot_report] Cannot find Rmd template: ", ps_templ, "\n")

  # target directory should be relative to ps_gedir
  if (fs::is_absolute_path(path = ps_trgdir))
    stop("[ERROR -- create_ge_plot_report] Target directory: ", ps_trgdir, " must be relative to ps_gedir: ", ps_gedir, "\n")
  # append ps_trgdir to ps_gedir
  s_trgdir <- file.path(ps_gedir, ps_trgdir)
  if (pb_debug) cat(" * Absolute target directory: ", s_trgdir, "\n")

  # get the root subdirectory in ps_gedir where ps_trgdir is added
  s_trgroot <- file.path(ps_gedir, fs::path_split(ps_trgdir)[[1]][1])
  if (pb_debug) cat(" * Target root directory: ", s_trgroot, "\n")

  # if the ps_trgdir does not exist, create it
  if (!dir.exists(s_trgdir)) {
    if (pb_debug) cat(" * Create target directory: ",s_trgdir, "\n")
    dir.create(path = s_trgdir, recursive = TRUE)
  }

  # if target directory could not be created, stop here
  if (!dir.exists(s_trgdir))
    stop("[ERROR -- create_ge_plot_report] Cannot create target directory: ", s_trgdir, "\n")

  # rename the template into the result report
  file.copy(from = ps_templ, to = ps_rmd_report)

  # add the report text to the report
  cat(ps_report_text, "\n\n", file = ps_rmd_report, append = TRUE)

  # extract plot files from current ps_gedir
  vec_plot_files_ge <- list.files(ps_gedir, pattern = "\\.png$|\\.pdf$", full.names = TRUE)
  if (pb_debug){
    cat("Plot files in ", ps_gedir, "\n")
    print(vec_plot_files_ge)
  }
  # loop over plot files and get corresponding plot file from previous ge, if it exists
  for (f in vec_plot_files_ge){
    if (pb_debug) cat(" * Plot file: ", f, "\n")
    # write the chunk start into the report file
    cat("\n```{r, echo=FALSE, fig.show='hold', out.width='50%'}\n", file = ps_rmd_report, append = TRUE)
    # check whether corresponding plot file existed in archive
    bnf <- basename(f)
    bnfgz <- paste(bnf, "gz", sep = ".")
    bnfgzpath <- file.path(ps_archdir, bnfgz)
    if (file.exists(bnfgzpath)){
      if (pb_debug) cat(" * Found archived plot file: ", bnfgz, " in ", ps_archdir, "\n")
      # copy file from archive
      if (pb_debug) cat(" * Copy from: ", bnfgzpath, " to ", s_trgdir, "\n")
      file.copy(from = bnfgzpath, to = s_trgdir)
      bnfgztrgpath <- file.path(s_trgdir, bnfgz)
      bnftrgpath <- file.path(s_trgdir, bnf)
      if (!file.exists(bnftrgpath)){
        if (pb_debug) cat(" * Unzip: ", bnfgztrgpath, "\n")
        R.utils::gunzip(bnfgztrgpath)
      } else {
        if (pb_debug) cat(" * File: ", bnftrgpath, " already exists", "\n")
      }
      ### # Include extracted file into the report
      cat(paste0("knitr::include_graphics(path = '", bnftrgpath, "')\n", collapse = ""), file = ps_rmd_report, append = TRUE)
    } else {
      if (pb_debug) cat(" * Cannot find archived plot file: ", bnfgz, " in ", ps_archdir, "\n")
    }
    # include current plot file into report
    cat(paste0("knitr::include_graphics(path = '", f, "')\n", collapse = ""), file = ps_rmd_report, append = TRUE)
    # write junk end into report
    cat("```\n\n", file = ps_rmd_report, append = TRUE)
  }
  # finally include session info into the report
  cat("\n```{r}\n sessioninfo::session_info()\n```\n\n", file = ps_rmd_report, append = TRUE)
  # render the generated Rmd file
  rmarkdown::render(input = ps_rmd_report)
  # move pdf of report to ps_ge_dir
  s_pdf_report <- fs::path_ext_set(fs::path_ext_remove(ps_rmd_report), "pdf")
  if (pb_debug) cat(" * Moving report ", s_pdf_report, " to: ", ps_gedir, "\n")
  fs::file_move(s_pdf_report, ps_gedir)
  # remove report source
  if (pb_debug) cat(" * Removing report rmd source ", ps_rmd_report, " to: ", ps_gedir, "\n")
  fs::file_delete(ps_rmd_report)

  # remove target root dir
  if (pb_debug) cat(" * Delete target root directory: ", s_trgroot, "\n")
  fs::dir_delete(path = s_trgroot)

  if (pb_debug) cat(" * End of create_ge_plot_report\n")

  # return nothing
  return(invisible(NULL))
}


## -- Creator Function for FBK --- -------------------------------------- ##

#' @title Comparison Plot Creator Function For FBK
#'
#' @description
#' Comparison reports containing all generated plots of a GE side-by-side
#' with the plots of the previous GE are constructed for a given trait
#' group.
#'
#' @param pl_plot_opts list of options specifying input for plot report creator
#' @examples
#' \dontrun{
#' create_ge_compare_plot_report_fbk(pn_cur_ge_label  = 1908,
#'                                   pn_prev_ge_label = 1904)
#' }
#'
#' @export create_ge_compare_plot_report_fbk
create_ge_compare_plot_report_fbk <- function(pn_cur_ge_label,
                                              pn_prev_ge_label,
                                              pl_plot_opts = NULL){

  # if no options are specified, we have to get the default options
  l_plot_opts <- pl_plot_opts
  if (is.null(l_plot_opts)){
    l_plot_opts <- get_default_plot_opts_fbk()
  }

}


## -- Default Plot Options for different traits --- ###

#' @title Default Plot Options For FBK
#'
#' @description
#'
get_default_plot_opts_fbk <- function(){
  # return list of default options
  return(list(ge_dir_stem     = "/qualstorzws01/data_zws/fbk/work",
              arch_dir_stem   = "/qualstorzws01/data_archiv/zws",
              rmd_templ       = "inst/templates/compare_plots.Rmd.template",
              rmd_report_stem = "ge_plot_report_fbk"))
}


### # Testing stuff

# local test call
# create_ge_plot_report(ps_gedir = "inst/extdata/compare-plot",
#                       ps_archdir = "inst/extdata/archive/compare-plot",
#                       ps_templ   = "inst/templates/compare_plots.Rmd.template")
#
# create_ge_plot_report(ps_gedir       = "/Volumes/data_zws/fbk/work/bv/YearMinus0/compareBull",
#                       ps_archdir     = "/Volumes/data_archiv/zws/1904/fbk/work/bv/YearMinus0/compareBull",
#                       ps_trgdir      = "1904/compareBull",
#                       ps_templ       = "inst/templates/compare_plots.Rmd.template",
#                       ps_report_text = "## Comparison Of Plots\nPlots compare estimates of fbk for bulls of breed BV between GE-1904 on the left and the current GE-1908 on the right.",
#                       ps_rmd_report  = 'ge_plot_report_fbk_compareBulls_bv.Rmd',
#                       pb_debug       = TRUE)
#
# create_ge_plot_report(ps_gedir       = "/Volumes/data_zws/fbk/work/bv/YearMinus0/compareCow",
#                       ps_archdir     = "/Volumes/data_archiv/zws/1904/fbk/work/bv/YearMinus0/compareCow",
#                       ps_trgdir      = "1904/compareCow",
#                       ps_templ       = "inst/templates/compare_plots.Rmd.template",
#                       ps_report_text = "## Comparison Of Plots\nPlots compare estimates of fbk for cows of breed BV between GE-1904 on the left and the current GE-1908 on the right.",
#                       ps_rmd_report  = 'ge_plot_report_fbk_compareCow_bv.Rmd',
#                       pb_debug       = TRUE)

# create_ge_plot_report(ps_gedir       = "/Volumes/data_zws/fbk/work/rh/YearMinus0/compareBull",
#                       ps_archdir     = "/Volumes/data_archiv/zws/1904/fbk/work/rh/YearMinus0/compareBull",
#                       ps_trgdir      = "1904/compareBull",
#                       ps_templ       = "inst/templates/compare_plots.Rmd.template",
#                       ps_report_text = "## Comparison Of Plots\nPlots compare estimates of fbk for bulls of breed RH between GE-1904 on the left and the current GE-1908 on the right.",
#                       ps_rmd_report  = 'ge_plot_report_fbk_compareBulls_rh.Rmd',
#                       pb_debug       = TRUE)

# create_ge_plot_report(ps_gedir       = "/Volumes/data_zws/fbk/work/rh/YearMinus0/compareCow",
#                       ps_archdir     = "/Volumes/data_archiv/zws/1904/fbk/work/rh/YearMinus0/compareCow",
#                       ps_trgdir      = "1904/compareCow",
#                       ps_templ       = "inst/templates/compare_plots.Rmd.template",
#                       ps_report_text = "## Comparison Of Plots\nPlots compare estimates of fbk for cows of breed RH between GE-1904 on the left and the current GE-1908 on the right.",
#                       ps_rmd_report  = 'ge_plot_report_fbk_compareCow_rh.Rmd',
#                       pb_debug       = TRUE)



