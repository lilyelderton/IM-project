## stop words ## 

# read in extra sets of stopwords
clinpsy_stopwords <- read_lines("stopwords/clin_psy_stopwords.txt") # common clinical psychiatry words 

numbers_stopwords <- read_lines("stopwords/numbers_stopwords.txt")  # numbers in data that aren't important 

add_stopwords <- c(clinpsy_stopwords, numbers_stopwords)
