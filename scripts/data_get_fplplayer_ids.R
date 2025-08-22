set.seed(1909)
fpllist<-sample(1:10000000,100000)
write.csv(data.frame(fplids=fpllist),"/Users/hhs/Dropbox/Bucket/fpl2526/data/player_ids.csv")

