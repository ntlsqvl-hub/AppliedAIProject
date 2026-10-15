# State-level aggregates

Produced by `../aggregate.R` from the raw files in `../data/`. These are the
files meant to live in the repo; the raw sources they're built from are
excluded (see `../.gitignore`) because of size — see each raw source's own
README under `../data/<source>/` to re-fetch them.

## `openfema_funding_by_state_2017_2026.csv`

One row per state/territory, calendar years 2017–2026:
- `pa_federal_obligated`, `pa_records`, `pa_disasters` — Public Assistance totals
- `hma_federal_share`, `hma_obligated`, `hma_records` — Hazard Mitigation totals
- `total_federal_funding` — PA + HMA combined

## `ejscreen_by_state.csv`

One row per state/territory, population-weighted averages (weight = `ACSTOTPOP`,
each block group's population) rolled up from 243,023 census block groups:
- `population`, `block_groups` — total population and number of block groups in the state
- `demogidx_2_wtavg` — EJSCREEN's 2-factor demographic index (low income + people of color share)
- `lowincpct_wtavg`, `peopcolorpct_wtavg` — component shares
- `pm25_wtavg`, `ozone_wtavg`, `dslpm_wtavg` — raw environmental burden levels (not percentiles)
- `ej_index_*_wtavg` — EPA's own composite "EJ Index" (2-factor) for each environmental indicator, which combines the raw burden level with the demographic index

**Caveat**: `pm25_wtavg`, `ozone_wtavg`, and their EJ indexes are `NA` for several island territories (Puerto Rico, Hawaii, Guam, etc.) — EPA's EJSCREEN does not model these two indicators for non-contiguous areas, not a processing error here.

## `cejst_by_state.csv`

One row per state/territory, rolled up from 74,134 census tracts:
- `population`, `tracts`, `disadvantaged_tracts` — counts
- `pct_tracts_disadvantaged` — % of tracts flagged "Identified as disadvantaged" (unweighted, tract-count basis)
- `pct_population_disadvantaged` — % of the state's population living in a disadvantaged tract (population-weighted — the more policy-relevant figure of the two)
- `flood_risk_pctile_avg`, `pm25_pctile_avg`, `low_income_pctile_avg` — simple (unweighted) tract averages of three headline CEJST percentile indicators

**Caveat**: several percentile columns are `NA` for some territories where CEJST doesn't compute that indicator (e.g., flood risk and PM2.5 percentiles are frequently missing outside the 50 states + PR).

## General caveats (all three files)

- State name spelling/casing was spot-checked and matches across all three files (e.g. all three use `"Puerto Rico"`, not `"PUERTO RICO"`), so a direct join on `state` should work without renaming.
- OpenFEMA's two sub-datasets use different date bases (PA: declaration date; HMA: fiscal year) — see `../data/openfema/README.md`.
- EJSCREEN and CEJST are both third-party mirrors of data the federal government took offline in early 2025 — see `../data/ejscreen/README.md` and `../data/cejst/README.md` for provenance.
