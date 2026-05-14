#' ETA 539 UI claims data
#'
#' Weekly state-level UI initial and continued claims from the DOL ETA 539
#' report. Downloaded from \url{https://oui.doleta.gov/unemploy/DataDownloads.asp}.
#'
#' @format A data frame with one row per state per week. Column names use DOL
#'   short codes (e.g. \code{st}, \code{rptdate}, \code{c1}–\code{c28}).
#'   Use \code{eta539_var_names} to map codes to human-readable titles.
#' @source U.S. Department of Labor, Employment and Training Administration.
"ar539"


#' ETA 539 variable name dictionary
#'
#' Maps DOL short codes in \code{ar539} to human-readable column titles.
#'
#' @format A data frame with two columns:
#' \describe{
#'   \item{dol_code}{DOL short code as it appears in the raw CSV.}
#'   \item{dol_title}{Human-readable column title used in workshop analysis.}
#' }
#' @source U.S. Department of Labor ETA 539 data dictionary.
"eta539_var_names"


#' National unemployment rates
#'
#' Unemployment rates computed from the CPS Outgoing Rotation Group (ORG)
#' extracts via \code{epiextractr}. Used in the intro-to-r workshop segment.
#'
#' @format A data frame with columns \code{statefips}, \code{unemp_rate}, and
#'   \code{usps} (state abbreviation).
#' @source Economic Policy Institute, CPS ORG Extracts.
"unemp_rates"


#' State-level unemployment rates
#'
#' State unemployment rates computed from the CPS Outgoing Rotation Group (ORG)
#' extracts via \code{epiextractr}. Used in the intro-to-r workshop segment.
#'
#' @format A data frame with columns \code{statefips}, \code{unemp_rate}, and
#'   \code{usps} (state abbreviation).
#' @source Economic Policy Institute, CPS ORG Extracts.
"unemp_rates_state"
