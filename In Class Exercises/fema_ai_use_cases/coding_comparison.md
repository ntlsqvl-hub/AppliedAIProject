# Hand coding vs. model coding (10 systems)

**Sample:** 10 systems drawn at random (seed 1) from the 31-system shared sample (first "Deployed" system per agency).
**Coders:** the user (hand, using `codebook.md`) and Claude (model, single pass; codes made before seeing the hand codes).
**Data:** `data/processed/hand_coding_sheet.csv` (also `outputs/tables/coding_comparison.csv`). Script: `analysis/06_compare.R`.

## Results

| Agency | System | Hand | Model | Match |
|---|---|---|---|---|
| CFTC | Anomaly Detection for Data Quality | 1 | 1 | yes |
| DHS | Babel | 4 | 4 | yes |
| DOI | DocketScope | 3 | 3 | yes |
| DOT | Enterprise Personal Productivity Assistant | 5/7 | 5 | **no** |
| FERC | Regulatory comment summarization | 3 | 3 | yes |
| FTC | Relativity Active Learning | 7 | 3 | **no** |
| NARA | Generative AI for Workplace Productivity | 5 | 5 | yes |
| NASA | ATCSCC Webinar Speech2Text and Analysis | 8 | 4 | **no** |
| NSF | ServiceNow Now Assist | 5 | 5 | yes |
| PBGC | IT Security Monitoring | 6 | 6 | yes |

- **Agreement:** 7 of 10 (70%).
- **Cohen's kappa:** 0.64 (chance-expected agreement 0.16). With n = 10 this is very unstable; treat it as descriptive, not as a reliability estimate.
- **Data-entry note:** the first two hand codes (CFTC, DHS) were initially entered in swapped rows and corrected by the coder. The table shows the corrected values.
- **DOT:** the hand code "5/7" has two categories, which the codebook does not allow. It is counted as a disagreement. If the coder resolves it to 5, agreement is 8 of 10.

## Reasoning on the three disagreements

**DOT: Enterprise Personal Productivity Assistant (hand 5/7, model 5).**
The text is "Secure enterprise AI-enabled document generative AI capabilities." It names a generative tool for documents across the enterprise and says nothing about a slow process or a cost to cut. Category 7 requires a stated process time or cost problem, so I coded 5. The system name ("Personal Productivity Assistant") points the same way. The one-code rule means 5/7 has to resolve to one of the two.

**FTC: Relativity Active Learning (hand 7, model 3).**
The text is "Manual document coding is very time consuming during the legal review process." The hand coder reads the stated problem as process time, which fits category 7. I coded 3 because the system supports legal document review. This is a real boundary case, and I would not call my code clearly better:
- The only content of the text is a time complaint, which supports 7.
- "Document coding" in legal review usually means tagging documents (for example responsive or not), which could also fit category 2.
- I kept 3 because the codebook says to code the main job of the system rather than the efficiency motive.

**NASA: ATCSCC Webinar Speech2Text and Analysis (hand 8, model 4).**
The text says the aim is "to convert live ATCSCC webinar meeting conversation to text, and then apply natural language processing to the converted text data for later analysis and review." I coded 4 because the concrete job described is speech-to-text. The hand coder's 8 weighs the project framing ("post operational analysis of Traffic Management") and the NLP analysis step. That reading is defensible. The codebook does not say how to code a two-stage pipeline, and that gap, not carelessness, produced the disagreement.

## Proposed codebook revisions (not applied)

These would resolve the disagreements, but I have not edited `codebook.md`, so the 31-system coding stays consistent with the version both coders used.

1. **Pipelines:** when a text describes a multi-step system, code the final stated purpose, not the first processing step. This would move NASA to 3 or 8.
2. **Efficiency vs. function (7):** make 7 a last resort, used only when no more specific category fits the task being sped up. This would move FTC to 2 or 3 and keep DOT at 5.
3. **Document coding (2 vs. 3):** state explicitly whether tagging documents in legal review counts as classification (2) or review (3).
4. **One code only:** require a single code, with a note field for the runner-up.

If revised, the whole 31-system sample should be recoded, not only the disagreements.
