#!/usr/bin/env Rscript

# Make weekly NFL predictions using previously trained models.

suppressPackageStartupMessages({
  library(tidyverse)
  library(googlesheets4)
  library(argparser)
  library(glue)
  library(caret)
  library(ranger)
  library(LiblineaR)
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
  filter(Week == week, !is.na(`Final Betting Line`))

models <- glue("{season}/trained-models.rds") %>%
  read_rds()

predictions_csv <- glue("{season}/weekly-predictions/week-{week}.csv")

predictions <- map2(
  models, names(models),
  ~ tibble("{.y}" := round(predict(.x, newdata = weekly_games), digits = 2))
) %>%
  bind_cols() %>%
  mutate(Road = weekly_games$Road, Home = weekly_games$Home) %>%
  select(Road, Home, everything())

write_csv(predictions, predictions_csv)

glue("Predictions stored at {predictions_csv}:")
system2("cat", args = glue("{predictions_csv}"))
