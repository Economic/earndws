# r is a simple calculator: simple arithmetic operations (+ , * etc.)
#note: in the console
1 + 1
4*9
3^(1/2)
1 + 3 + 5 + 7 + 9

x <- 5
x + 1


# r can handle more complex data structures like vectors to perform dynamic summation 
# let's open an R script, which is a file where we can write and save our commands that we would enter on the command line of R
# here we will write any code that we want to save

# we'll use the assignment arrow to combine a list of objects (reusability and readability)
x <- c(1, 3, 5, 7, 9)
# with a function you have a name and parthensis and everything related to the function happens in the parenthesis
sum(x)

# to understand the utility let's get the average of 50 elements
# using simple arithmetic operations would take so long to do

# the base-R summary functions take in a vector of data and performs the mathetmatical operation
# let's explore a few more common operations to get more familiar with the syntax
# functions to demonstrate: mean, min, max, length
mean(x)
min(x)
max(x)
length(x)

# R can be used to perform operations on datasets
# data frame: in R lingo, it is a collection of columns or variables in a dataset
library(epiextractr)
load_org_sample(.years = 2023)
# explain # here
# now when we start storing things it's important to note that R is case-sensitive and 
# doesn't recognize spaces,
# so it's good practice to use lower-case names to prevent syntax errors,
# and you will want to use an underscore anywhere you would want to use a space
# assign using arrow instead of = (= overloaded a bit taking on the roles of an assignment operator, function argument binding, or depending on the context, case statement)
org_sample <- load_org_sample(.years = 2023)

# we can use the GUI data viewer to interactively view the data

# use selection operator to perform dynamic summation on specific column
mean(org_sample$wage)

# you will get NA, let's use this unexpected result to breakdown the different parts

# subsetting
# using $ operator to isolate column from dataset
org_sample$wage

# ideally we would want this operation to perform as if those missing values are not in the sample
# we can look up the documentation of the function to see if there is an functionality built in that will solve this issue

## maybe move usng documentation to later
# we can look up the documentation by typing ?function into the console, 
# this will pull up the help tab and navigate to the documentation written specific for the function, 
# including descriptions for the required and optional inputs and case examples that you can use to explore how the function works

# everything related to the function is a comma separated list of arguments


# the mean function is the generic function for the arithmetic mean
# it has one required input of an "R object," such as a numeric vector, which we've demonstrated using a defined vector, as well as using the selection syntax
# mean has option functionality to trim values, and remove missing values. 
# the na.rm argument takes a logical value defaulted to FALSE. 
# when set to TRUE the function filters or removes missing data before performing the operation
mean(org_sample$wage, na.rm = TRUE)

# now we see ...

# base-R filtering
# use both selection operators to filter using condition
# this syntax is a little complicated and particular ...
#note: comma to the right ~ row selection, comma to the left ~ column selection
#not: filter is row operation, reducing number of rows
subset(org_sample, statefips == 48)

# we can wrap mean around our filter
mean(subset(org_sample, statefips == 48), na.rm = TRUE)


# use pipe to subset org_sample
org_sample |> subset(statefips == 48)

# now we can save this result 
tx_org_sample <- org_sample |> 
  subset(statefips == 48)

# and use it to define our mean function
mean(tx_org_sample$wage, na.rm = TRUE)

# now i know that you're thinking we just made the code longer and we have to use these weird symbols,
# how is this better?

# well what if we wanted to subset our TX data again to drop missing before we take the mean
# without piping, we would have to 
# we can save an object with our texas sample
tx_org_sample <- subset(org_sample, statefips == 48)

# and then save an object that filters out missing wage data from our texas sample
tx_org_non_na_wages_sample <- subset(tx_org_sample, !is.na(wage))

# here i'm using this function is.na(), which is a useful function to 
# identify missing values in a column of data
# we can use this inside subset to identify the rows with missing values for wages
# and then we use the negation operator '!' to exclude missing wages 

