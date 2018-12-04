#These are some short functions that are useful for clinical trial analysis and producing clinical study reports

#Rename columns to tidy names
require(tidyverse)
TIBL %>%
  rename_all(funs(make.names(.))) %>%
  rename_all(funs(str_replace(.,"\\.{2,}","\\."))) %>%
  rename_all(funs(str_replace(.,"\\.$",""))) %>%
  rename_all(funs(tolower(.)))

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
  
#Remove rows with NA is specific variable
require(tidyverse)
TIBL %>% 
  dplyr::filter(!is.na(VARIABLE))

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