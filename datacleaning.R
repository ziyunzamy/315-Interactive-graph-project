terr = read.csv("~/Desktop/36-315/Interactive Graphic Project/terr.csv")
terr.clean = terr[,c("iyear", "imonth", "iday", "extended", "country_txt",
                     "region_txt", "provstate", "city", "latitude",
                     "longitude", "specificity", "crit1", "crit2", "crit3",
                     "doubtterr", "success", "suicide", "attacktype1_txt",
                     "targtype1_txt", "weaptype1_txt", "nkill", "nwound",
                     "property", "propvalue")]
terr.clean$doubtterr = replace(terr.clean$doubtterr, which(terr.clean$doubtterr == 1), "YES")
terr.clean$doubtterr = replace(terr.clean$doubtterr, which(terr.clean$doubtterr == 0), "NO")
terr.clean$doubtterr = replace(terr.clean$doubtterr, which(terr.clean$doubtterr == -9), NA)
terr.clean$success = ifelse(terr.clean$success==0,"Fail","Success")
terr.clean$suicide = ifelse(terr.clean$suicide==0,"Not Suicide","Suicide")
terr.clean$weaptype1_txt = fct_relevel(fct_recode(terr.clean$weaptype1_txt, 
                                                  "Unknown" = "Unknown",
                                                  "Explosives" = "Explosives/Bombs/Dynamite",
                                                  "Incendiary" = "Incendiary", 
                                                  "Firearms" = "Firearms",
                                                  "Chemical" = "Chemical", 
                                                  "Fake Weapons" = "Fake Weapons",
                                                  "Melee" = "Melee",
                                                  "Sabotage Equipment" = "Sabotage Equipment",
                                                  "Vehicle" = "Vehicle (not to include vehicle-borne explosives, i.e., car or truck bombs)",
                                                  "Radiological" = "Radiological",
                                                  "Other" = "Other",
                                                  "Biological" = "Biological"))
terr.clean$attacktype1_txt = fct_relevel(fct_recode(terr.clean$attacktype1_txt, 
                                                    "Assassination" = "Assassination",
                                                    "Kidnapping" = "Hostage Taking (Kidnapping)",
                                                    "Explosion" = "Bombing/Explosion", 
                                                    "Facility Attack" = "Facility/Infrastructure Attack",
                                                    "Armed Assault" = "Armed Assault", 
                                                    "Hijacking" = "Hijacking",
                                                    "Unknown" = "Unknown",
                                                    "Unarmed Assault" = "Unarmed Assault",
                                                    "Barricade" = "Hostage Taking (Barricade Incident)"))
write.csv(terr.clean,"terr.clean.csv")