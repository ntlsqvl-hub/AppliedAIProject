# Builds the "Data at a glance" table shown on the project home page.
# Counts are computed from the actual data files each time this is run,
# rather than hardcoded, so the figure stays accurate as data is updated.
suppressPackageStartupMessages({
  library(dplyr)
  library(gridExtra)
  library(grid)
})

# Run this script with the repo root as the working directory, e.g.:
#   cd /path/to/AppliedAIProject && Rscript docs/scripts/make_overview_table.R
repo_root <- getwd()

count_lines <- function(path) {
  if (!file.exists(path)) return(NA_integer_)
  length(readLines(path, warn = FALSE))
}

count_csv_rows <- function(path) {
  n <- count_lines(path)
  if (is.na(n)) NA_integer_ else n - 1L  # minus header
}

overview <- tibble::tribble(
  ~Dataset, ~Source, ~`Time range`, ~Records, ~Granularity,

  "FEMA Public Assistance", "OpenFEMA API",
  "2017-2026",
  count_lines(file.path(repo_root, "disaster_equity_data/data/openfema/pa_2017_2026_raw.jsonl")),
  "Project / disaster",

  "FEMA Hazard Mitigation", "OpenFEMA API",
  "2017-2026",
  count_lines(file.path(repo_root, "disaster_equity_data/data/openfema/hma_2017_2026_raw.jsonl")),
  "Subapplication",

  "CEJST (vulnerability)", "PEDP mirror (v2.0)",
  "Current",
  count_csv_rows(file.path(repo_root, "disaster_equity_data/data/cejst/2.0-communities.csv")),
  "Census tract",

  "EJSCREEN (environmental justice)", "Harvard Dataverse (v4.0)",
  "2024",
  count_csv_rows(file.path(repo_root, "disaster_equity_data/data/ejscreen/EJSCREEN_2024_BG_with_AS_CNMI_GU_VI.csv")),
  "Census block group",

  "Federal Register (EPA rules)", "Federal Register API",
  "2025",
  count_csv_rows(file.path(repo_root, "federal_register_extreme_weather/federal_register_extreme_weather_epa.csv")) +
    count_csv_rows(file.path(repo_root, "federal_register_extreme_weather/federal_register_community_epa.csv")),
  "Rule / Proposed Rule",

  "State case-study documents", "GAO, legislative & agency records",
  "2017-2026",
  62L,
  "Document (6 states)"
) %>%
  mutate(Records = format(Records, big.mark = ",", trim = TRUE))

dir.create(file.path(repo_root, "docs/assets"), showWarnings = FALSE, recursive = TRUE)
readr::write_csv(overview, file.path(repo_root, "docs/assets/data_overview.csv"))

# ---- Render as a styled table image for the home page ----

header_fill <- "#2f6b3a"   # dark green, matches the site navbar
row_fill_a <- "#f3f9f1"    # light green, matches the site background
row_fill_b <- "#ffffff"

n_row <- nrow(overview)
fills <- rep(c(row_fill_a, row_fill_b), length.out = n_row)

tt <- ttheme_minimal(
  core = list(
    fg_params = list(fontsize = 11, hjust = 0, x = 0.02),
    bg_params = list(fill = fills, col = "grey85", lwd = 0.5)
  ),
  colhead = list(
    fg_params = list(fontsize = 11, fontface = "bold", col = "white", hjust = 0, x = 0.02),
    bg_params = list(fill = header_fill, col = NA)
  ),
  padding = unit(c(10, 6), "mm")
)

g <- tableGrob(overview, rows = NULL, theme = tt)
# column widths must sum to 1; widen Dataset/Source, narrow Time range/Records
g$widths <- unit(c(0.27, 0.27, 0.13, 0.11, 0.22), "npc")

png(file.path(repo_root, "docs/assets/data_overview.png"), width = 11, height = 2.7, units = "in", res = 220, bg = "white")
grid.arrange(g)
dev.off()

cat("Saved docs/assets/data_overview.csv and docs/assets/data_overview.png\n")
print(overview)
