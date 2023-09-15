#!/usr/bin/env Rscript

# Make weekly NFL predictions using previously trained models.

suppressPackageStartupMessages({
  library(tidyverse)
  library(googlesheets4)
  library(argparser)
  library(glue)
})

SHEET_IDS <- c("2023" = "1dVnTsDZvxPkLAsYW6SPb1tOTNHe2bxtRAAwpPIAYwj0")

p <- arg_parser("Make weekly NFL predictions using previously trained models.")
p <- add_argument(p, "season", help = "The season to make predictions for.")
p <- add_argument(
  p, "week", type = "numeric", help = "The week to make predictions for."
)
argv <- parse_args(p)
season <- argv$season
week <- argv$week

gs4_deauth()
weekly_games <- read_sheet(SHEET_IDS[[season]]) %>%
  filter(Week == week, !is.na(`Final Betting Line`)) %>%
  select(`Final Betting Line`, `DAVE Difference`)

models <- glue("{season}/trained-models.rds") %>%
  read_rds()

predictions_csv <- glue("{season}/weekly-predictions/week-{week}.csv")

predictions <- map2(
  models, names(models), ~ tibble("{.y}" := predict(.x, newdata = weekly_games))
) %>%
  bind_cols()

write_csv(predictions, predictions_csv)

glue("Predictions stored at {predictions_csv}")