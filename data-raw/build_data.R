# Run this script once from the package root to (re)build .rda objects in data/.
# Requires usethis to be installed.

library(usethis)

# read source CSVs (paths are relative to package root)
qcew_area_titles  <- read.csv("data-raw/area-titles-csv.csv")
qcew_ind_titles   <- read.csv("data-raw/industry-titles.csv")

# write each as a compressed .rda file into data/
use_data(qcew_area_titles, overwrite = TRUE)
use_data(qcew_ind_titles,  overwrite = TRUE)
