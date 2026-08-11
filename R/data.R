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


#' QCEW raw data cache (NAICS 518, 2024-2025)
#'
#' A cached copy of the raw QCEW Open Data API response for NAICS 518 (Data
#' Processing, Hosting & Related Services), pulled quarterly for 2024-2025.
#' Bundled so the "Foraging for Data" webinar demo can run offline if the
#' live BLS API call is slow or unavailable during class.
#'
#' @format A data frame with one row per area/ownership/industry/quarter
#'   combination and the full set of columns returned by the QCEW API,
#'   including:
#' \describe{
#'   \item{area_fips}{QCEW area FIPS code.}
#'   \item{own_code}{Ownership code (e.g. private, federal, state, local).}
#'   \item{industry_code}{QCEW industry code (NAICS).}
#'   \item{year, qtr}{Year and quarter of the observation.}
#'   \item{qtrly_estabs}{Quarterly count of establishments.}
#'   \item{month1_emplvl, month2_emplvl, month3_emplvl}{Employment level for
#'     each month of the quarter.}
#'   \item{total_qtrly_wages}{Total quarterly wages.}
#'   \item{avg_wkly_wage}{Average weekly wage.}
#'   \item{...}{Additional location quotient (`lq_*`) and over-the-year
#'     change (`oty_*`) columns as returned by the API.}
#' }
#' @source U.S. Bureau of Labor Statistics, Quarterly Census of Employment and
#'   Wages (QCEW) Open Data API.
"qcew_raw_cache"
