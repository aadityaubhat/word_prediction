# Load Required Libraries 
library(data.table)
library(dplyr)


# Load word frequencies ####

wordFreqFiles <- list.files("Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/counts/")

wordFreqFiles <- wordFreqFiles[grep("part*", wordFreqFiles)]

wordFreq <- data.frame(word = character(),
                       count = integer())

for(fileName in wordFreqFiles){
  this.file <- read.csv(paste0("Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/counts/",
                               fileName), header = F)
  
  names(this.file) <- c("word", "count")
  
  wordFreq <- rbind(wordFreq, this.file)
  
  rm(this.file)
}


# Load Bigrams ####

bigramFiles <- list.files("Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/bigrams/")

bigramFiles <- bigramFiles[grep("part*", bigramFiles)]

bigrams <- data.frame(bigram = character(),
                       count = integer())

for(fileName in bigramFiles){
  this.file <- read.csv(paste0("Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/bigrams/",
                               fileName), header = F)
  
  names(this.file) <- c("bigram", "count")
  
  bigrams <- rbind(bigrams, this.file)
  
  rm(this.file)
}



# Load Trigrams ####

trigramFiles <- list.files("Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/trigrams/")

trigramFiles <- trigramFiles[grep("part*", trigramFiles)]

trigrams <- data.frame(trigrams = character(),
                      count = integer())

for(fileName in trigramFiles){
  this.file <- read.csv(paste0("Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/trigrams/",
                               fileName), header = F)
  
  names(this.file) <- c("trigram", "count")
  
  trigrams <- rbind(trigrams, this.file)
  
  rm(this.file)
}


# Filter bigrams and trigrams with single occurence 
# bigrams
bigrams <- data.table(bigrams)

nrow(bigrams)
# 6360154

bigrams <- bigrams %>% filter(count > 4)

nrow(bigrams)
# 630075

hist(log(bigrams$count))

# trigrams
trigrams <- data.table(trigrams)

nrow(trigrams)
# 19381011

trigrams <- trigrams %>% filter(count > 4)

nrow(trigrams)
# 709065

hist(log(trigrams$count))


# Naive prediction

trigrams <- trigrams %>% arrange(desc(count))
bigrams <- bigrams %>% arrange(desc(count))

predict() <- function(phrase){
  phrase = "The Day is"
  phrase <- tolower(phrase)
  words <- unlist(strsplit(phrase, " "))
  
  # When phrase has two or more words
  lastTwoWords <- words[(length(words)-1):length(words)]
  
  trigramResult <- trigrams[grepl(paste0("^",paste(lastTwoWords, collapse = " " ), ".*"), trigrams$trigram),]
  
  trigramPredictions <- strsplit(trigramResult[1:3,]$trigram, " ")
}