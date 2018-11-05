#These are some short functions that are useful for clinical trial analysis and producing clinical study reports

#Rename variables to tidy names
require(tidyverse)
tibl %>%
  rename_all(funs(make.names(.))) %>%
  rename_all(funs(str_replace(.,"\\.{2,}","\\."))) %>%
  rename_all(funs(tolower(.)))

#Remove all rows if NA excluding certain columns
require(tidyverse)
tibl %>%
  dplyr::filter_at(vars(-VARIABLE1, -VARIABLE2), any_vars(!is.na(.)))

#Add randomisation key to cases
tibl %>%
  left_join(TIBLWITH_RANDOMISATION_KEYS) %>%
  dplyr::select(CASE_ID_VARIABLE, RANDOMISATION_KEY_VARIABLE, everything())

#YAML header for R Markdown. Includes current date
---
  title: "NAPRESSIM Statistics"
author: "Sebastian Vencken"
date: "`r format(Sys.time(), '%d %B, %Y')`"
output:
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
tibl %>% 
  dplyr::filter(!is.na(VARIABLE))

#
