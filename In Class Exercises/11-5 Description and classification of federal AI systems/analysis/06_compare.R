# Compare hand codes (user) with model codes (Claude) on the 10 hand-coded systems.
x <- read.csv("data/processed/hand_coding_sheet.csv", stringsAsFactors = FALSE, colClasses = "character")
po <- mean(x$my_code == x$claude_code)
cats <- union(x$my_code, x$claude_code)
pe <- sum(sapply(cats, function(k) mean(x$my_code == k) * mean(x$claude_code == k)))
kappa <- (po - pe) / (1 - pe)
cat(sprintf("n=%d agree=%d percent=%.0f%% expected=%.2f kappa=%.2f\n",
            nrow(x), sum(x$my_code == x$claude_code), 100*po, pe, kappa))

reason <- c(
  DOT  = "Text names generative AI for documents across the enterprise and states no process time or cost problem, so 7 is not supported; one code required, 5.",
  FTC  = "Kept 3 (document review). Arguable: the only stated problem is time spent on manual document coding, which supports 7, and 'coding' documents could also mean 2.",
  NASA = "Kept 4 because the use case's concrete job is converting webinar speech to text; the analysis step is stated as later work. Your 8 is defensible given the project's analytics framing.")
x$claude_reasoning <- ifelse(x$agency %in% names(reason), reason[x$agency], "")
write.csv(x, "data/processed/hand_coding_sheet.csv", row.names = FALSE)
write.csv(x[, c("agency","use_case_name","my_code","claude_code","match","claude_reasoning")],
          "outputs/tables/coding_comparison.csv", row.names = FALSE)
