# Setting up the environment ####
# Load Required Libraries 
library(data.table)
library(dplyr)
library(data.table)


# # Load word frequencies ####
# 
# wordFreqFiles <- list.files("~/Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/counts/")
# 
# wordFreqFiles <- wordFreqFiles[grep("part*", wordFreqFiles)]
# 
# wordFreqFiles <- paste0("~/Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/counts/", wordFreqFiles)
# 
# lst <- lapply(wordFreqFiles, fread)
# wordFreq <- rbindlist(lst)
# names(wordFreq) <- c("word", "count")
# 
# 
# 
# # Load Bigrams ####
# 
# bigramFiles <- list.files("~/Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/bigrams/")
# 
# bigramFiles <- bigramFiles[grep("part*", bigramFiles)]
# 
# bigramFiles <- paste0("~/Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/bigrams/",
#                       bigramFiles)
# 
# lst <- lapply(bigramFiles, fread)
# bigrams <- rbindlist(lst)
# names(bigrams) <- c("bigram", "count")
# 
# 
# 
# 
# # Load Trigrams ####
# 
# trigramFiles <- list.files("~/Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/trigrams/")
# 
# trigramFiles <- trigramFiles[grep("part*", trigramFiles)]
# 
# trigramFiles <- paste0("~/Documents/rWorkspace/word_prediction/sparkWordCount/outputFiles/output/trigrams/", trigramFiles)
# 
# lst <- lapply(trigramFiles, fread)
# trigrams <- rbindlist(lst)
# names(trigrams) <- c("trigram", "count")
# 
# 
# 
# 
# # Data Cleanning and Processing ####
# # Filter wordFreq, bigrams and trigrams
# 
# 
# # bigrams
# bigrams <- data.table(bigrams)
# 
# nrow(bigrams)
# # 18400306
# 
# bigrams <- bigrams %>% filter(count > 15)
# 
# nrow(bigrams)
# # 518022
# 
# hist(log(bigrams$count))
# 
# # trigrams
# trigrams <- data.table(trigrams)
# 
# nrow(trigrams)
# # 54104697
# 
# trigrams <- trigrams %>% filter(count > 15)
# 
# nrow(trigrams)
# # 438143
# 
# hist(log(trigrams$count))
# 
# save(trigrams, file ="trigrams.rda")
# save(bigrams, file = "bigrams.rda")
# save(wordFreq, file ="wordFreq.rda")

# Load Processed Data
load("wordFreq.rda")
load("trigrams.rda")
load("bigrams.rda")

# Naive prediction ####

trigrams <- data.table(trigrams %>% arrange(desc(count)))
bigrams <- data.table(bigrams %>% arrange(desc(count)))
wordFreq <- data.table(wordFreq %>% arrange(desc(count)))

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
  
  result <- result[1:3]

  result[is.na(result)] <- ""
  
  return(result[1:3])
}


## Function to predict the current word
##
predictThis <- function(phrase){
  phrase <- tolower(phrase)
  phrase <- "are you"
  words <- unlist(strsplit(phrase, " "))
  
  # When phrase has two or more words
  lastThreeWords <- words[(length(words)-2):length(words)]
  
  # If there are 3 or more words in the phrase 
  trigramResult <- ifelse(length(words) >= 3,
                          trigrams[grepl(paste0("^",paste(lastThreeWords, collapse = " " ), ".*"), trigrams$trigram),][1:3,]$trigram,
                          c(NA, NA, NA, NA, NA, NA, NA, NA, NA))
                          
  trigramResult <- unlist(strsplit(trigramResult, " ", fixed = ))[c(3,6,9)]
  
  # If there are 2 or more words in the phrase 
  bigramResult <- ifelse(length(words) >= 2,
                         bigrams[grepl(paste0("^",paste(lastThreeWords[(length(lastThreeWords)-1):length(lastThreeWords)], collapse = " "), ".*"), bigrams$bigram),][1:3,]$bigram,
                         c(NA, NA, NA, NA, NA, NA))
  
  bigramResult <- unlist(strsplit(bigramResult, " ", fixed = ))[c(2,4,6)]
  
  singleWordResult <- wordFreq[grepl(paste0("^",lastThreeWords[length(lastThreeWords)], ".*"), wordFreq$word),][1:3,]$word
}


# Testing ####
predictNext("")

predictNext("How are")

predictNext("Why not")
