setwd("C:\\users\\administrator\\Documents\\")
# remotes::install_github("wiscostret/fplscrapR")

library(fplscrapR)
library(data.table)

ids <- read.csv("player_ids.csv")$fplids
n_ids <- length(ids)

df <- rbindlist(lapply(seq_along(ids), function(j) {
  i <- ids[j]
  x <- tryCatch(get_entry_player_picks(i, 1), error = function(e) NULL)
  x <- if (is.data.frame(x) || data.table::is.data.table(x)) x else x$picks
  if (is.null(x) || !NROW(x)) return(NULL)
  
  setDT(x)
  setnames(x, make.names(names(x), unique = TRUE))
  x[, `:=`(gw = 1L, fpl_entry_id = as.integer(i))]
  
  # --- Progress print ---
  pct <- round(j / n_ids * 100, 1)
  message(sprintf("Progress: %d/%d (%.1f%%)", j, n_ids, pct))
  # ----------------------
  
  x
}), use.names = TRUE, fill = TRUE)

if (nrow(df)) arrow::write_parquet(df, "fpl_teams_gw1.parquet")
