# earndws

**Workshop Materials for the EARN Data Bootcamp**

`earndws` is an R package that bundles scripts, data, and dependencies for the Economic Analysis and Research Network (EARN) Conference data bootcamp workshops. Its single setup function creates a ready-to-run working directory so participants can start coding without any manual file downloads or directory setup.

---

## Installation

Install the package from its source directory (or from GitHub if hosted there):

```r
# Using remotes/pak if hosted on GitHub
remotes::install_github("Economic/earndws")
```

### Required packages

The following packages are installed automatically as dependencies:

| Package | Purpose |
|---|---|
| `tidyverse` | Data wrangling and visualization |
| `data.table` | Variable renaming via `setnames()` |
| `lubridate` | Date parsing and manipulation |
| `openxlsx2` | Excel workbook creation |
| `haven` | Factor handling from survey data |
| `maps` | U.S. geographic map data |

---

## Quick Start

Load the package and call `setup_workshop()` with the name of your workshop:

```r
library(earndws)

# Set up in the current working directory
setup_workshop("foraging-for-data")

# Or set up in a specific folder
setup_workshop("intro-to-r", path = "~/earn-workshop")
```

That's it. The function prints a confirmation message and your working directory is ready:

```
Workshop ready in '/home/you/earn-workshop'
  code/   - workshop scripts
  input/  - data files
  output/ - your results go here
```

Open any script in `code/` and run it — all data files it needs are already in `input/`.

---

## `setup_workshop()`

```r
setup_workshop(workshop, path = ".")
```

**Arguments**

| Argument | Type | Description |
|---|---|---|
| `workshop` | character | One of `"foraging-for-data"` or `"intro-to-r"` |
| `path` | character | Target directory. Defaults to current working directory (`.`) |

**What it does**

1. Creates three subdirectories inside `path`: `code/`, `input/`, and `output/`
2. Copies the workshop R scripts into `code/`
3. Writes the relevant bundled datasets as CSVs into `input/` — no internet connection needed

**Returns** `NULL` invisibly (called for its side effects).

---

## Workshops

### `"foraging-for-data"`

An applied data wrangling workshop using weekly unemployment insurance (UI) claims data from the U.S. Department of Labor's ETA 539 report.

**What you'll work with**

- Raw ETA 539 claims data with DOL short-code column names
- A data dictionary that maps those codes to human-readable titles
- State-level initial and continued UI claims (non-seasonally adjusted), filtered to weeks from 1987 onward

**Scripts**

| Script | Description |
|---|---|
| `state_ui.R` | Full participant script: loads data, renames variables using the DOL data dictionary, calculates NSA initial and continued claims, pivots to wide format (states as columns), adds a US Total column to continued claims, and exports a formatted two-sheet Excel workbook to `output/state_ui.xlsx` |
| `live-demo-practice.R` | Streamlined live-demo reference with the same core workflow but no output formatting — intended as an instructor companion during the session |

**Bundled data written to `input/`**

| File | Description |
|---|---|
| `ar539.csv` | Weekly state-level UI initial and continued claims from the DOL ETA 539 report. One row per state per week; column names use DOL short codes (e.g. `c1`, `c3`, `rptdate`) |
| `eta539_var_names.csv` | Data dictionary with two columns — `dol_code` and `dol_title` — used to rename `ar539` columns to readable labels |

---

### `"intro-to-r"`

A fundamentals workshop teaching R through hands-on analysis of national and state unemployment rates from CPS Outgoing Rotation Group (ORG) data.

> **Note:** This workshop requires the `epiextractr` package. See [Optional: epiextractr](#optional-epiextractr) above.

**What you'll learn**

- Basic R syntax and arithmetic
- Vectors, functions, and variable assignment
- Data frames: subsetting with `$` and `[,]`, filtering with `subset()`
- The pipe operator (`|>`) and readable data workflows
- Core tidyverse verbs: `filter()`, `mutate()`, `summarise()`
- Weighted statistics: `weighted.mean()` with survey weights
- Conditional logic with `if_else()`
- Working with factors and string operations
- Data visualization with `ggplot2`: bar charts and choropleth maps

**Scripts**

| Script | Description |
|---|---|
| `intro_to_r.R` | Comprehensive participant tutorial walking through all concepts from basic arithmetic to geographic mapping, with explanatory comments throughout |
| `live_code.R` | Condensed live-coding reference with key examples for each concept — intended as an instructor companion during the session |

**Bundled data written to `input/`**

| File | Description |
|---|---|
| `unemp_rates.csv` | National unemployment rates derived from CPS ORG extracts. Columns: `statefips`, `unemp_rate`, `usps` |
| `unemp_rates_state.csv` | State-level unemployment rates from CPS ORG extracts. Same structure as above |

---

## Directory Structure After Setup

```
your-path/
├── code/
│   ├── state_ui.R                  # (foraging-for-data)
│   └── live-demo-practice.R
│   # or
│   ├── intro_to_r.R                # (intro-to-r)
│   └── live_code.R
├── input/
│   ├── ar539.csv                   # (foraging-for-data)
│   └── eta539_var_names.csv
│   # or
│   ├── unemp_rates.csv             # (intro-to-r)
│   └── unemp_rates_state.csv
└── output/
    └── (your results go here)
```

---

## Bundled Datasets

The package also exposes its datasets directly as R objects after `library(earndws)`:

```r
# ETA 539 UI claims data
?ar539

# DOL variable name dictionary
?eta539_var_names

# National CPS unemployment rates
?unemp_rates

# State-level CPS unemployment rates
?unemp_rates_state
```

---

## Author

Jori Kandra — [jkandra@epi.org](mailto:jkandra@epi.org)  
Economic Policy Institute
