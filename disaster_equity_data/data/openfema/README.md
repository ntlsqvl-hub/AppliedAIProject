# OpenFEMA pull — calendar years 2017–2026

Pulled: 2026-10-14

## Public Assistance: `pa_2017_2026_raw.jsonl`

- Source: `https://www.fema.gov/api/open/v1/PublicAssistanceFundedProjectsSummaries`
- Filter: `declarationDate ge '2017-01-01T00:00:00.000Z' and declarationDate lt '2027-01-01T00:00:00.000Z'`
- Fields: `disasterNumber, declarationDate, incidentType, state, county, applicantName, federalObligatedAmount`
- Records: 50,071 (exhaustive, confirmed via `$inlinecount=allpages`)

## Hazard Mitigation: `hma_2017_2026_raw.jsonl`

- Source: `https://www.fema.gov/api/open/v2/HmaSubapplications`
- Filter: `fiscalYear ge 2017 and fiscalYear le 2026`
- Fields: `subapplicantState, subapplicantStateAbbreviation, federalShareAmount, totalObligatedAmount, totalSubapplicationAmount, fiscalYear, program, status, primaryHazard, disasterNumber`
- Records: 26,289 (exhaustive, confirmed via `$inlinecount=allpages`)
- Caveat: this dataset has no precise per-record obligation date, only fiscal year (Oct–Sep), so it doesn't line up exactly with PA's calendar-year `declarationDate` filter — both windows are close but not identical.

Both files are newline-delimited JSON (one record per line), unaggregated — state-level aggregation happens in a later analysis step.
