# 02_sdtm.R
# SDTM domain validation and preparation

library(tidyverse)

# Load imported SDTM datasets
dm <- readRDS("data/raw/DM.rds")
lb <- readRDS("data/raw/LB.rds")
ae <- readRDS("data/raw/AE.rds")

# Inspect SDTM domains
glimpse(dm)
glimpse(lb)
glimpse(ae)

# Inspect domain variables
names(dm)
names(lb)
names(ae)


# domain identity ---------------------------------------------------------

# 1. Validate domain identifiers

domain_check <- tibble(
  dataset = c("DM", "LB", "AE"),
  expected_domain = c("DM", "LB", "AE"),
  actual_domains = c(
    paste(unique(dm$DOMAIN), collapse = ", "),
    paste(unique(lb$DOMAIN), collapse = ", "),
    paste(unique(ae$DOMAIN), collapse = ", ")
  )
)

print(domain_check)

stopifnot(
  all(dm$DOMAIN == "DM"),
  all(lb$DOMAIN == "LB"),
  all(ae$DOMAIN == "AE")
)

# 2. Validate study identifiers

study_ids <- list(
  DM = unique(dm$STUDYID),
  LB = unique(lb$STUDYID),
  AE = unique(ae$STUDYID)
)

study_ids

# 3. Validate sequence numbers

# Check LB
lb_duplicate_keys <- lb %>%
  count(STUDYID, USUBJID, LBSEQ) %>%
  filter(n > 1)

# Check AE
ae_duplicate_keys <- ae %>%
  count(STUDYID, USUBJID, AESEQ) %>%
  filter(n > 1)

# Display results
nrow(lb_duplicate_keys)
nrow(ae_duplicate_keys)

sum(is.na(lb$LBSEQ))
sum(is.na(ae$AESEQ))

# all good!

# Reusable validation functions -------------------------------------------
# 4. Reusable validation functions

# Identify duplicate records based on specified key variables
check_duplicate_keys <- function(data,key_vars) {
  data %>% 
    count(across(all_of(key_vars)),name = "n") %>% 
    filter(n>1)
}

check_duplicate_keys_v2 <- function(data,key_vars) {
  data %>% 
    group_by(across(all_of(key_vars))) %>% 
    summarise(
      n = n(),
      .groups = "drop"
  ) %>% 
    filter(n>1)
  }

check_duplicate_keys(lb,c("USUBJID","LBTESTCD"))

check_duplicate_keys_v2(lb,c("USUBJID","LBTESTCD"))

identical(check_duplicate_keys_v2(lb,c("USUBJID","LBTESTCD")),
          check_duplicate_keys(lb,c("USUBJID","LBTESTCD")))

# Count missing values in a specified variable
count_missing <- function(data, variable) {
  
  sum(is.na(data[[variable]]))
  
}

count_missing(lb, "LBSEQ")
count_missing(ae, "AESEQ")
count_missing(dm, "USUBJID")

identical(dm[["USUBJID"]] ,dm$USUBJID)
