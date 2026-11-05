# Fill the hand-coding sheet with the user's codes (as given) and add Claude's codes alongside.
x <- read.csv("data/processed/hand_coding_sheet.csv", stringsAsFactors = FALSE)
mine <- c("1","4","3","5/7","3","7","5","8","5","6")      # user's codes, top to bottom
stopifnot(nrow(x) == 10)
x$my_code <- mine
m <- read.csv("data/processed/sample31_coded.csv", stringsAsFactors = FALSE)
cb <- c("Data quality & anomaly detection"=1,"Classification & coding"=2,
        "Document review, extraction & research"=3,"Language & media processing"=4,
        "General-purpose generative assistant"=5,"Risk, security & screening"=6,
        "Workflow & case-processing automation"=7,"Analysis, modeling & forecasting"=8,
        "Unclear / insufficient text"=9)
x$claude_code <- as.character(cb[m$code[match(x$agency, m$agency)]])
x$match <- ifelse(x$my_code == x$claude_code, "yes", "no")
write.csv(x, "data/processed/hand_coding_sheet.csv", row.names = FALSE)
print(x[, c("agency","use_case_name","my_code","claude_code","match")], right = FALSE)
