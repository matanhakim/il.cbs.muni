## Generate trimmed test fixtures for the file-reading paths that the bundled
## inst/extdata files cannot cover: a 2022+ municipal file (with the aggregate
## summary rows) and real locality / statistical-area index files.
##
## This is a maintainer script. It reads the full CBS files kept under
## diagnostics/data/ (git-ignored) and writes small workbooks to
## tests/testthat/fixtures/ with `writexl`. Run it from the package root:
##
##   source("data-raw/make_test_fixtures.R")
##
## Each sheet is written so that the original cell grid is preserved: the file's
## first (title) row carries placeholder names and rows 2+ are the real rows, so
## the header rows keep their original positions and the readers' per-year
## parameters apply unchanged.

if (!requireNamespace("writexl", quietly = TRUE)) {
  stop("`writexl` is required to (re)generate the fixtures; install it first.")
}

DIAG <- "diagnostics/data"
OUT <- "tests/testthat/fixtures"
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)

# Read the first `n` rows and `m` columns of one sheet, verbatim, then reshape so
# `writexl::write_xlsx()` re-creates the same grid. write_xlsx writes the column
# names as row 1, so we move the original row 1 (a title row, never a header row)
# into the names and keep rows 2+ as the body. Names must be unique and
# non-empty for writexl, hence the placeholder + make.unique().
trim_sheet <- function(path, sheet, n = 18, m = 8) {
  raw <- readxl::read_excel(
    path,
    sheet = sheet,
    col_names = FALSE,
    col_types = "text",
    n_max = n
  )
  raw <- raw[, seq_len(min(m, ncol(raw))), drop = FALSE]
  nm <- as.character(unlist(raw[1, ]))
  nm[is.na(nm) | nm == ""] <- "x"
  body <- raw[-1, , drop = FALSE]
  names(body) <- make.unique(nm)
  body
}

# 2022+ municipal file: sheet 2 = physical, sheet 3 = budget; sheet 1 is a
# throwaway so the sheet numbers line up with df_cbs_muni_params.
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
# Tests read these with an explicit unit_type, since a trimmed file is too small
# for the row-count detector to recognise its level.
writexl::write_xlsx(
  list(sheet1 = trim_sheet(file.path(DIAG, "index", "ses_2019_t2.xlsx"), 1)),
  file.path(OUT, "ses_2019_yishuv_sample.xlsx")
)
writexl::write_xlsx(
  list(sheet1 = trim_sheet(file.path(DIAG, "index", "ses_2019_t3.xlsx"), 1)),
  file.path(OUT, "ses_2019_sa_sample.xlsx")
)

message("Wrote fixtures to ", OUT)
