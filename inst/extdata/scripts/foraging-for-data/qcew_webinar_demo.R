# ==============================================================================
# QCEW Live Coding Demo — Foraging for Data Webinar
# ------------------------------------------------------------------------------
# Goal: pull employment data for one industry (NAICS 518 — Data Processing,
# Hosting & Related Services, i.e. "data centers") across several states and
# quarters, clean it up, and chart the growth trend.
#
# This is the CONDENSED, live-coding version — trimmed to fit a ~50 minute
# session with two "Your Turn" pauses built in. For the full reference
# version with extra examples and alternate approaches, see qcew_data.R.
# ==============================================================================

library(tidyverse)
library(lubridate)

# ------------------------------------------------------------------------------
# 1. Get familiar with the QCEW API function ----
# ------------------------------------------------------------------------------
# BLS's own boilerplate for querying the Quarterly Census of Employment &
# Wages (QCEW) API — it swaps year/quarter/industry into a URL template and
# reads back a CSV. No magic here.
qcewGetIndustryData <- function(year, qtr, industry) {
  url <- "http://data.bls.gov/cew/data/api/YEAR/QTR/industry/INDUSTRY.csv"
  url <- sub("YEAR", year, url, ignore.case = FALSE)          # slot in the year
  url <- sub("QTR", tolower(qtr), url, ignore.case = FALSE)   # slot in the quarter
  url <- sub("INDUSTRY", industry, url, ignore.case = FALSE)  # slot in the NAICS code
  read.csv(url, header = TRUE, sep = ",", quote = "\"", dec = ".", na.strings = " ", skip = 0)
}

# Try it once for a single year/quarter combo
data_centers_2023q1 <- qcewGetIndustryData(2025, 1, "518")

glimpse(data_centers_2023q1)

# ------------------------------------------------------------------------------
# 2. Scale up with crossing() + pmap() ----
# ------------------------------------------------------------------------------
# We want several quarters of history, not just one. Instead of calling the
# function by hand 8 times, build a table of every year/quarter combo we
# want, then map the function over each row.
years    <- 2024:2025
quarters <- 1:4
industry <- "518"  # NAICS 518: Data Processing, Hosting & Related Services

combos <- tidyr::crossing(year = years, qtr = quarters)

# NOTE: this makes 8 live calls to the BLS API — give it 15-20 seconds.
# If the API is slow/unresponsive during class, ask your instructor for the
# cached copy instead: qcew_raw <- read_csv("input/qcew_raw_cached.csv")
qcew_raw <- 
  map2(
    .x = combos$year, 
    .y = combos$qtr,
    qcewGetIndustryData(
      year = .x, 
      qtr = .y, 
      industry = "518"
  )
) |>
  bind_rows()  # stack all 8 quarterly data frames into one

glimpse(qcew_raw)

# ------------------------------------------------------------------------------
# 3. Join on human-readable titles ----
# ------------------------------------------------------------------------------
ind_titles  <- read_csv("input/industry_titles.csv")
area_titles <- read_csv("input/area-titles-csv.csv")

# Can you spot the difference between these two?
glimpse(qcew_raw$industry_code)    # <int>/<dbl> — came from base R read.csv()
glimpse(ind_titles$industry_code)  # <chr> — came from readr::read_csv()

# left_join() matches by column name AND type — mismatched types silently
# return zero matches, not an error. Make the types agree before joining:
ind_titles <- ind_titles |>
  mutate(industry_code = as.numeric(industry_code))

qcew_clean <- qcew_raw |>
  left_join(ind_titles) |>
  left_join(area_titles) |>
  # keep only the columns we need for this analysis
  select(
    year, qtr, area_fips, area_title, industry_code, industry_title,
    own_code, agglvl_code, month1_emplvl, month2_emplvl, month3_emplvl
  ) |>
  filter(own_code == 5) |>      # own_code 5 = private sector (drops federal/state/local gov)
  filter(agglvl_code == 55) |>  # agglvl_code 55 = one row per state total (drops county detail)
  mutate(state = str_replace(area_title, " -- Statewide", ""))  # tidy labels for later

# ------------------------------------------------------------------------------
# >>> YOUR TURN #1 -------------------------------------------------------------
# Pick three states you're curious about and filter qcew_clean down to just
# those rows. Swap in your own states below.
# ------------------------------------------------------------------------------
my_states <- c("Texas", "Virginia", "Ohio")

qcew_clean |>
  filter(state %in% my_states) |>
  glimpse()

# ------------------------------------------------------------------------------
# 4. Reshape from "3 columns per quarter" to "1 row per month" ----
# ------------------------------------------------------------------------------
qcew_monthly <- qcew_clean |>
  pivot_longer(
    cols = starts_with("month"),
    names_to = "month_in_qtr",
    names_pattern = "month(\\d+)_emplvl",
    values_to = "emplvl"
  ) |>
  mutate(
    month_in_qtr = as.integer(month_in_qtr),
    month        = (qtr - 1) * 3 + month_in_qtr,  # convert qtr + month-in-qtr to month-of-year
    date         = make_date(year, month, 1)
  ) |>
  select(state, area_fips, industry_code, date, emplvl) |>
  arrange(state, date)

head(qcew_monthly)

# ------------------------------------------------------------------------------
# 5. Which states grew the fastest? ----
# ------------------------------------------------------------------------------
state_growth <- qcew_monthly |>
  summarise(
    start_emplvl = first(emplvl, na_rm = TRUE),
    end_emplvl   = last(emplvl, na_rm = TRUE),
    .by = state
  ) |>
  mutate(pct_change = (end_emplvl / start_emplvl - 1) * 100) |>
  arrange(desc(pct_change))

state_growth |> slice_head(n = 10)

# ------------------------------------------------------------------------------
# >>> YOUR TURN #2 -------------------------------------------------------------
# Look at the top 10 states above. Pick 2-3 that surprise you (or 2-3 from
# your own state/region) and plot their monthly trend.
# ------------------------------------------------------------------------------
sel_states <- c("Texas", "Virginia", "Ohio")

qcew_monthly |>
  filter(state %in% sel_states) |>
  ggplot(aes(x = date, y = emplvl, color = state)) +
  geom_line() +
  labs(
    title = "Monthly employment, NAICS 518 (Data Processing & Hosting)",
    x = NULL, y = "Employment level", color = "State"
  )

# ------------------------------------------------------------------------------
# Want more? qcew_data.R covers additional joins, a wide-format pivot, and
# more industries/years to explore on your own after the session.
# ------------------------------------------------------------------------------
