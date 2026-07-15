#' Set up a workshop working directory
#'
#' Creates \code{code/}, \code{input/}, and \code{output/} subdirectories in
#' the target path, copies the relevant workshop scripts into \code{code/}, and
#' writes the bundled data CSVs into \code{input/} so the scripts run without
#' any network access.
#'
#' @param workshop One of \code{"foraging-for-data"} or \code{"intro-to-r"}.
#' @param path Target directory. Defaults to the current working directory.
#'
#' @return Called for its side effects; returns \code{NULL} invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' setup_workshop("foraging-for-data")
#' setup_workshop("intro-to-r", path = "~/earn-workshop")
#' }
setup_workshop <- function(workshop = c("foraging-for-data", "intro-to-r"), path = ".") {
  workshop <- match.arg(workshop)

  # create standard directory structure
  dirs <- file.path(path, c("code", "input", "output"))
  lapply(dirs, dir.create, showWarnings = FALSE, recursive = TRUE)

  # copy scripts from inst/extdata/scripts/{workshop}/ into code/
  scripts_src <- system.file("extdata", "scripts", workshop, package = "earndws")
  if (scripts_src == "") stop("Package installed incorrectly: scripts not found.")
  scripts <- list.files(scripts_src, full.names = TRUE)
  file.copy(scripts, file.path(path, "code"), overwrite = TRUE)

  # write bundled datasets as CSVs into input/ so scripts can read without downloading
  if (workshop == "foraging-for-data") {
    utils::write.csv(qcew_area_titles, file.path(path, "input", "area-titles-csv.csv"),            row.names = FALSE)
    utils::write.csv(qcew_ind_titles,  file.path(path, "input", "industry-titles-csv.csv"), row.names = FALSE)
  }

  message("Workshop ready in '", normalizePath(path), "'")
  message("  code/   - workshop scripts")
  message("  input/  - data files")
  message("  output/ - your results go here")
  invisible(NULL)
}
