# CT-002 — Statistical Programming R - Pharmaverse Clinical Project

## 1. Overview

CT-002 is an independent, fictional and educational clinical statistical programming project developed in R. It builds on the foundational workflow practiced in CT-001 and extends it by working with example clinical study data and the Pharmaverse ecosystem.

The project is intended to practice a programming workflow that moves from example SDTM data through validation and preparation, ADaM derivation, statistical analysis, Tables, Listings and Figures (TLGs), and quality control (QC).

> **Important:** This is an educational project using publicly available example datasets. It is not a real clinical study, does not contain real patient data, and is not a regulatory submission or a formally validated GxP system. Work completed so far should not be interpreted as full CDISC conformance validation.

## 2. Data and study domains

The current project uses example SDTM datasets provided by the `pharmaversesdtm` package:

| Domain | Description | Structure |
|---|---|---|
| DM | Demographics | Generally one record per subject |
| LB | Laboratory Test Results | Multiple records per subject |
| AE | Adverse Events | Multiple records per subject |

The datasets currently loaded for the project contain the following dimensions:

| Dataset | Rows | Columns |
|---|---:|---:|
| DM | 306 | 28 |
| LB | 59,580 | 23 |
| AE | 1,191 | 35 |

The study identifier observed across all three domains is `CDISCPILOT01`.

These are package-provided example data. The project is using them to learn how to inspect and validate SDTM-like domain structures before creating analysis datasets.

## 3. Repository structure

The intended repository structure is:

```text
CT-002/
├── R/
│   ├── 00_explore.R       # Exploratory learning and dataset inspection
│   ├── 01_import.R        # Import and basic source-data checks
│   ├── 02_sdtm.R          # SDTM domain validation and preparation
│   ├── 03_adam.R          # ADaM dataset derivation
│   ├── 04_analysis.R      # Statistical analyses
│   ├── 05_tlf.R           # Tables, listings and figures
│   └── 06_qc.R            # Quality control checks
├── data/
│   ├── raw/               # Imported example SDTM datasets
│   ├── sdtm/              # SDTM outputs, if generated
│   └── adam/              # Derived ADaM datasets
├── output/
│   ├── tables/
│   ├── listings/
│   └── figures/
├── tests/
├── documentation/
├── README.md
├── .gitignore
├── renv.lock
└── CT-002.Rproj
```

`R/00_explore.R` is an additional exploratory script; it does not change the numbering of the main pipeline. Data quality checks are being developed within the planned scripts, especially `R/02_sdtm.R` and later `R/06_qc.R`; no separate numbered data-quality script is part of the planned structure.

## 4. Environment and packages

The project is developed in R/RStudio and uses `renv` to record package dependencies and support reproducibility.

The main packages planned for the workflow include:

- `tidyverse`: data manipulation, import, reshaping, visualization and functional programming tools.
  - `dplyr`: filtering, grouping, joining and summarizing data.
  - `tidyr`: reshaping and handling tabular data.
  - `readr`: reading and writing delimited files.
  - `ggplot2`: graphics.
  - `stringr`, `forcats`, `purrr` and `tibble`: string handling, factor handling, iteration and tibble construction.
- `pharmaversesdtm`: example SDTM datasets.
- `admiral`: ADaM programming tools.
- `pharmaverseadam`: example ADaM datasets, where useful.
- `metacore` and `metatools`: metadata-oriented programming support.
- `xportr`: working with transport files.
- `rtables` and `tern`: table and analysis-output programming.
- `testthat`: automated tests.

The list describes the intended project toolset; package installation and use will be confirmed as the workflow progresses.

Open `CT-002.Rproj` in RStudio from the repository root. To restore dependencies recorded in the lockfile, run:

```r
renv::restore()
```

After installing or changing project packages, update the lockfile when appropriate:

```r
renv::snapshot()
renv::status()
```

## 5. Current progress

### 5.1 Repository and reproducibility setup

- Created the CT-002 repository and RStudio project.
- Established the planned project directory structure.
- Initialized `renv` and began configuring project dependencies.
- Created the initial Git history and feature branch workflow.

The current development branch for the SDTM work is:

```text
feature/02-sdtm
```

### 5.2 Exploratory work — `R/00_explore.R`

The example datasets were loaded from `pharmaversesdtm` and inspected with tidyverse tools, including:

```r
library(tidyverse)
library(pharmaversesdtm)

glimpse(dm)
glimpse(lb)
glimpse(ae)
```

The exploration covered the domain structures and the distinction between subject-level and observation-level data. For example, DM is generally one record per subject, whereas LB and AE can contain multiple records per subject.

Join and subject-coverage checks were also explored, including `left_join()`, `inner_join()` and `anti_join()`. These checks helped distinguish a subject with no record for a particular laboratory test from a subject with no laboratory records at all.

### 5.3 Import — `R/01_import.R`

The import script loads the package datasets and saves local RDS copies:

```r
dm <- pharmaversesdtm::dm
lb <- pharmaversesdtm::lb
ae <- pharmaversesdtm::ae

saveRDS(dm, "data/raw/DM.rds")
saveRDS(lb, "data/raw/LB.rds")
saveRDS(ae, "data/raw/AE.rds")
```

Basic checks implemented in the script include:

- Required `USUBJID` columns are present.
- `USUBJID` values are not missing.
- DM has one record per `USUBJID`.
- Subjects found in LB and AE also exist in DM, using anti-joins.
- Saved RDS files can be read back and compared with the imported objects.

These are initial structural and referential-integrity checks, not a complete SDTM validation.

### 5.4 SDTM validation — `R/02_sdtm.R` (in progress)

The SDTM script reads the imported RDS files and inspects the domains using `glimpse()` and `names()`.

