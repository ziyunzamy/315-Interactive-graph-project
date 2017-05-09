library("tm")
library("SnowballC")

terr = read.csv("terr_sample.csv")
# stinglists <- unlist(strsplit(terr$summaryString, " "))
# 
# fileConn <- file("output.txt")
# writeLines(stinglists, fileConn)
# close(fileConn)
# 
# text <- readLines("output.txt")
test <- as.character(terr$summary)[29]
docs <- Corpus(VectorSource(as.character(terr$summary)))


toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")
docs<- tm_map(docs,toSpace,"[^[:graph:]]")
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


dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)
typeof(d$word)

result <- cbind(as.character(d$word),d$freq)
result
write.csv(result[1:800, ], file = "foo.csv")


