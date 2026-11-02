
library(tidyverse)
library(pharmaversesdtm)
data()

#demographic
glimpse(dm)

#lab data
glimpse(lb)

#adverse events
glimpse(ae)

dm %>% summarize(
  total_participants = n_distinct(USUBJID)
)

dm %>% group_by(SEX) %>% 
  summarize(
    n = n(),
    avg_age = mean(AGE)
    ) %>% 
  ungroup()

lb %>% group_by(USUBJID) %>% 
  summarise(
    n = n()
      ) %>% 
  arrange(n) %>% ungroup()

# 1 person example 01-705-1018
USUBJID_0 <- lb %>% filter(USUBJID == "01-705-1018")

USUBJID_0 %>% group_by(LBTESTCD) %>% 
  summarise(
    n = n(),
    datetime = LBDTC
  )  %>% arrange(datetime) %>% ungroup()

lb %>%  group_by(USUBJID,LBTESTCD) %>% 
  summarise(
    n = n()
  )  %>% arrange(-n) %>% ungroup()

# meaning there are people who did 12 test runs, and people who did only one

# did everyone did the same test?

lb_ALP <- lb %>%  filter(LBTESTCD=="ALP") %>%
  group_by(USUBJID,LBTESTCD) %>% 
  summarise(
    n = n()
  )  %>% arrange(-n) %>% ungroup()

dm_ALP <- dm %>% left_join(lb_ALP,by="USUBJID")

dm_ALP <- dm_ALP %>% arrange(LBTESTCD)

# meaning there are people who did 12 test runs, and people who did only one

count_na <- dm_ALP %>% filter(is.na(LBTESTCD)) %>% 
  select(USUBJID,ACTARM,LBTESTCD)

count_na
# A tibble: 52 × 3

lb_existance_check <- count_na %>% 
  inner_join(lb,by = "USUBJID")

glimpse(lb_existance_check)
#> glimpse(lb_existance_check)
#Rows: 0
#Columns: 25

######testing something similiar but easier
subjects_without_lb <- dm %>%
  anti_join(
    lb %>% distinct(USUBJID),
    by = "USUBJID"
  )

nrow(subjects_without_lb) 
#52


subjects_without_alp <- dm %>%
  anti_join(
    lb %>%
      filter(LBTESTCD == "ALP") %>%
      distinct(USUBJID),
    by = "USUBJID"
  )

nrow(subjects_without_alp)
#52


# which tests?
test_types <- lb %>% 
  distinct(LBTESTCD,LBTEST) %>%
  arrange(LBTESTCD)

glimpse(test_types)
# each lab test is one row (different test types)


?summarize
