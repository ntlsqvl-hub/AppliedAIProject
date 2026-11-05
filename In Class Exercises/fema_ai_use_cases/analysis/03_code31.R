# Model-assigned codes for the 31-system sample (see codebook.md).
# Coder: Claude (single pass, reading problem_solved text). Not yet validated by a second coder.
suppressPackageStartupMessages(library(dplyr))
s <- read.csv("data/processed/sample31.csv", stringsAsFactors = FALSE)

codes <- tibble::tribble(
  ~agency, ~code, ~confidence, ~note,
  "CFTC",  "Data quality & anomaly detection", "high", "Flags erroneous data loads",
  "DHS",   "Language & media processing", "high", "Text detection, translation, image recognition for analysts",
  "DOE",   "Document review, extraction & research", "medium", "Retrieves Lessons Learned for work planning",
  "DOI",   "Document review, extraction & research", "high", "Public comment review",
  "DOJ",   "Language & media processing", "medium", "OCR, image enhancement; text also mentions document formatting",
  "DOL",   "Classification & coding", "high", "Suggests SOC codes",
  "DOT",   "General-purpose generative assistant", "medium", "Text very terse",
  "EAC",   "Analysis, modeling & forecasting", "medium", "Trend review among grant applications",
  "EPA",   "Analysis, modeling & forecasting", "high", "Drivers of water quality",
  "FDIC",  "Workflow & case-processing automation", "medium", "Automated essay scoring to cut time and cost; could be read as screening of applicants",
  "FERC",  "Document review, extraction & research", "high", "Comment summarization and analysis",
  "FHFA",  "Analysis, modeling & forecasting", "high", "Modeling platform",
  "FRB",   "Classification & coding", "high", "Sorts complaints into topics",
  "FTC",   "Document review, extraction & research", "medium", "Legal document review; could be coding of documents",
  "GSA",   "Classification & coding", "high", "Taxonomy classification of transactions",
  "HHS",   "Document review, extraction & research", "medium", "Extracts and checks required info from free-text referrals; also completeness validation",
  "HUD",   "Risk, security & screening", "high", "Counterparty risk profiles",
  "NARA",  "General-purpose generative assistant", "high", "Employee productivity with generative AI",
  "NASA",  "Language & media processing", "high", "Speech-to-text then NLP",
  "NCUA",  "Data quality & anomaly detection", "high", "Flags anomalies in Call Report data",
  "NIGC",  "Document review, extraction & research", "medium", "Legal research; text very terse",
  "NRC",   "Document review, extraction & research", "high", "Retrieval and analysis of dense documents",
  "NSF",   "General-purpose generative assistant", "medium", "Now Assist: content generation and chatbots for service desk; text reads like product description",
  "OSHRC", "Document review, extraction & research", "medium", "Legal research; text very terse",
  "PBGC",  "Risk, security & screening", "low", "Very terse: IT security monitoring",
  "SEC",   "Document review, extraction & research", "medium", "Image recognition to speed review of 8-K filings",
  "SSA",   "Data quality & anomaly detection", "medium", "Flags duplicate cases",
  "STATE", "Language & media processing", "high", "Translation",
  "TREAS", "Analysis, modeling & forecasting", "high", "Predictive maintenance forecast",
  "USDA",  "Risk, security & screening", "low", "Market research and responsibility determination of vendors; could be document research",
  "VA",    "Workflow & case-processing automation", "high", "Automates claims processing steps"
)
stopifnot(nrow(codes) == 31, setequal(codes$agency, s$agency))
out <- s %>% left_join(codes, by = "agency")
write.csv(out, "data/processed/sample31_coded.csv", row.names = FALSE)
print(as.data.frame(count(out, code, sort = TRUE)))
print(table(out$confidence))
