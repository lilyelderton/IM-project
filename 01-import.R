## Read in PDF files ##

# create a vector pf PDF file names using list.files 
files <- list.files(path = "data-raw/pubmed-immunopsyc-set", 
                    pattern = "pdf$",       # only grab files ending with "pdf"
                    full.names = TRUE)      # needs to prevent errors in finding files

# use lapply to apply pdf_text to all files
ip_pdf <- lapply(files, pdf_text) 

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

# create a document term matrix 
ip_full_dtm <- DocumentTermMatrix(ip_corp, 
                             control = 
                               list(stopwords = TRUE, # remove stopwords
                                    tolower = TRUE,   # make lowercase
                                    stemming = FALSE, # don't reduce words to their stems
                                    removeNumbers = FALSE)) %>%  # don't remove numbers here because some are still needed 
  gofastr::remove_stopwords(stopwords = add_stopwords) # need to remove unimportant numbers and words so they don't skew analysis 
  
# create tidy dataframe 
ip_full_tidy <- tidy(ip_full_dtm)

# write to file 
write.csv(ip_full_tidy, "data-tidy/ip_full_tidy.csv")

## Read in pubmed info for both immunopsychiatry and psychoneuroimmunology ##

# set topics for search on pubmed
ip_pm <- "immunopsychiatry OR immuno-psychiatry" # try to catch all that come up in pubmed
pni_pm <- "psychoneuroimmunology OR psycho-neuro-immunology" 

# search for topics on pubmed 
search_ip <- EUtilsSummary(ip_pm)
summary(search_ip) # collects 148 

search_pni <- EUtilsSummary(pni_pm)
summary(search_pni) # collects 3005
                    # this will have to be split into chunks for EUtils to cope with 
search_pni_1000 <- EUtilsSummary(pni_pm, retstart = 0, retmax = 1000)     
search_pni_2000 <- EUtilsSummary(pni_pm, retstart = 1000, retmax = 1000)
search_pni_3000 <- EUtilsSummary(pni_pm, retstart = 2000, retmax = 1005)

# use EUtislGet to fetch the actual data 
records_ip <- EUtilsGet(search_ip)

records_pni_1000 <- EUtilsGet(search_pni_1000)
records_pni_2000 <- EUtilsGet(search_pni_2000)
records_pni_3000 <- EUtilsGet(search_pni_3000)

# collect ID, year, title and abstract into a dataframe
ip_data <- data.frame("ID" = ArticleId(records_ip), 
                      "Year" = YearPubmed(records_ip), 
                      "Title" = ArticleTitle(records_ip), 
                      "Abstract" = AbstractText(records_ip))
ip_data$Topic <- "Immunopsychiatry" # need to mark that these are immunopsychiatry

pni_data_1000 <- data.frame("ID" = ArticleId(records_pni_1000), 
                            "Year" = YearPubmed(records_pni_1000), 
                            "Title" = ArticleTitle(records_pni_1000),
                            "Abstract" = AbstractText(records_pni_1000))

pni_data_2000 <- data.frame("ID" = ArticleId(records_pni_2000), 
                            "Year" = YearPubmed(records_pni_2000), 
                            "Title" = ArticleTitle(records_pni_2000), 
                            "Abstract" = AbstractText(records_pni_2000))

pni_data_3000 <- data.frame("ID" = ArticleId(records_pni_3000), 
                            "Year" = YearPubmed(records_pni_3000), 
                            "Title" = ArticleTitle(records_pni_3000), 
                            "Abstract" = AbstractText(records_pni_3000))

# pni will then need to be combined into one dataframe
pni_data <- rbind(pni_data_1000, pni_data_2000, pni_data_3000) # combine pni dfs
pni_data$Topic <- "Psychoneuroimmunology" # marks the topic as psychoneuroimmunology

# write to file 
write.csv(ip_data, "data-raw/ip_data_raw.csv")
write.csv(pni_data, "data-raw/pni_data_raw.csv")