Checks completed so far include:

- Domain identity: DM records have `DOMAIN == "DM"`, LB records have `DOMAIN == "LB"`, and AE records have `DOMAIN == "AE"`.
- Study identifier consistency: the three domains share the study identifier `CDISCPILOT01`.

A reusable duplicate-key helper is being developed using tidyverse functions. Its current pattern is:

```r
check_duplicate_keys <- function(data, key_vars) {
  data %>%
    group_by(across(all_of(key_vars))) %>%
    summarise(
      n = n(),
      .groups = "drop"
    ) %>%
    filter(n > 1)
}
```

For example, the helper can be called with the expected sequence key for a domain:

```r
lb_duplicate_keys <- check_duplicate_keys(
  lb,
  c("STUDYID", "USUBJID", "LBSEQ")
)

ae_duplicate_keys <- check_duplicate_keys(
  ae,
  c("STUDYID", "USUBJID", "AESEQ")
)
```

A separate exploratory call using `USUBJID` and `LBTESTCD` can identify repeated subject/test combinations, but such repetitions are not automatically errors: a subject may have the same test recorded at multiple visits or dates. The intended domain record key must be considered when interpreting duplicate results.

The SDTM script is still under development. The checks listed above do not establish full compliance with the CDISC SDTM Implementation Guide.

## 6. Planned workflow

The intended end-to-end workflow is:

```text
Example source data
       ↓
Import and basic checks
       ↓
SDTM inspection and validation
       ↓
ADaM derivation
       ↓
Statistical analysis
       ↓
Tables, Listings and Figures (TLGs)
       ↓
Independent QC and automated tests
       ↓
Documentation and reproducibility review
```

Planned scripts:

1. `R/00_explore.R` — exploratory inspection and learning.
2. `R/01_import.R` — load example data, save local copies and perform basic checks.
3. `R/02_sdtm.R` — validate domain identity, identifiers, sequence keys, missing values, dates and other relevant structural rules.
4. `R/03_adam.R` — derive analysis datasets using appropriate `admiral` workflows and documented derivation logic.
5. `R/04_analysis.R` — perform descriptive and inferential analyses appropriate to the example data and analysis objectives.
6. `R/05_tlf.R` — produce tables, listings and figures using suitable Pharmaverse tools.
7. `R/06_qc.R` — perform independent checks of datasets, derivations and outputs, supported by automated tests in `tests/`.

The exact analysis population, endpoints, derivations and outputs will be defined as the project develops. They should not be inferred solely from the current SDTM examples.

## 7. Next steps

The immediate next steps are to finish `R/02_sdtm.R` before moving to ADaM programming.

1. **Finish and test the duplicate-key helper.**
   - Run it with `STUDYID`, `USUBJID` and the relevant sequence variable (`LBSEQ` or `AESEQ`).
   - Inspect the returned rows and confirm whether any duplicate keys exist.
   - Check missing sequence values separately.

2. **Add missing-value and identifier checks.**
   - Check missing values in important identifiers and sequence variables.
   - Review subject references in LB and AE against DM.
   - Distinguish a missing value from a record that is not expected to exist.

3. **Review date variables.**
   - Inspect the `--DTC` variables, such as `DMDTC`, `LBDTC`, `AEDTC`, `AESTDTC` and `AEENDTC`.
   - Remember that SDTM date/time character variables should not be treated as ordinary numeric dates.
   - Identify missing or malformed values without assuming every date variable must be populated.

4. **Review domain-specific structure.**
   - Check relevant key variables and expected record structure for DM, LB and AE.
   - Interpret repeated subject/test combinations in context rather than treating all repetitions as duplicate records.

5. **Run the complete SDTM script from the project root.**
   - Confirm that it runs from beginning to end.
   - Review warnings and unexpected results.
   - Save only appropriate derived outputs under `data/sdtm/`, if the script produces any.

6. **Commit and integrate the completed SDTM work.**
   - Review `git status` and `git diff`.
   - Commit the finished changes on `feature/02-sdtm`.
   - Then merge the feature branch into `main` and push the updated branch.

7. **Begin `R/03_adam.R`.**
   - Identify the analysis dataset(s) needed.
   - Define the required variables, keys, populations and derivations before coding.
   - Use `admiral` where its functions fit the derivation requirements.

After ADaM derivation, proceed to analysis, TLG generation and QC.

## 8. Git workflow

Check the current branch and working tree:

```bash
git branch --show-current
git status
```

Review changes before staging:

```bash
git diff
```

Stage and commit the relevant files:

```bash
git add R/02_sdtm.R
git diff --cached
git commit -m "feat: add SDTM validation checks"
```

Push the feature branch:

```bash
git push -u origin feature/02-sdtm
```

When the SDTM work is complete and committed, integrate it into `main`:

```bash
git switch main
git pull
git merge feature/02-sdtm
git push
```

Then return to the feature branch for subsequent development:

```bash
git switch feature/02-sdtm
```

Always inspect `git status` and resolve any conflicts before continuing. Do not merge unfinished or uncommitted work.

## 9. Scope and limitations

CT-002 is a learning and portfolio project. It is intended to demonstrate familiarity with R, tidyverse, Pharmaverse tools, clinical data structures, programming workflow, version control and QC concepts.

It does not claim:

- Full SDTM or ADaM conformance.
- Complete implementation of a CDISC controlled terminology or metadata specification.
- Regulatory submission readiness.
- Formal software validation or GxP compliance.
- Clinical interpretation or decision-making based on the example data.

The scope and limitations of each implemented check and derivation should be documented as the project progresses.

---

**CT-002 — Independent educational Pharmaverse clinical programming project.**
