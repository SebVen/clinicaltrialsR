#These are some short functions that are useful for clinical trial analysis and producing clinical study reports

#Seb - needs more explanatory info - which trials? Where does data come from ?

#Rename columns to tidy names
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
  left_join(TIBL_WITH_RANDOMISATION_KEYS) %>%
  dplyr::select(CASE_ID_VARIABLE, RANDOMISATION_KEY_VARIABLE, everything())