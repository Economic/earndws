# Loading a library 
library(tidyverse)

# Importing a csv 
counties_income <- read.csv("./input/counties_per_capita_income.csv")

# Executing line by line commands 
print(counties_income)
count(counties_income, states)
summary(counties_income)
summarize(counties_income, 
  inc_median = median(household_income), 
  n=n(), 
  .by = states)

ranked_income <- mutate(counties_income, rank = rank(-pci))

# Executing a multi-line command using pipes 
cleaned_data <- counties_income |>
  filter(statefips == c(36, 6, 37)) |>
  summarise(inc_mean = mean(household_income), 
            n = n(), .by = states)

# Writing a csv to a path
write.csv(cleaned_data, "./output/state_incomes.csv")
# Happy coding!