# Blank hand-coding sheet: 10 random systems from the 31, with NO model codes.
s <- read.csv("data/processed/sample31.csv", stringsAsFactors = FALSE)
set.seed(1)
pick <- s[sort(sample(nrow(s), 10)), c("agency","use_case_name","problem_solved")]
pick$my_code <- ""; pick$confidence <- ""; pick$my_reason <- ""
write.csv(pick, "data/processed/hand_coding_sheet.csv", row.names = FALSE)
print(pick[, c("agency","use_case_name")])
