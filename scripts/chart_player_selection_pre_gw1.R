# chart player selection pre gw1 

# libraries
library(arrow)
library(ggplot2)
library(geomtextpath)
library("artyfarty")       




# Load data 
df<-read_parquet("/Users/hhs/Dropbox/Bucket/fpl2526/data/players.parquet")


# Compute max - min by group
ranges <- df[, .(range = max(selected_by_percent, na.rm = TRUE) - min(selected_by_percent, na.rm = TRUE)),
             by = code][order(-range)]

top10<- head(ranges,10 )
top10_ids <- top10$code

ggplot( df[code%in%top10_ids],
        aes(x=time,y=selected_by_percent,color=second_name,label=web_name))+
  geom_textline(fontface=2,hjust=0.1,linewidth=1.5,size=5,key_glyph = "rect")+
  theme_dataroots()+
  theme(legend.position = "none",
        axis.title = element_text(size=18),
        axis.text = element_text(size=16),
       plot.title  = element_text(size=25))+
  ylim(0,40)+
  labs(y="Selected (%)",x="Friday August 15 - CET",
       title="Friday's biggest changes in FPL ownership")



