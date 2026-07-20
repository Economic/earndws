#' QCEW area titles
#'
#' Lookup table mapping QCEW area FIPS codes to human-readable area titles
#' (states, counties, and the U.S. total).
#'
#' @format A data frame with two columns:
#' \describe{
#'   \item{area_fips}{QCEW area FIPS code.}
#'   \item{area_title}{Human-readable area title.}
#' }
#' @source U.S. Bureau of Labor Statistics, Quarterly Census of Employment and
#'   Wages (QCEW).
"qcew_area_titles"


#' QCEW industry titles
#'
#' Lookup table mapping QCEW industry codes to human-readable industry
#' titles.
#'
#' @format A data frame with two columns:
#' \describe{
#'   \item{industry_code}{QCEW industry code.}
#'   \item{industry_title}{Human-readable industry title.}
#' }
#' @source U.S. Bureau of Labor Statistics, Quarterly Census of Employment and
#'   Wages (QCEW).
"qcew_ind_titles"
