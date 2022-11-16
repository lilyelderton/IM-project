## stop words ## 

# read in extra sets of stopwords
clinpsy_stopwords <- read_lines("stopwords/clin_psy_stopwords.txt") # common clinical psychiatry words 

numbers_stopwords <- read_lines("stopwords/numbers_stopwords.txt")  # numbers in data that aren't important

tidytext_stopwords <- as.vector(stop_words$word) # add stopwords from tidytext package as this is a much bigger list

add_stopwords <- c(clinpsy_stopwords, numbers_stopwords, tidytext_stopwords)

# make a dataframe so these words can be removed from dataframes
add_stopwords_df <- as.data.frame(add_stopwords)
colnames(add_stopwords_df) <- "word"  # need to match the col name with the other dataframe

# stopwords for full text 
# can see they are needed as they skew the top words in the articles 

full_stopwords <- c("research", "university", "including", 
                    "references", "data", "found", "evidence", 
                    "received", "potential", "model", "department", 
                    "authors", "role", "accepted", "article", "institute", 
                    "published", "time", "online", "national", "future", 
                    "recent", "levels", "due", "models", "risk", "methods", 
                    "shown", "observed", "test", "mechanisms", "relationship", 
                    "multiple", "biol", "tion", "supported", "support", "similar", 
                    "level", "information", "factor", "factors", "differences",
                    "author", "activity")

full_stopwords <- as.data.frame(full_stopwords)
colnames(full_stopwords) <- "term"


                                