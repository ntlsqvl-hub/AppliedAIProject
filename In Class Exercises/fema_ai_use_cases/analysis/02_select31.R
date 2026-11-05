# First "Deployed" system per agency, in raw file order -> shared coding sample.
raw <- read.csv("data/raw/2025_individually_reported_AI_use_cases.csv", stringsAsFactors = FALSE)
names(raw)[1] <- "agency"
raw$file_row <- seq_len(nrow(raw))            # 1-based data row in the raw CSV
dep <- raw[raw$development_stage == "Deployed", ]
s <- dep[!duplicated(dep$agency), c("file_row","agency","agency_name","id","use_case_name","topic_area","development_stage","problem_solved")]
dir.create("data/processed", showWarnings = FALSE)
write.csv(s, "data/processed/sample31.csv", row.names = FALSE)
cat("agencies with any Deployed:", length(unique(dep$agency)), "of", length(unique(raw$agency)), "| sample rows:", nrow(s), "\n")
print(setdiff(unique(raw$agency), s$agency))
