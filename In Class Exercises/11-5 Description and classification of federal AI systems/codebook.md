# Codebook: what problem does the AI system solve?

**Unit of coding:** one AI use case (one row of `2025_individually_reported_AI_use_cases.csv`).
**Coded text:** the `problem_solved` field only (plus the system name when the text is too terse to read).
**Rule:** assign exactly **one** primary category: the main job the system does, not its topic area or technology. If two apply, choose the one the text spends the most words on; if still tied, take the first one listed below and note the ambiguity.

| # | Category | Definition | Example (system, agency) |
|---|---|---|---|
| 1 | **Data quality & anomaly detection** | Finds errors, outliers, or duplicates in data or case files so humans can review or fix them. | Anomaly detection model flagging "potentially erroneous data loads" (Anomaly Detection for Data Quality, CFTC) |
| 2 | **Classification & coding** | Assigns records to a fixed set of categories, codes, or topics. | Reads a job title and suggests occupation codes for human coders (OEWS Occupation Autocoder, DOL) |
| 3 | **Document review, extraction & research** | Helps staff find, read, summarize, extract from, or analyze documents and text (public comments, legal sources, policies, filings). | "Facilitate review of public comments" (DocketScope, DOI) |
| 4 | **Language & media processing** | Converts or interprets language or media: translation, speech-to-text, OCR, image or object recognition, media editing. | Machine translation post-edited by human translators (AI Input in Translation, State) |
| 5 | **General-purpose generative assistant** | A multi-task chat or drafting tool for employees, not tied to one document type or workflow. | Tools "to summarize, draft, and navigate operational records" (Gemini, NARA) |
| 6 | **Risk, security & screening** | Evaluates risk, threats, or the suitability of entities or systems, producing a flag or score that informs a decision. | Analyzing "counterparty risk profiles of mortgage issuers" (Counterparty Risk Anomaly Detection, HUD) |
| 7 | **Workflow & case-processing automation** | Automates or speeds a routine administrative step (intake, scoring, record creation, status updates) with the aim of saving time or cost. | Automating "data entry, case creation, document digitization, letter creation" (Automated Claims Processing, VA) |
| 8 | **Analysis, modeling & forecasting** | Statistical or machine-learning analysis used to understand a phenomenon, spot trends, or predict outcomes. | Forecasting "when sub-asset machines will need maintenance" (Sub-Asset Maintenance Model, Treasury) |
| 9 | **Unclear / insufficient text** | The text is blank, generic, or too short to tell what problem is solved. | (none in the 31-system sample) |

## Decision notes for borderline cases

- **1 vs 6:** Flagging bad *data* is category 1. Flagging a risky *entity, person, or system* is category 6.
- **2 vs 3:** Putting each record into a category is 2. Reading, summarizing, or pulling facts out of documents is 3.
- **3 vs 5:** A tool built for one kind of document or task (legal research, comment review) is 3. A do-everything employee assistant is 5.
- **7 vs others:** Use 7 only when the stated problem is process time or cost for a routine step. If the text mainly describes what is detected, classified, or translated, use that category instead.
- **Efficiency language** ("reduce manual workload") appears in many texts. It does not by itself make a system category 7.