# now we can apply our mean to this filtered data
mean(tx_org_non_na_wages_sample$wage)

# now this code is getting a little harder to read and a little more annoying to write
# but if we incorporate piping, we can pass both filtering operations at once
tx_sample <- org_sample |> 
  subset(statefips == 48) |> 
  subset(!is.na(wage))

mean(tx_sample$wage)


# ideally, we could incorporate the mean operation into the pipeline so that we don't even have to save tx_sample
# however,  the mean() function was designed to work on a single column of data,
org_sample |> 
  subset(statefips == 48) |> 
  subset(!is.na(wage)) |> 
  mean(wage, na.rm = TRUE)

# so we will need to use the with() function in order to properly apply the mean to the column wage from this LHS filtered data
org_sample |> 
  subset(statefips == 48) |> 
  subset(!is.na(wage)) |> 
  with(mean(wage))

# by stepping through our calculation using pipes allows us to easily see the data frame we are modifying
# and each step of modification

# Now at this point we've pretty much exhausted everything we can easily do in base-R
# in general, you will find that base-R functions have very computer-y/abstract syntax, 
# which allows the software to run powerful and complex operations, but it to be can be difficult for
# new or casual more users to learn simple workflows

# fortunately, there is an entire suite of packages called tidyverse that have utility functions designed to make
# data science tasks easier.  

# tidyverse --- (use pptx notes)

# this list of packages are the core packages that will be loaded when you run * swtich to RStudio
library(tidyverse)

# everything we've done in base-R we can also do in tidyverse

# we will use filter instead of subset to filter out our data
# and instead of applying filter twice 
org_sample |> 
  filter(statefips == 48) |> 
  filter(!is.na(wage))

# we have the ability to supply filter with multiple conditions to filter one, 
# separated by a comma
org_sample |> 
  filter(statefips == 48, !is.na(wage)) |> 
  summarise(mean_wage = mean(wage))

# and if we want to extend this analysis by performing more statistical operations, 
# we can apply a similar logic to the summarise() command
org_sample |> 
  filter(statefips == 48, !is.na(wage)) |> 
  summarise(mean = mean(wages),
            # let's grab the min and max
            min = min(wage),
            max = max(wage),
            # and let's create a count of observations
            n = n())

# how you write our code is somewhat a matter of personal preference, 
# but in general, i will define the data frame to be modified and pipe each operation separately
# each modification operation will occur on a new line and the pipe will always be at the end of the line
# if the code gets to wide, i will use new lines after a comma to reduce the width like i do in summarise()

# let's integrate everything we've learned so far to design a meaningful analysis
# we will use the ORG data to create employment and unemployment rates

# let's save our current notes and restart our R session, so that we can start with a fresh workspace

# start project ??? 

# first we'll call in our ORG sample
# here we can omit the argument name, because R can ........... 
org_sample |> 
  # now we can calculate the employment rate
  # the employment rate is the mean of the categorical emp variable,
  # which is 0 if unemployed and 1 if employed
  # (mean is the proportion of 1s in the sample)
  # because the CPS is a representative survey we will need weight our calculation 
  # using the org weight variable (orgwgt)
  summarise(emp_rate = weighted.mean(emp, w = orgwgt))

# this is cool, but what about unemployment rates?
# currently, our sample data has a variable that identifies employment,
# but in order to get the unemployment rate we need a variable that identifies unemployment
# let's load in the org sample again
org_sample |> 
  # and now we'll make the a new variable for unemployment
  # we can use mutate() to create new columns
  # we will define unemp using emp, where if emp == 0 (i.e. the observation is not employed)
  # mark their unemp as 1 (i.e. the observation is unemployed), otherwise the observation is 0
  mutate(unemp = if_else(emp == 0, 1, 0)) |> 
  # now we can take the weighted mean to calculate the unemployment rate
  summarise(unemp_rate = weighted.mean(unemp, w = orgwgt))

