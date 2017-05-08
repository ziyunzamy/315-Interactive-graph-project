library("tm")
library("SnowballC")

terr = read.csv("terr.csv")
terr$summaryString <- as.character(terr$summary)
stinglists <- unlist(strsplit(terr$summaryString, " "))

fileConn <- file("output.txt")
writeLines(stinglists, fileConn)
close(fileConn)

text <- readLines("output.txt")
docs <- Corpus(VectorSource(text))
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)

clean <- data.frame(text = sapply(docs, as.character), stringsAsFactors = FALSE)
clean_NA <- na.omit(clean)
clean_NA_v1 <- clean_NA[which(clean_NA!="" & clean_NA!=" "),]
length(clean_NA_v1)
freqs <- sample(seq(length(clean_NA_v1)))
result <- cbind(clean_NA_v1,freqs)
result <- result[order(freqs,decreasing = TRUE),]
length(result)
write.csv(result[1:500, ], file = "foo.csv")




