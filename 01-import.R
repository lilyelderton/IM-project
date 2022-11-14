## Read in PDF files ##

# create a vector pf PDF file names using list.files 
files <- list.files(path = "data-raw/pubmed-immunopsyc-set", 
                    pattern = "pdf$",       # only grab files ending with "pdf"
                    full.names = TRUE)      # needs to prevent errors in finding files

# use lapply to apply pdf_text to all files
ip_text <- lapply(files, pdf_text) 

# did that catch all documents? 
length(ip_pdf) # it got all 119!

# each element is now a vector that contains a PDF file
# the length of the vector corresponds to how many pages are in each PDF
lapply(ip_pdf, length)

# create a corpus 
ip_corp <- Corpus(URISource(files),                       # what files we want to use to create the corpus
                  readerControl = list(reader = readPDF)) # vector is a URI source
                                                          # function to read in the PDF text

# remove punctuation but keep hyphenated words 
ip_corp <- tm_map(ip_corp, removePunctuation, 
                  preserve_intra_word_dashes = TRUE, # important to keep these as important topic words (e.g. cytokines) have dashes
                  ucp = TRUE)  # looks for unicode punctuation
                               # need this because pdf_text preserves curly-quotes and em-dashes

# create a term document matrix 
ip.tdm <- TermDocumentMatrix(ip_corp, 
                             control = 
                               list(stopwords = TRUE, # remove stopwords
                                    tolower = TRUE,   # make lowercase
                                    stemming = FALSE, # don't reduce words to their stems
                                    removeNumbers = FALSE)) %>%  # don't remove numbers here because some are still needed 
  gofastr::remove_stopwords(stopwords = add_stopwords) # need to remove unimportant numbers and words so they don't skew analysis 

# create a document term matrix 
ip.dtm <- DocumentTermMatrix(ip_corp, 
                             control = 
                               list(stopwords = TRUE, 
                                    tolower = TRUE,   
                                    stemming = FALSE, 
                                    removeNumbers = FALSE)) %>% 
  gofastr::remove_stopwords(stopwords = add_stopwords)

# create tidy dataframe 
ip_tidy <- tidy(ip.dtm)


