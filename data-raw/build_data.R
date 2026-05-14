# Run this script once from the package root to (re)build .rda objects in data/.
# Requires usethis to be installed.

library(usethis)

# read source CSVs (paths are relative to package root)
ar539            <- read.csv("data-raw/ar539.csv")
eta539_var_names <- read.csv("data-raw/eta539_var_names.csv")
unemp_rates      <- read.csv("data-raw/unemp_rates.csv")
unemp_rates_state <- read.csv("data-raw/unemp_rates_state.csv")

# write each as a compressed .rda file into data/
use_data(ar539,            overwrite = TRUE)
use_data(eta539_var_names, overwrite = TRUE)
use_data(unemp_rates,      overwrite = TRUE)
use_data(unemp_rates_state, overwrite = TRUE)
