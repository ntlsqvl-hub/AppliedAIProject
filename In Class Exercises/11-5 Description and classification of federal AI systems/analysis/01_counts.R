# Counts of AI use cases by agency, topic area, and development stage.
# Reads the raw CSV (never modified); writes tables and figures to outputs/.
suppressPackageStartupMessages({library(dplyr); library(ggplot2)})

raw <- read.csv("data/raw/2025_individually_reported_AI_use_cases.csv",
                stringsAsFactors = FALSE)
names(raw)[1] <- "agency"                       # strip BOM-prefixed header
d <- distinct(raw)                              # drop 2 exact duplicate rows
cat("raw rows:", nrow(raw), "| after dropping exact duplicates:", nrow(d), "\n")

d <- d %>% mutate(
  topic_area = case_when(
    topic_area == ""                      ~ "(not reported)",
    topic_area == "Administrative functions" ~ "Admin Functions",
    TRUE ~ topic_area),
  development_stage = ifelse(development_stage == "", "(not reported)", development_stage))

make_chart <- function(tab, var, title, file, h = 5) {
  tab[[var]] <- factor(tab[[var]], levels = rev(tab[[var]]))
  p <- ggplot(tab, aes(n, .data[[var]])) +
    geom_col(fill = "#2b6c8f") +
    geom_text(aes(label = n), hjust = -0.15, size = 3) +
    scale_x_continuous(expand = expansion(mult = c(0, 0.12))) +
    labs(title = title, x = "Number of use cases", y = NULL,
         caption = "Source: OMB 2025 Federal Agency AI Use Case Inventory (individually reported)") +
    theme_minimal(base_size = 11) + theme(panel.grid.major.y = element_blank())
  ggsave(file, p, width = 8, height = h, dpi = 200, bg = "white")
}

by_agency <- d %>% count(agency, agency_name, sort = TRUE)
by_topic  <- d %>% count(topic_area, sort = TRUE)
stage_order <- c("Pre-deployment", "Pilot", "Deployed", "Retired", "(not reported)")
by_stage  <- d %>% count(development_stage) %>%
  mutate(development_stage = factor(development_stage, levels = stage_order)) %>%
  arrange(development_stage) %>% mutate(development_stage = as.character(development_stage))

write.csv(by_agency, "outputs/tables/by_agency.csv", row.names = FALSE)
write.csv(by_topic,  "outputs/tables/by_topic_area.csv", row.names = FALSE)
write.csv(by_stage,  "outputs/tables/by_development_stage.csv", row.names = FALSE)

make_chart(by_agency, "agency", "AI use cases by agency", "outputs/figures/by_agency.png", h = 8)
make_chart(by_topic,  "topic_area", "AI use cases by topic area", "outputs/figures/by_topic_area.png", h = 6)
make_chart(by_stage,  "development_stage", "AI use cases by stage of development", "outputs/figures/by_development_stage.png", h = 3.5)

print(as.data.frame(by_stage)); print(as.data.frame(by_topic)); print(head(as.data.frame(by_agency), 12))
