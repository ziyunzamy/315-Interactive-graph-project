terr = read.csv("terr.csv")
terr = as.data.frame(terr[,c("iyear", "imonth", "iday", "extended", "country_txt",
                             "region_txt", "provstate", "city", "latitude",
                             "longitude", "specificity", "crit1", "crit2", "crit3",
                             "doubtterr", "success", "suicide", "attacktype1_txt",
                             "targtype1_txt", "weaptype1_txt", "nkill", "nwound",
                             "property", "propvalue")])


set.seed(4)
idx = sample(1:nrow(terr),20000)
terr_sample = terr[idx,]

write.csv(terr_sample, file = "terr_sample.csv")
