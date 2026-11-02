# 01_import.R
# Import example SDTM datasets for CT-002

library(tidyverse)

# Load source datasets
dm <- pharmaversesdtm::dm
lb <- pharmaversesdtm::lb
ae <- pharmaversesdtm::ae

dim(dm)
#[1] 306  28
dim(lb)
#[1] 59580    23
dim(ae)
#[1] 1191   35

# Check subject identifiers

# 1. Check whether USUBJID exists in every dataset
stopifnot(
  "USUBJID" %in% names(dm),
  "USUBJID" %in% names(lb),
  "USUBJID" %in% names(ae)
)

# 2. Check for missing subject identifiers
stopifnot(
  !any(is.na(dm$USUBJID)),
  !any(is.na(lb$USUBJID)),
  !any(is.na(ae$USUBJID))
)

# 3. Check whether DM has one record per subject
stopifnot(
  nrow(dm) == n_distinct(dm$USUBJID)
)

# 4. Checking what happens if false
stopifnot(
  nrow(dm) == n_distinct(dm$DMDTC)
) #returned false

# Subjects in LB that are absent from DM
lb_subjects_not_in_dm <- lb %>%
  anti_join(dm %>% distinct(USUBJID), by = "USUBJID")

# Subjects in AE that are absent from DM
ae_subjects_not_in_dm <- ae %>%
  anti_join(dm %>% distinct(USUBJID), by = "USUBJID")

nrow(lb_subjects_not_in_dm) #0
nrow(ae_subjects_not_in_dm) #0

#######
# Save imported datasets

# Create output directory if it does not exist
dir.create(
  "data/raw",
  recursive = TRUE,
  showWarnings = FALSE
)

# Save datasets
saveRDS(dm, "data/raw/DM.rds")
saveRDS(lb, "data/raw/LB.rds")
saveRDS(ae, "data/raw/AE.rds")

# Importing back
dm_check <- readRDS("data/raw/DM.rds")
lb_check <- readRDS("data/raw/LB.rds")
ae_check <- readRDS("data/raw/AE.rds")

stopifnot(
  identical(dm, dm_check),
  identical(lb, lb_check),
  identical(ae, ae_check)
) #ok



