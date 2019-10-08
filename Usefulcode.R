#These are some short functions that are useful for clinical trial analysis and producing clinical study reports

#Rename columns to tidy names
require(tidyverse)
TIBL %>%
  rename_all(funs(make.names(.))) %>%
  rename_all(funs(str_replace_all(.,"\\.{2,}","\\."))) %>%
  rename_all(funs(str_replace(.,"\\.$",""))) %>%
  rename_all(funs(tolower(.)))

#Remove rows with NA is specific variable
require(tidyverse)
TIBL %>% 
  dplyr::filter(!is.na(VARIABLE))

#Remove all rows if NA excluding certain columns
require(tidyverse)
TIBL %>%
  dplyr::filter_at(vars(-VARIABLE1, -VARIABLE2), any_vars(!is.na(.)))

#Add randomisation key to cases
TIBL %>%
  left_join(TIBLWITH_RANDOMISATION_KEYS) %>%
  dplyr::select(CASE_ID_VARIABLE, RANDOMISATION_KEY_VARIABLE, everything())

#YAML header for R Markdown. Includes current date
---
  title: "TITLE"
author: "AUTHOR"
date: "`r format(Sys.time(), '%d %B, %Y')`"
output:
  word_document:
  reference_docx: reference.docx
html_document:
  df_print: paged
---
  
<style type="text/css">
  .main-container {
    max-width: INSERTpx;
    margin-left: auto;
    margin-right: auto;
  }
</style>
  
#Report on NA and factor levels
require(tidyverse)
tibble(Variable = names(TIBL), Missing = sapply(TIBL, function(x) sum(is.na(x)))) %>%
  mutate(Levels = sapply(sapply(TIBL, levels), paste ,collapse = ", "))

#Remove and sum duplicate rows
require(tidyverse)
TIBL %>%
  group_by(VARS_WITH_DUPLICATES) %>%
  summarise(NEW_VAR_NAME = sum(VAR_TO_BE_SUMMED))

#Split data into two ggplots and rename grouping variable
require(tidyverse)
GGPLOT +
facet_grid(.~group, labeller = function(variable, value){return(list("OLD_NAME1" = "NEW_NAME1", "OLD_NAME2" = "NEW_NAME2")[value])})

#Import CSV data and define variable types
require(readxl)
read_csv("FILE.csv", col_names = TRUE, col_types = cols(.default = col_double(),
                                                          VAR1 = col_character(),
                                                          VAR2 = col_integer(),
                                                          VAR3 = col_factor(levels = NULL, ordered = FALSE, include_na = FALSE),
                                                          VAR4 = col_date(format = "%Y-%m-%d"),
                                                          VAR5 = col_time(format = "%H:%M:%S"),
                                                          VAR6 = col_datetime(format = "%Y-%m-%d %H:%M:%S"),
                                                          VAR7 = col_logical(),
                                                          VAR8 = col_guess(),
                                                          VAR9 = col_skip()
                                                          ))

#Replace all values (useful for removing 'na' characters)
TIBL %>%
  mutate_all(funs(replace(., . == OLD_VALUE, NEW_VALUE)))

#Remove empty columns
TIBL %>%
  select_if(function(x) !(all(is.na(x))))

#Select columns using vector of names
VARIABLE <- c("COL_NAME1", "COLNAME_2")

TIBL %>%
  select(VARIABLE)

#Get first and last string delineated by "."
str_split(STRING, "(?=[.]).*(?<=[.])", simplify = TRUE)

#Assign a variable name from a string through dplyr
varname <- STRING

TIBL %>%
  mutate(!!varname := REMAINING) #this is the equivalent of TIBL["varname"] <- REMAINING

#Specify decimals
format(round(VARIABLE, digits = DECIMALS), nsmall = DECIMALS)

#Tell knitr to print NA values as blanks
options(knitr.kable.NA="")

#Tell R to use non-scientific notation for numbers
options(scipen=999)

#Convert tibble column into vector
TIBL %>%
  select(VARIABLE) %>%
  pull()

#Rename multiple variables using regex
TIBL %>%
  rename_at(vars(VARIABLES), ~str_replace(., "regex", "Replacement string"))

#Arrange in reverse order
TIBL %>%
  arrange(desc(VARIABLE))

#Convert a variable to rownames
TIBL %>%
  column_to_rownames(var = "VARIABLE")

#This code allows to convert a set of wide variables with common names to long variables
TIBL %>%
  gather(KEY, VALUE) %>%
  separate(KEY, into = c("VARIBLE1", "VARIABLE2"), "regex") %>%
  spread(VARIABLE1, value)
  
#Using the "matches()" function, multiple variables with different names can be selected. E.g.
TIBLE %>%
  mutate_at(vars(matches("VARIABLE1|VARIABLE2|VARIABLE3")), funs(FUNCTION))

#The "pmap()" function works similarly as "map2()" but can be used over >2 input variables.
#The multiple input variables must be in a list. E.g.
pmap(list(VARIABLE1, VARIABLE2, VARIABLE3), FUNCTION(VARIABLE1, VARIABLE2, VARIABLE3))

#A simple function to conditionally edit character variables if certain strings match. E.g., only make strings with a lower-case first character upper-case
mutate(VARIABLE = ifelse(str_detect(VARIABLE, "^[[:lower:]]"), str_to_sentence(VARIABLE), VARIABLE))

#Count without duplicates
TIBL %>%
  summarise(
    n.distinct = n_distinct(VARIABLE)
  )

#Count distinct values within a subset. This is very useful if grouping the variable is not preferred.
TIBL %>%
  summarise(
    n.distinct = n_distinct(VARIABLE[VARIABLE2 == "CONDITION"])
  )