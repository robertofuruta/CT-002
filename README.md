# CT-002 — Statistical Programming Project - R

## Overview

CT-002 is an independent learning project focused on clinical statistical programming in R, using tools and packages from the **Pharmaverse ecosystem**.

The project aims to explore a practical clinical data workflow, from standardized clinical datasets to analysis-ready data and clinical reporting outputs.

It builds upon the foundational concepts explored in CT-001, with a stronger emphasis on industry-oriented tools, reproducibility, metadata, and quality control.

## Objectives

- Gain practical experience with Pharmaverse packages.
- Explore the CDISC standards, particularly SDTM and ADaM.
- Build analysis-ready datasets using `{admiral}`.
- Develop clinical tables, listings, and graphs (TLGs).
- Apply metadata and dataset validation concepts.
- Implement reproducible programming practices using Git, R, and automated tests.

## Planned Workflow

The project will progressively explore the following stages:

1. **Clinical source data:** import and inspect example clinical datasets.
2. **SDTM:** work with standardized clinical data structures.
3. **ADaM:** construct analysis-ready datasets, including ADSL and laboratory-related data.
4. **Statistical analysis:** perform descriptive and inferential analyses.
5. **Clinical reporting:** generate tables, listings, and graphs.
6. **Quality control:** implement programming checks, automated tests, and consistency assessments.
7. **Documentation and reproducibility:** document the workflow, dependencies, and programming decisions.

## Main Tools and Packages

| Tool / Package | Intended use |
|---|---|
| R | Statistical programming language |
| `{admiral}` | ADaM dataset construction |
| `{pharmaversesdtm}` | Example SDTM datasets |
| `{pharmaverseadam}` | Example ADaM datasets |
| `{metacore}` / `{metatools}` | Metadata management |
| `{rtables}` / `{tern}` | Clinical tables and reporting |
| `{xportr}` | Dataset metadata and XPT export |
| `{testthat}` | Automated testing |
| `{dplyr}` / `{ggplot2}` | Data manipulation and visualization |
| Git / GitHub | Version control and project collaboration |

## Repository Structure

The repository structure will evolve as the project develops. The planned organization is:

```text
CT-002/
├── R/
│   ├── 01_import.R
│   ├── 02_sdtm.R
│   ├── 03_adam.R
│   ├── 04_analysis.R
│   ├── 05_tlf.R
│   └── 06_qc.R
├── data/
│   ├── raw/
│   ├── sdtm/
│   └── adam/
├── output/
│   ├── tables/
│   ├── listings/
│   └── figures/
├── tests/
├── documentation/
├── README.md
├── .gitignore
└── CT-002.Rproj
```

## Data and Scope

This is an educational project using publicly available example datasets and/or simulated clinical data.

It is not a real clinical trial, does not contain real patient information, and is not intended for regulatory submission or use in clinical decision-making.

The project is intended to demonstrate programming concepts and familiarity with relevant tools. It does not constitute formal GxP validation or certification of any software or output.

## Learning Resources

- [Pharmaverse](https://pharmaverse.org/)
- [Pharmaverse Examples](https://pharmaverse.github.io/examples/)
- [admiral documentation](https://pharmaverse.github.io/admiral/)
- [Pharmaverse GitHub organization](https://github.com/pharmaverse)

## Project Status

**Status:** Initial setup

The repository is being developed incrementally. Each stage will be documented as the corresponding workflow is implemented.

---

*Independent educational project by Roberto Furuta.*
