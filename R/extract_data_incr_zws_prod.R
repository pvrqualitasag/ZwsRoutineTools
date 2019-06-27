#' ---
#' title: Extract Data Increments From TDhash.log.YYMM.AR
#' date: 2019-06-26
#' author: Peter von Rohr
#' ---
#'
#' # Background
#' According to the guidlines under https://qualitasag.atlassian.net/wiki/spaces/ZWS/pages/223903750/Anleitung+ZWS+Milch
#' it is important that data increments are checked as early as possible. The resulting numbers are to be extracted from
#' a log file and results must be written to an xlsx workbook.
#'
#' # Experiments And First Implementation
#' Initially, we provide a scripts that contains a few experiments. Later, a more sophisticated solution usable in a
#' package will follow
#'
#' ## Workbook of Results
#' First, we define the path to the xlsx workbook where the results should be stored. Inside of this workbook,
#' a special sheet (sheet number 2) with just the numbers extracted from the logfiles was created. This is read and
#' the new numbers will be added.
s_data_incr_xlsx_path <- "/Volumes/data_zws/prod/work/je/n_record_RRTDM.xlsx"
wb_data_incr <- openxlsx::loadWorkbook(file = s_data_incr_xlsx_path)
df_data_incr <- openxlsx::read.xlsx(wb_data_incr,
                                    sheet = 2)

#' Checking the dimensions of the read data.frame:
dim(df_data_incr)


#' ## Logfile
#' In a second step, the TDhash.log file is read and numbers are extracted
s_tdhashlog_path <- ""
