## Generate trimmed test fixtures for the file-reading paths that the bundled
## inst/extdata files cannot cover: a 2022+ municipal file (aggregate summary
## rows) and real locality / statistical-area index files.
##
## This is a maintainer script. It needs `writexl` and the full CBS files kept
## under diagnostics/data/ (git-ignored). Run it from the package root with an
## internet connection so `writexl` can be installed if missing:
##
##   source("data-raw/make_test_fixtures.R")
##
## It writes small workbooks to tests/testthat/fixtures/. The header rows are
## preserved exactly; only the leading (non-header) title row is replaced with
## placeholder names so `writexl` accepts them. After generating, add tests in
## tests/testthat/ that read them via `testthat::test_path("fixtures", ...)` and
## assert: for the muni fixture, that the default drop yields fewer rows than
## `keep_summary_rows = TRUE` and that every kept authority symbol is non-empty;
## for the index fixtures, that `attr(df, "unit_type")` matches and the expected
## column names appear.

if (!requireNamespace("writexl", quietly = TRUE)) {
  install.packages("writexl")
}

DIAG <- "diagnostics/data"
OUT <- "tests/testthat/fixtures"
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)

# Read the first `n` rows and `m` columns of one sheet, then reshape so that
# writexl re-creates the same cell grid: the first row becomes the (placeholder)
# column names and the remaining rows become the body. Header rows therefore
# keep their original positions in the written file.
trim_sheet <- function(path, sheet, n = 16, m = 8) {
  raw <- readxl::read_excel(
    path,
    sheet = sheet,
    col_names = FALSE,
    col_types = "text",
    n_max = n
  )
  raw <- raw[, seq_len(min(m, ncol(raw))), drop = FALSE]
  body <- raw[-1, , drop = FALSE]
  names(body) <- paste0("v", seq_len(ncol(body)))
  body
}

# 2022+ municipal file: keep sheets 2 (physical) and 3 (budget); sheet 1 is a
# throwaway table of contents so the sheet numbers line up with df_cbs_muni_params.
muni_src <- file.path(DIAG, "muni", "muni_2024.xlsx")
writexl::write_xlsx(
  list(
    toc = data.frame(x = "toc"),
    physical = trim_sheet(muni_src, sheet = 2),
    budget = trim_sheet(muni_src, sheet = 3)
  ),
  file.path(OUT, "muni_2024_sample.xlsx")
)

# Real locality and statistical-area index files (SES 2019 tables 2 and 3).
# Tests should read these with an explicit `unit_type` because a trimmed file is
# too small for the row-count detector to recognise its level.
writexl::write_xlsx(
  list(sheet1 = trim_sheet(file.path(DIAG, "index", "ses_2019_t2.xlsx"), sheet = 1)),
  file.path(OUT, "ses_2019_yishuv_sample.xlsx")
)
writexl::write_xlsx(
  list(sheet1 = trim_sheet(file.path(DIAG, "index", "ses_2019_t3.xlsx"), sheet = 1)),
  file.path(OUT, "ses_2019_sa_sample.xlsx")
)

message("Wrote fixtures to ", OUT)
