## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

* Local Windows install, R 4.5.2
* win-builder (devel and release) - to be run before submission
* GitHub Actions (ubuntu-latest, windows-latest, macOS-latest), R release and devel - to be configured
* rhub::check_for_cran() - to be run before submission

## Submission notes

This is the first submission of il.cbs.muni to CRAN.

The package provides utility functions for working with Israeli Central Bureau of Statistics (CBS) municipal data. It helps analysts handle quirks in CBS data formats, harmonize IDs across different years, and combine data from multiple sources.

All functions include:
- Comprehensive input validation with informative error messages
- Full documentation with examples
- Unit tests (126 tests with 100% pass rate)

The package depends on common tidyverse packages (dplyr, stringr, tidyr, readxl) and uses rlang for error handling.

## Downstream dependencies

There are currently no downstream dependencies for this package.
