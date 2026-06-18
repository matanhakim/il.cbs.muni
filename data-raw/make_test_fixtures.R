## Generate trimmed test fixtures for the file-reading paths that the bundled
## inst/extdata files cannot cover: a 2022+ municipal file (with the aggregate
## summary rows) and real locality / statistical-area index files.
##
## This is a maintainer script. It reads the full CBS files kept under
## diagnostics/data/ (git-ignored) and writes small workbooks to
## tests/testthat/fixtures/. It needs the `zip` package (an ordinary dependency
## of the dev toolchain) but no other writer - the minimal xlsx writer below is
## self-contained, so the script runs offline. Run it from the package root:
##
##   source("data-raw/make_test_fixtures.R")
##
## The cell grid is written verbatim, so the original header-row positions are
## preserved and the readers' per-year parameters apply unchanged.

DIAG <- "diagnostics/data"
OUT <- "tests/testthat/fixtures"
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)

# Minimal .xlsx writer. `sheets` is a named list of character matrices; empty or
# NA cells are written sparsely (omitted), which readxl reads back as NA.
write_xlsx_min <- function(sheets, path) {
  path <- file.path(normalizePath(dirname(path)), basename(path))
  col_letter <- function(i) {
    out <- character(0)
    while (i > 0) {
      out <- c(LETTERS[((i - 1) %% 26) + 1], out)
      i <- (i - 1) %/% 26
    }
    paste(out, collapse = "")
  }
  esc <- function(x) {
    x <- gsub("&", "&amp;", x, fixed = TRUE)
    x <- gsub("<", "&lt;", x, fixed = TRUE)
    gsub(">", "&gt;", x, fixed = TRUE)
  }
  n <- length(sheets)
  tmp <- tempfile("xlsx")
  dir.create(file.path(tmp, "_rels"), recursive = TRUE)
  dir.create(file.path(tmp, "xl", "_rels"), recursive = TRUE)
  dir.create(file.path(tmp, "xl", "worksheets"), recursive = TRUE)

  writeLines(
    c(
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">',
      '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>',
      '<Default Extension="xml" ContentType="application/xml"/>',
      '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>',
      paste0(
        '<Override PartName="/xl/worksheets/sheet',
        seq_len(n),
        '.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      ),
      "</Types>"
    ),
    file.path(tmp, "[Content_Types].xml"),
    useBytes = TRUE
  )
  writeLines(
    c(
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">',
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>',
      "</Relationships>"
    ),
    file.path(tmp, "_rels", ".rels"),
    useBytes = TRUE
  )
  writeLines(
    c(
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">',
      "<sheets>",
      paste0(
        '<sheet name="',
        esc(names(sheets)),
        '" sheetId="',
        seq_len(n),
        '" r:id="rId',
        seq_len(n),
        '"/>'
      ),
      "</sheets>",
      "</workbook>"
    ),
    file.path(tmp, "xl", "workbook.xml"),
    useBytes = TRUE
  )
  writeLines(
    c(
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">',
      paste0(
        '<Relationship Id="rId',
        seq_len(n),
        '" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet',
        seq_len(n),
        '.xml"/>'
      ),
      "</Relationships>"
    ),
    file.path(tmp, "xl", "_rels", "workbook.xml.rels"),
    useBytes = TRUE
  )
  for (s in seq_len(n)) {
    m <- as.matrix(sheets[[s]])
    rows_xml <- vapply(
      seq_len(nrow(m)),
      function(i) {
        cells <- character(0)
        for (j in seq_len(ncol(m))) {
          v <- m[i, j]
          if (is.na(v) || v == "") next
          cells <- c(
            cells,
            paste0(
              '<c r="',
              col_letter(j),
              i,
              '" t="inlineStr"><is><t xml:space="preserve">',
              esc(v),
              "</t></is></c>"
            )
          )
        }
        paste0('<row r="', i, '">', paste(cells, collapse = ""), "</row>")
      },
      character(1)
    )
    writeLines(
      c(
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
        '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">',
        "<sheetData>",
        rows_xml,
        "</sheetData>",
        "</worksheet>"
      ),
      file.path(tmp, "xl", "worksheets", paste0("sheet", s, ".xml")),
      useBytes = TRUE
    )
  }
  if (file.exists(path)) {
    file.remove(path)
  }
  old <- setwd(tmp)
  on.exit(setwd(old))
  zip::zipr(zipfile = path, files = c("[Content_Types].xml", "_rels", "xl"))
  invisible(path)
}

# Read the first `n` rows and `m` columns of one sheet, verbatim.
trim_sheet <- function(path, sheet, n = 18, m = 8) {
  raw <- readxl::read_excel(
    path,
    sheet = sheet,
    col_names = FALSE,
    col_types = "text",
    n_max = n
  )
  as.matrix(raw[, seq_len(min(m, ncol(raw))), drop = FALSE])
}

# 2022+ municipal file: sheet 2 = physical, sheet 3 = budget; sheet 1 is a
# throwaway so the sheet numbers line up with df_cbs_muni_params.
muni_src <- file.path(DIAG, "muni", "muni_2024.xlsx")
write_xlsx_min(
  list(
    toc = matrix("toc", 1, 1),
    physical = trim_sheet(muni_src, sheet = 2),
    budget = trim_sheet(muni_src, sheet = 3)
  ),
  file.path(OUT, "muni_2024_sample.xlsx")
)

# Real locality and statistical-area index files (SES 2019 tables 2 and 3).
# Tests read these with an explicit unit_type, since a trimmed file is too small
# for the row-count detector to recognise its level.
write_xlsx_min(
  list(sheet1 = trim_sheet(file.path(DIAG, "index", "ses_2019_t2.xlsx"), 1)),
  file.path(OUT, "ses_2019_yishuv_sample.xlsx")
)
write_xlsx_min(
  list(sheet1 = trim_sheet(file.path(DIAG, "index", "ses_2019_t3.xlsx"), 1)),
  file.path(OUT, "ses_2019_sa_sample.xlsx")
)

message("Wrote fixtures to ", OUT)
