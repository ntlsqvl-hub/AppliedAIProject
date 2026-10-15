suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(jsonlite)
  library(tidyr)
})

base <- "/Users/natalieesquivel/Downloads/AppliedAIProject/disaster_equity_data"
setwd(base)
dir.create("aggregated", showWarnings = FALSE)

## ---- OpenFEMA ----

pa <- stream_in(file("data/openfema/pa_2017_2026_raw.jsonl"), verbose = FALSE)
hma <- stream_in(file("data/openfema/hma_2017_2026_raw.jsonl"), verbose = FALSE)

pa_state <- pa %>%
  filter(!is.na(state), state != "") %>%
  group_by(state) %>%
  summarise(
    pa_federal_obligated = sum(federalObligatedAmount, na.rm = TRUE),
    pa_records = n(),
    pa_disasters = n_distinct(disasterNumber),
    .groups = "drop"
  )

hma_state <- hma %>%
  filter(!is.na(subapplicantState), subapplicantState != "") %>%
  group_by(state = subapplicantState) %>%
  summarise(
    hma_federal_share = sum(federalShareAmount, na.rm = TRUE),
    hma_obligated = sum(totalObligatedAmount, na.rm = TRUE),
    hma_records = n(),
    .groups = "drop"
  )

openfema_state <- full_join(pa_state, hma_state, by = "state") %>%
  mutate(across(where(is.numeric), ~replace_na(., 0))) %>%
  mutate(total_federal_funding = pa_federal_obligated + hma_federal_share) %>%
  arrange(desc(total_federal_funding))

write_csv(openfema_state, "aggregated/openfema_funding_by_state_2017_2026.csv")
cat("OpenFEMA aggregated:", nrow(openfema_state), "states/territories\n")

## ---- EJSCREEN ----

ej_cols <- cols_only(
  STATE_NAME = col_character(),
  ACSTOTPOP = col_double(),
  DEMOGIDX_2 = col_double(),
  LOWINCPCT = col_double(),
  PEOPCOLORPCT = col_double(),
  PM25 = col_double(),
  OZONE = col_double(),
  DSLPM = col_double(),
  D2_PM25 = col_double(),
  D2_OZONE = col_double(),
  D2_DSLPM = col_double(),
  D2_PNPL = col_double(),
  D2_PTSDF = col_double(),
  D2_UST = col_double(),
  D2_PWDIS = col_double()
)

ejscreen <- read_csv("data/ejscreen/EJSCREEN_2024_BG_with_AS_CNMI_GU_VI.csv",
                      col_select = names(ej_cols$cols), col_types = ej_cols)

wmean <- function(x, w) {
  ok <- !is.na(x) & !is.na(w) & w > 0
  if (!any(ok)) return(NA_real_)
  sum(x[ok] * w[ok]) / sum(w[ok])
}

ejscreen_state <- ejscreen %>%
  filter(!is.na(STATE_NAME), STATE_NAME != "", !is.na(ACSTOTPOP)) %>%
  group_by(state = STATE_NAME) %>%
  summarise(
    population = sum(ACSTOTPOP, na.rm = TRUE),
    block_groups = n(),
    demogidx_2_wtavg = wmean(DEMOGIDX_2, ACSTOTPOP),
    lowincpct_wtavg = wmean(LOWINCPCT, ACSTOTPOP),
    peopcolorpct_wtavg = wmean(PEOPCOLORPCT, ACSTOTPOP),
    pm25_wtavg = wmean(PM25, ACSTOTPOP),
    ozone_wtavg = wmean(OZONE, ACSTOTPOP),
    dslpm_wtavg = wmean(DSLPM, ACSTOTPOP),
    ej_index_pm25_wtavg = wmean(D2_PM25, ACSTOTPOP),
    ej_index_ozone_wtavg = wmean(D2_OZONE, ACSTOTPOP),
    ej_index_dslpm_wtavg = wmean(D2_DSLPM, ACSTOTPOP),
    ej_index_npl_wtavg = wmean(D2_PNPL, ACSTOTPOP),
    ej_index_tsdf_wtavg = wmean(D2_PTSDF, ACSTOTPOP),
    ej_index_ust_wtavg = wmean(D2_UST, ACSTOTPOP),
    ej_index_wdis_wtavg = wmean(D2_PWDIS, ACSTOTPOP),
    .groups = "drop"
  ) %>%
  arrange(desc(demogidx_2_wtavg))

write_csv(ejscreen_state, "aggregated/ejscreen_by_state.csv")
cat("EJSCREEN aggregated:", nrow(ejscreen_state), "states/territories\n")
rm(ejscreen); gc()

## ---- CEJST ----

cejst_raw <- read_csv("data/cejst/2.0-communities.csv", col_types = cols(.default = col_guess()))

name_map <- c(
  state = "State/Territory",
  population = "Total population",
  disadvantaged = "Identified as disadvantaged",
  flood_pctile = "Share of properties at risk of flood in 30 years (percentile)",
  pm25_pctile = "PM2.5 in the air (percentile)",
  low_income_pctile = "Adjusted percent of individuals below 200% Federal Poverty Line (percentile)"
)
cejst <- cejst_raw %>% rename(!!!name_map)

cejst_state <- cejst %>%
  filter(!is.na(state), state != "", !is.na(population)) %>%
  mutate(disadvantaged_pop = ifelse(isTRUE(disadvantaged) | disadvantaged %in% c("TRUE", "True", TRUE), population, 0)) %>%
  group_by(state) %>%
  summarise(
    population = sum(population, na.rm = TRUE),
    tracts = n(),
    disadvantaged_tracts = sum(disadvantaged %in% c(TRUE, "TRUE", "True"), na.rm = TRUE),
    pct_tracts_disadvantaged = 100 * disadvantaged_tracts / tracts,
    pct_population_disadvantaged = 100 * sum(disadvantaged_pop, na.rm = TRUE) / sum(population, na.rm = TRUE),
    flood_risk_pctile_avg = mean(flood_pctile, na.rm = TRUE),
    pm25_pctile_avg = mean(pm25_pctile, na.rm = TRUE),
    low_income_pctile_avg = mean(low_income_pctile, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(pct_population_disadvantaged))

write_csv(cejst_state, "aggregated/cejst_by_state.csv")
cat("CEJST aggregated:", nrow(cejst_state), "states/territories\n")
