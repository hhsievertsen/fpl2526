    library(fplr)
    library(fplscrapR)
    library(arrow)
    
    ids <- read.csv("/Users/hhs/Dropbox/Bucket/fpl2526/data/player_ids.csv")$fplids
    n <- length(ids)
    
    fav <- rep(NA_integer_, n)
    hist_list <- vector("list", n)
    league_list <- vector("list", n)
    season_list <- vector("list", n)
    
    need_cols <- c("event","points","rank","points_on_bench")
    fill_missing <- function(df, cols) {
      miss <- setdiff(cols, names(df))
      if (length(miss)) df[miss] <- NA
      df[cols]
    }
    
    for (k in seq_along(ids)) {
      i <- ids[k]
      ent <- try(get_entry(i), silent = TRUE)
      h   <- try(fpl_get_user_history(i), silent = TRUE)
      es  <- try(get_entry_season(i), silent = TRUE)
      
      if (!inherits(ent, "try-error") && !is.null(ent$favourite_team))
        fav[k] <- ent$favourite_team
      
      if (!inherits(h, "try-error") && !is.null(h) && nrow(h) > 0)
        hist_list[[k]] <- cbind(fplid = i, h[c("season_name","total_points","rank")])
      
      if (!inherits(ent, "try-error") && !is.null(ent$leagues$classic) && nrow(ent$leagues$classic) > 0) {
        lc <- ent$leagues$classic
        league_list[[k]] <- data.frame(fplid = i, leaguename = lc$name, leagueid = lc$id)
      }
      
      if (!inherits(es, "try-error") && !is.null(es) && nrow(es) > 0) {
        es <- fill_missing(es, need_cols)
        season_list[[k]] <- cbind(fplid = i, es)
      }
      
      pct <- sprintf("%.2f", 100 * k / n)
      cat(pct, "% done\n")
    }
    
    nz <- function(x) x[!vapply(x, is.null, logical(1L))]
    df_favourite    <- data.frame(fplid = ids, favourite_team = fav)
    df_history      <- if (length(nz(hist_list)))    do.call(rbind, nz(hist_list))    else data.frame()
    df_leagues      <- if (length(nz(league_list)))  do.call(rbind, nz(league_list))  else data.frame()
    df_entryseason  <- if (length(nz(season_list)))  do.call(rbind, nz(season_list))  else data.frame()
    
    write_parquet(df_favourite,   "/Users/hhs/Dropbox/Bucket/fpl2526/data/fplplayer_favourite_teams.parquet")
    write_parquet(df_history,     "/Users/hhs/Dropbox/Bucket/fpl2526/data/fplplayer_history.parquet")
    write_parquet(df_leagues,     "/Users/hhs/Dropbox/Bucket/fpl2526/data/fplplayer_mini_leauges.parquet")
    write_parquet(df_entryseason, "/Users/hhs/Dropbox/Bucket/fpl2526/data/fplplayer_entry_season.parquet")
