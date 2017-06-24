# Setting up the environment ####
# Load Required Libraries 
library(data.table)
library(dplyr)
library(data.table)


# Load word frequencies ####

wordFreqFiles <- list.files("Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/counts/")

wordFreqFiles <- wordFreqFiles[grep("part*", wordFreqFiles)]

wordFreqFiles <- paste0("Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/counts/", wordFreqFiles)

lst <- lapply(wordFreqFiles, fread)
wordFreq <- rbindlist(lst)
names(wordFreq) <- c("word", "count")



# Load Bigrams ####

bigramFiles <- list.files("Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/bigrams/")

bigramFiles <- bigramFiles[grep("part*", bigramFiles)]

bigramFiles <- paste0("Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/bigrams/",
                      bigramFiles)

lst <- lapply(bigramFiles, fread)
bigrams <- rbindlist(lst)
names(bigrams) <- c("bigram", "count")




# Load Trigrams ####

trigramFiles <- list.files("Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/trigrams/")

trigramFiles <- trigramFiles[grep("part*", trigramFiles)]

trigramFiles <- paste0("Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/trigrams/", trigramFiles)

lst <- lapply(trigramFiles, fread)
trigrams <- rbindlist(lst)
names(trigrams) <- c("trigram", "count")




# Data Cleanning and Processing ####
# Filter wordFreq, bigrams and trigrams 


# bigrams
bigrams <- data.table(bigrams)

nrow(bigrams)
# 6360154

bigrams <- bigrams %>% filter(count > 15)

nrow(bigrams)
# 630075

hist(log(bigrams$count))

# trigrams
trigrams <- data.table(trigrams)

nrow(trigrams)
# 19381011

trigrams <- trigrams %>% filter(count > 15)

nrow(trigrams)
# 709065

hist(log(trigrams$count))


# Naive prediction ####

trigrams <- data.table(trigrams %>% arrange(desc(count)))
bigrams <- data.table(bigrams %>% arrange(desc(count)))

predictNext <- function(phrase){
  phrase <- tolower(phrase)
  words <- unlist(strsplit(phrase, " "))
  
  # When phrase has two or more words
  lastTwoWords <- words[(length(words)-1):length(words)]
  
  # Assuming there are three or more matching trigrams
  trigramResult <- trigrams[grepl(paste0("^",paste(lastTwoWords, collapse = " " ), ".*"), trigrams$trigram),][1:3,]$trigram
  
  trigramResult <- unlist(strsplit(trigramResult, " ", fixed = ))[c(3,6,9)]
  
  bigramResult <- bigrams[grepl(paste0("^",lastTwoWords[length(lastTwoWords)], ".*"), bigrams$bigram),][1:3,]$bigram
  
  bigramResult <- unlist(strsplit(bigramResult, " ", fixed = ))[c(2,4,6)]
  
  result <- c(trigramResult, bigramResult)
  
  result <- unique(result[!is.na(result)])

  return(result[1:3])
}

# Testing ####
predictNext("")

predictNext("How are")

predictNext("Why not")