# now we have the national employment and unemployment rate, by how do we could get this data by state?
# we can use the .by argument in the summarise() function to establish grouping
# let's go back up to employment rates and add the .by argument to the summarise function
# the .by arg is part of the summarise() function, not the weighted.mean() function, 
# so make sure it is inside the correct set of parenthesis
org_sample |> 
  filter(!is.na(emp)) |> 
  summarise(emp_rate = weighted.mean(emp, w = orgwgt), .by = statefips)

# and we can do the same thing in the unemployment rates chunk
org_sample |> 
  mutate(unemp = if_else(emp == 0, 1, 0)) |> 
  filter(!is.na(unemp)) |> 
  summarise(unemp_rate = weighted.mean(unemp, w = orgwgt), .by = statefips)

# now we have a pretty useful table of data, but unfortunately
# the statefips variable takes on the numeric categorical value as opposed to the label (point)
# luckily, we can use a function called as_factor(), which is going to help us
# transform the statefips variable so that the state abbreviation prints instead of the number

org_sample |> 
  mutate(unemp = if_else(emp == 0, 1, 0)) |> 
  filter(!is.na(unemp)) |> 
  summarise(unemp_rate = weighted.mean(unemp, w = orgwgt), .by = statefips) |> 
  # this function is coming from the haven package so i'll use the double colon operator to 
  # identify the package that the function is coming from
  mutate(state = haven::as_factor(statefips)) |> # pause
  # now I'll use built-in datasets to convert state abbreviations to full state names.
  # (print out datasets to console)
  # The str_replace() function will replace the first match of an abbreviation with the full name.
  # Inside mutate, I’ll use str_replace to update the state column by searching for abbreviations 
  # and swapping them with their full state names.
  # For example, when the code finds "AL," it will replace it with "Alabama."
  mutate(state = str_replace(state, state.abb, state.name))


org_sample |> 
  mutate(unemp = if_else(emp == 0, 1, 0)) |> 
  filter(!is.na(unemp)) |> 
  summarise(unemp_rate = weighted.mean(unemp, w = orgwgt), .by = statefips) |> 
  mutate(state = haven::as_factor(statefips)) |> 
  # now unfortunately this was not successfully executed because DC is not a state
  # so it doesn't appear in the state.abb and state.name data (print out)
  # we can use the c() function again to add DC to the list of state.abb
  # and remember that we have to tell R also what to replace it with, 
  # so now we need to add it to state.name
  mutate(state = str_replace(state, c(state.abb, "DC"), c(state.name, "District of Columbia")))

org_sample |> 
  mutate(unemp = if_else(emp == 0, 1, 0)) |> 
  filter(!is.na(unemp)) |> 
  summarise(unemp_rate = weighted.mean(unemp, w = orgwgt), .by = statefips) |> 
  mutate(state = haven::as_factor(statefips)) |> 
  # okay so this worked, but only up to the instance of DC, and then nothing else happened
  # this is because the order of the cells matters when R goes to search for abbreviation
  # when we run c(state.abb, "DC"), DC was attached at the end of the list, 
  # effectively changing the standard order of state abbreviations
  # so, (open data)
  # R will find Al then replace with Alabama, it will find AK and replace it with Alaska and so on,
  # when it gets to DE it will replace it with Delaware, but when it gets to DC 
  # it will compare DC to FL which is not a match, so str_replace() will do nothing
  # now the order has been thrown off and all the states abb are off by one
  # so we can wrap sort() around the c() to tell R, 
  # okay we want to re-order or re-alphabetize our match
  # we also want to do this to our state name
  # and we want to also sort our original column data so that everything matches
  mutate(state = str_replace(sort(state), sort(c(state.abb, "DC")), sort(c(state.name, "District of Columbia"))))


