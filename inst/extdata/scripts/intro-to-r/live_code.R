x <- c(1,3,5,7,9)

sum(x)
1+3+5+7+9

mean(x)
min(x)
max(x)
length(x)

library(epiextractr)

# view sample
org_sample <- load_org_sample(.years = 2023)

mean(org_sample$wage, na.rm = FALSE)

org_sample$wage

mean(subset(x = org_sample, statefips == 48)$wage, 
     na.rm = TRUE)

subset(x = org_sample, !is.na(wage))

tx_org_sample <- subset(x = org_sample, statefips == 48)
tx_org_non_na_wage_sample <- subset(x = tx_org_sample, 
                                    !is.na(wage))
mean(tx_org_non_na_wage_sample$wage)

org_sample |> 
  subset(statefips == 48) |> 
  subset(!is.na(wage)) |> 
  with(mean(wage))

library(tidyverse)

org_sample |> 
  filter(statefips == 48,
         !is.na(wage)) |> 
  summarise(mean_wage = mean(wage),
            min = min(x),
            max = max(x),
            n = n())

org_sample |> 
  summarise(epop = weighted.mean(emp, w = orgwgt), 
            .by = statefips)

urate <- org_sample |> 
  filter(lfstat != 3) |> 
  mutate(unemp = if_else(emp == 0, 1, 0)) |> 
  summarise(unemp_rate = weighted.mean(unemp, w = orgwgt),
            .by = statefips) |> 
  mutate(usps = haven::as_factor(statefips)) |> 
  write_csv(file = "unemp_rates_state.csv")

ggplot(data = urate, aes(x = state, y = unemp_rate)) + 
  geom_bar(stat = "identity") +
  labs(title = "Unemployment rate in the U.S. by state",
       subtitle = "Source: EPI Microdata.",
       x = "State",
       y = "Unemployment rate")

library(maps)
map_data("state")

library(fips)

urate <- org_sample |> 
  filter(lfstat != 3) |> 
  mutate(unemp = if_else(emp == 0, 1, 0)) |> 
  summarise(unemp_rate = weighted.mean(unemp, w = orgwgt),
            .by = statefips) |> 
  mutate(usps = haven::as_factor(statefips)) |> 
  left_join(y = fips, by = "usps") |> 
  mutate(region = tolower(state))


map_data <- left_join(x = map_data("state"), y = urate, by = "region")

ggplot(data = map_data, aes(x = long, y = lat, 
                            group = statefips, fill = unemp_rate)) +
  geom_polygon(color = "white") +
  labs(title = "Unemployment rate in the U.S. by state",
       subtitle = "Source: EPI Microdata.",
       x = "",
       y = "") +
  theme_minimal() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank()) +
  scale_fill_gradient(low = "lightblue", high = "darkblue",
                      name = "Unemployment rate") +
  ggsave(filename = "urate_state_map.png")









