# Simple arithmetic calculations
1 + 1
4*9
3^(1/2)
1 + 3 + 5 + 7 + 9

# Save values as objects
x <- 5
x + 1

# Create vectors with c() - combine function
x <- c(1, 3, 5, 7, 9)
sum(x)

# Load tidyverse library
library(tidyverse)

# Basic R commands
mn_midwest <- subset(midwest, state == "MN")
mn_midwest <- subset(mn_midwest, !is.na(poptotal))

sum(mn_midwest$poptotal)

# Tidyverse commands: filter to subset data
mn_midwest <- filter(midwest, state == "MN", !is.na(poptotal)) 

# create summation of column
summarise(mn_midwest, poptotal = sum(poptotal))