org_sample |> 
  mutate(unemp = if_else(emp == 0, 1, 0)) |> 
  filter(!is.na(unemp)) |> 
  summarise(unemp_rate = weighted.mean(unemp, w = orgwgt), .by = statefips) |> 
  mutate(state = haven::as_factor(statefips)) |> 
  # okay now there's one last thing we need to do to get this to work properly
  # right now, because of the way that we have defined state as a factor 
  # sort is still using the numeric representation (or state fips code) to sort the column of data
  # urate
  # annoyingly, the alphabetic order of the state abbreviations is not the same as the 
  # numeric order of the statefips codes, so we need to tell R or assert that we want to 
  # sort state alphabetically 
  # we can use as.character() to assert that we want to sort state as the character representation, 
  # or state abbreviation
  # now, when we run this, the original state column will match the state abbreviation pattern
  # and properly replace it with the correct state name
  mutate(state = str_replace(sort(as.character(state)), sort(c(state.abb, "DC")), sort(c(state.name, "District of Columbia"))))

# if we compare statefips and state see how AL and AK are not matched and replaced,
# that's because Alabama is before Alaska, but AL is after AK

# now we've already gone into some more complex methods, 
# but i wanted to give everyone a chance to walk away with a product so
# let's use all the data that we've created to make a map

# i'm going to go through this slowly, 

install.pacakge("maps")

library(maps)

# this dataset will provide us with the latitude and longitudinal data 
# necessary to plot our data
map_data("state")


# before we can merge our map data onto our unemployment rate data
# we need to make sure that the key we are using to merge our data with has the 
# same name, spelling, and case, otherwise the keys won't match

# here, we want to merge by state so that each coordinate within the state
# has a corresponding unemployment rate

# in order to do that we need to force the state name to be in all lower-cases
# i will use the tolower() function which will transform any upper-case letters into lower
urate <- org_sample |> 
  mutate(unemp = if_else(emp == 0, 1, 0)) |> 
  filter(!is.na(unemp)) |> 
  summarise(unemp_rate = weighted.mean(unemp, w = orgwgt), .by = statefips) |> 
  mutate(state = haven::as_factor(statefips),
         state = str_replace(sort(as.character(state)), 
                             sort(c(state.abb, "DC")), 
                             sort(c(state.name, "District of Columbia"))),
         # i'll assign this to a variable called region to match the maps_data
         region = tolower(state))

# now we can combine our data together so that each coordinate has a corresponding unemployment rate
# i will use a function left_join() which will take in two datasets
# x will be our coordinate data 
# and y will be our unemployment data
# we will use the by argument to identify the key that we want to join on
map_data <- left_join(x = map_data("state"), y = urate, 
                      by = "region")

# finally, we can construct our ggplot map
# first we need to initialize the ggplot graph and assign our data to the graph
# we will use aes() to tell R how we want the variables in the data to be mapped
# to our plot
# here, we want our x to longitude, y to be latitude, this will allow the map to 
# draw the states
# we will assign our grouping as statefips, since the unemployment rate 
# is grouped by state
# and then we will fill the color of the state based on the value of unemployment rate
ggplot(map_data, aes(x = long, y = lat, group = statefips, fill = unemp_rate)) +
  # we will use the geom_polygon() function to draw the map
  geom_polygon(color = "white") +
  # we can add a title, source line, and x and y axis label using the labs() function
  labs(title = "Unemployment rates in the U.S.",
       subtitle = "Source: Economic Policy Institute. 2024. Current Population Survey Extracts, Version 1.0.54, https://microdata.epi.org.",
       # i'm going to leave x and y blank
       x = "",
       y = "") +
  # we can use theme_minimal() to remove this box in the data
  theme_minimal() +
  # and use theme() to get rid of all these axis ticks and grid lines
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank()) +
  # and if we want to get fancy with it, we can even change the gradient color
  scale_fill_gradient(low = "lightblue", high = "darkblue", 
                      name = "Unemployment Rate")


