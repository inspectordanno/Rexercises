# text analysis with the mallet tool for extracting topic models using Latent Dirichlet Allocation (LDA)
# for background, code & tutorials go to http://mallet.cs.umass.edu/

#install.packages("mallet")
library(mallet)

# load our sample text corpus: a selection of 311 citizen complaint messages
# important: our text has to be character strings, not factor variables
cc <- read.csv("data/complaints.csv", stringsAsFactors = F)

# create a trainer, decide how many topics we want to have. 
# we store it in an object, because we will need it later
# (this value has to be tweaked to get best results)
# then we have to load document corpus into an instance of mallet 
# (mallet is a custom program that runs outside of R)

n <- 12
topic.model <- MalletLDA(num.topics = n)

mallet.instances <- mallet.import(
  id.array = row.names(cc),
  text.array = cc$description,
  stoplist.file = "data/stop_311.txt",    # this is a list of stopwords (separated by new lines) that will be ignored
  token.regexp = "\\p{L}[\\p{L}\\p{P}]+\\p{L}"   # the regular expression to break down our text into word-units (tokens)
)
topic.model$loadDocuments(mallet.instances)

## Get the vocabulary, and some statistics about word frequencies.
##  These may be useful in further curating the stopword list.
vocabulary <- topic.model$getVocabulary()
word.freqs <- mallet.word.freqs(topic.model)
word.freqs$term.freq.n <-
  word.freqs$term.freq / sum(word.freqs$term.freq) # normalize by total number of terms
word.freqs$doc.freq.n <-
  word.freqs$doc.freq / sum(word.freqs$doc.freq) # normalize by total number of terms in all documents

# now train the topic models with 200 iterations
topic.model$train(500)

## run through a few iterations where we pick the best topic for each token
topic.model$maximize(10)

## Get the probability of topics in documents and the probability of words in topics.
## By default, these functions return raw word counts. Here we want probabilities,
## so we normalize, and add "smoothing" so that nothing has exactly 0 probability.
doc.topics <-
  mallet.doc.topics(topic.model, smoothed = T, normalized = T)
topic.words <-
  mallet.topic.words(topic.model, smoothed = T, normalized = T)

## create a top word list
top.words <- data.frame()
for (i in 1:nrow(topic.words)) {
  tmp <-
    mallet.top.words(topic.model, topic.words[i, ], num.top.words = 10)
  tmp$topic <- i
  tmp$order <- row(tmp)[, 1]
  top.words <- rbind(top.words, tmp)
}
rm(i)
rm(tmp)

#visualize word clouds
#install.packages("wordcloud")
library(wordcloud)
pal <- brewer.pal(4, "Paired")

# plot each recognized topic as a wordcloud
# use back buttons to browse (or uncomment save command to save as pdf)
for (i in 1:n) {
  tmp <- top.words[top.words$topic == i, ]
  wordcloud(
    tmp$words,
    freq = tmp$weights,
    random.order = FALSE,
    rot.per = 0,
    colors = pal,
    scale = c(3, 1)
  )
  text(x = 0.5, y = 0.1, paste("Topic", i))
  #quartz.save(paste("out/",i,".pdf", sep = ""), type = "pdf")
}

top.w.freq <- merge(top.words, word.freqs, by = "words")

ggplot(data = top.w.freq, aes(x = weights, y = term.freq.n, label = words)) +
  geom_text() + 
  facet_wrap( ~ topic) + 
  scale_x_log10() + 
  scale_y_log10()

library(ggrepel)
ggplot(data = top.w.freq, aes(x = weights, y = doc.freq.n, label = words)) + 
  geom_point(alpha = 0.5) +
  geom_text_repel(box.padding = 0.1) + 
  facet_wrap( ~ topic) + scale_x_log10() + scale_y_log10()
