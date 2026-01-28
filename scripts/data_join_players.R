# data update players 

# libraries
library(data.table)
library(arrow)
# Set folder path
folder_path <- "/Users/hhs/Dropbox"

# List CSV files
file_list <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)

# Read and combine
df <- rbindlist(lapply(file_list, fread),fill = TRUE)


#Load
old<-read_parquet("/Users/hhs/Dropbox/Bucket/fpl2526/data/players.parquet")

# Save
dfcombined<-rbind(df,old)

dfcombined<-unique(dfcombined)

write_parquet(dfcombined,"/Users/hhs/Dropbox/Bucket/fpl2526/data/players.parquet")
