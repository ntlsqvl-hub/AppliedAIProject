# Disaster Equity Data Sources

Data sources for the core policy question: how federal disaster-recovery and
restoration mechanisms interact with pre-existing vulnerability in low-income
communities and communities of color.

All three sources below have been pulled and aggregated to state level. Raw
data and per-source notes live in `data/<source>/` (not tracked in git — see
`.gitignore` — files there are large, up to 417MB, and reproducible from the
documented URLs). The state-level outputs that *are* tracked live in
`aggregated/`, produced by `aggregate.R`.

---

## 1. OpenFEMA — federal disaster funding (calendar years 2017–2026)

**Status: pulled and aggregated.** Raw: `data/openfema/` (gitignored, see its README for exact filters). Aggregated: `aggregated/openfema_funding_by_state_2017_2026.csv`.

## 2. EJSCREEN — environmental justice / vulnerability indicators

**Status: pulled and aggregated.** Raw: `data/ejscreen/` (gitignored, 417MB, 243,023 block groups — see its README). Aggregated: `aggregated/ejscreen_by_state.csv`. Mirror maintained by Public Environmental Data Partners; original EPA tool and downloads were taken offline 2025-02-05.

## 3. CEJST — Climate and Economic Justice Screening Tool

**Status: pulled and aggregated.** Raw: `data/cejst/` (gitignored, 43MB, 74,134 tracts — see its README). Aggregated: `aggregated/cejst_by_state.csv`. Mirror maintained by Public Environmental Data Partners; original CEQ site is offline and unreachable.

---

## Next steps

1. Join the three `aggregated/*.csv` files on `state` to compare funding against vulnerability (column casing/spelling already verified consistent — see `aggregated/README.md`).
2. Decide on a headline framing metric (e.g., funding per capita in high-vulnerability states vs. low-vulnerability states).
