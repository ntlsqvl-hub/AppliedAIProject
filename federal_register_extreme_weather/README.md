# Federal Register — EPA rules and proposed rules, 2025

Two separate full-text filters are tracked here, run against the same base query. Only the search term differs between them.

## Selection rule (shared across both files below)

Source: Federal Register API v1 (`https://www.federalregister.gov/api/v1/documents.csv`), a public, unauthenticated government API.

Common query conditions:
- **Document type**: `Rule` or `Proposed Rule` only (Notices and Presidential Documents excluded)
- **Publication date**: calendar year 2025 only (`2025-01-01` through `2025-12-31`)
- **Agency**: Environmental Protection Agency
- **Full-text term**: varies by filter (`extreme weather` or `community`) — see below
- This is a full-text relevance search, not a keyword/tag match — the Federal Register indexes document body text, so a document can match without the search term appearing verbatim in its title or abstract.
- Each query was paginated with `per_page=1000`, which returned the full result set in a single request in both cases; totals were cross-checked against the API's own `count` field.

---

## Filter 1: term = "extreme weather"

### File: `federal_register_extreme_weather_epa.csv`

- **Pulled**: 2026-10-14
- **Total documents matched**: 19
- Query URL used:
```
https://www.federalregister.gov/api/v1/documents.csv?conditions[term]=extreme%20weather&conditions[type][]=RULE&conditions[type][]=PRORULE&conditions[publication_date][gte]=2025-01-01&conditions[publication_date][lte]=2025-12-31&conditions[agencies][]=environmental-protection-agency&per_page=1000
```

---

## Filter 2: term = "community"

### File: `federal_register_community_epa.csv`

- **Pulled**: 2026-10-14
- **Total documents matched**: 128
- Query URL used:
```
https://www.federalregister.gov/api/v1/documents.csv?conditions[term]=community&conditions[type][]=RULE&conditions[type][]=PRORULE&conditions[publication_date][gte]=2025-01-01&conditions[publication_date][lte]=2025-12-31&conditions[agencies][]=environmental-protection-agency&per_page=1000
```

---

## Column reference (both files)

| Column | Description |
|---|---|
| `document_number` | Federal Register document ID (unique identifier) |
| `publication_date` | Date published in the Federal Register (YYYY-MM-DD) |
| `agency_names` | Issuing agency |
| `title` | Document title |
| `abstract` | Official abstract/summary text |
| `html_url` | Source link — full document on federalregister.gov |
| `pdf_url` | Source link — official PDF (hosted on govinfo.gov) |

## Caveats

- The "extreme weather" filter supersedes an earlier, broader version of that dataset which covered all document types (including Notices) since 2010 (343 matches). Narrowing to Rule/Proposed Rule and 2025 only drops that to 19.
- Each term is treated as a full-text relevance search, not a controlled vocabulary or exact-phrase tag — no independent verification was done that every matched document is substantively *about* extreme weather or community topics (vs. an incidental mention). "Community" in particular is a common, generic word in regulatory text (e.g., "community water system," "community right-to-know"), so its 128 matches likely span many unrelated program areas — treat this filter as a broad net, not a precise one.
