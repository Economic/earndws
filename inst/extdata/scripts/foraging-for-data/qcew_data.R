library(tidyverse)
library(lubridate)

# This function loads all industries for one geographical area
qcewGetAreaData <- function(year, qtr, area) {
  url <- "http://data.bls.gov/cew/data/api/YEAR/QTR/area/AREA.csv"
  url <- sub("YEAR", year, url, ignore.case=FALSE)
  url <- sub("QTR", tolower(qtr), url, ignore.case=FALSE)
  url <- sub("AREA", toupper(area), url, ignore.case=FALSE)
  read.csv(url, header = TRUE, sep = ",", quote="\"", dec=".", na.strings=" ", skip=0)
}

# This function loads one industry for all geographical areas
qcewGetIndustryData <- function (year, qtr, industry) {
    url <- "http://data.bls.gov/cew/data/api/YEAR/QTR/industry/INDUSTRY.csv"
    url <- sub("YEAR", year, url, ignore.case=FALSE)
    url <- sub("QTR", tolower(qtr), url, ignore.case=FALSE)
    url <- sub("INDUSTRY", industry, url, ignore.case=FALSE)
    read.csv(url, header = TRUE, sep = ",", quote="\"", dec=".", na.strings=" ", skip=0)
}

# Quick examples (not evaluated by default)
# In ex. 1, we call the qcewGetAreaData() function, passing parameters for year, quarter, and areafips/geography i.e. year = 2015, quarter = 1, areafips = 26000 or Michigan.
# We then assign the data called to a variable called MichiganData!

#  MichiganData <- qcewGetAreaData("2015", "1", "26000")
#  Construction <- qcewGetIndustryData("2015", "1", "1012")

# Set our parameters 
years <- 2022:2024
quarters <- 1:4
industries <- c('518')   

# create 12 combinations (3 years × 4 quarters × 1 industry) to pass through pmap()
combos <- tidyr::crossing(year = years, qtr = quarters, industry = industries)

# Takes the combinations, runs qcewGetIndustryData() once for each
# returns a list of "small" dataframes, which we combine into a large one called QCEW raw

qcew_raw <- pmap(combos, function(year, qtr, industry){
  qcewGetIndustryData(year, qtr, industry)
  }) |> 
  # Combines all dataframes by appending/binding "rows" 
  bind_rows()

# Explores our data
glimpse(qcew_raw)


# link to csv files on the BLS QCEW site
ind_title_url <- 'https://www.bls.gov/cew/classifications/industry/industry-titles.csv'
area_title_url <- 'https://www.bls.gov/cew/classifications/areas/area-titles-csv.csv'

# # Read csv files directly into R from the QCEW page
# ind_titles  <- read_csv(ind_title_url)
# area_titles <- read_csv(area_title_url)

ind_titles <- read_csv('data/industry_titles.csv')
area_titles <- read_csv('data/area-titles-csv.csv')

# Can you spot the difference?
glimpse(qcew_raw$industry_code)   # likely <int> / <dbl>

glimpse(ind_titles$industry_code) # likely <chr>

# What happens?
qcew_raw |>
  dplyr::left_join(ind_titles)

# Make the join keys the same type
ind_titles <- ind_titles |>
  mutate(industry_code = as.numeric(industry_code))

# Now the join works:
qcew_ind_clean <- qcew_raw |>
  # natural join on identical names
  left_join(ind_titles)  

# We could also be explicit about which variable to join by
# qcew_ind_clean <- qcew_raw |> 
#   left_join(ind_titles, by = 'industry_code')

# If our variable names differ, we could map them using 
# left_join(ind_titles, by = c("industry_code" = "ind_code"))

# (If needed) ensure area_fips types match before joining area_titles
# area_titles <- area_titles |> mutate(area_fips = as.character(area_fips))

qcew_clean <- qcew_ind_clean |>
  left_join(area_titles) |> 
  # Too many variables we don't need, let's restrict and re-order using select
  select(
    year, qtr, area_fips, area_title, industry_code,
    industry_title, own_code, agglvl_code, month1_emplvl, month2_emplvl,
    month3_emplvl) |> 

  # Now, why are seeing two rows for each state? Again, per the codebook, QCEW contains data for public and private sector industries
  # We can filter for private sector data using own_code == 5
  filter(own_code == 5) |> 
  filter(agglvl_code == 55)

# Tip: An alternative way to filter for statewide data. If you don’t have a variable like agglvl_code, you can use string detection to filter statewide rows. We prefer to use code‑book filters when available.
# filter(str_detect(area_title, " -- Statewide")) 

qcew_qtr <- qcew_clean |>
  mutate(
    qtr_avg_emp = (month1_emplvl + month2_emplvl + month3_emplvl) / 3,
    qdate       = yq(paste(year, qtr, sep = " Q"))
  )

state_qtr_table <- qcew_qtr |>
  mutate(state = str_replace(area_title, " -- Statewide", "")) |>
  select(qdate, state, qtr_avg_emp) |>
  pivot_wider(id_cols = qdate, names_from = state, values_from = qtr_avg_emp)

state_qtr_table

qcew_monthly <- qcew_clean |>
  pivot_longer(
    cols = starts_with("month"),
    names_to = "month_in_qtr",
    names_pattern = "month(\\d+)_emplvl",
    values_to = "emplvl"
  ) |>
  mutate(
    month_in_qtr = as.integer(month_in_qtr),
    month        = (qtr - 1) * 3 + month_in_qtr,
    date         = make_date(year, month, 1),
  ) |>
  select(area_title, area_fips, industry_code, year, qtr, date, emplvl) |>
  arrange(area_title, year, qtr, date) |> 
  # let's clean up our state names!
  mutate(state = str_replace(area_title, " -- Statewide", ""))

head(qcew_monthly)

state_growth <- qcew_monthly |>
  summarize(
    start_emplvl = first(emplvl),
    end_emplvl   = last(emplvl),
    start_date   = first(date),
    end_date     = last(date),
    .by=state) |>
  mutate(
    emp_change = (end_emplvl - start_emplvl),
    pct_change = (end_emplvl / start_emplvl - 1) * 100) |>
  # arrange data in descending order by pct_change
  arrange(desc(pct_change))

state_growth |> slice_head(n = 10)

sel_state_data <- qcew_monthly |> 
  filter(state %in% c('Texas', 'Arkansas', 'Louisiana'))

ggplot(data = sel_state_data, aes(x=date, y=emplvl, color=state)) +
  geom_line() +
  labs(
    title = "Monthly employment (NAICS 518)",
    x = NULL, y = "Employment level",
    color = "State"
  ) 