## tokenise abstracts for ip and pni ##

# remove NA abstracts 
ip_data <- ip_data[!(ip_data$Abstract=="NA"),]

pni_data <- pni_data[!(pni_data$Abstract=="NA" | pni_data$Abstract=="n/a."),]

# tokenise words in abstract 
ip_abstracts_tidy <- ip_data %>% 
  mutate(Abstract = str_replace_all(Abstract, "\\s-", "_")) %>% 
  mutate(Abstract = str_replace_all(Abstract, "-", "_")) %>%      # these mutations help keep hyphenated words together 
  unnest_tokens(word, Abstract) %>%  # abstract to specify it is that being tokenised, not the title
  anti_join(add_stopwords_df) %>% 
  filter(is.na(as.numeric(word)))  # remove lone numbers 

pni_abstracts_tidy <- pni_data %>% 
  mutate(Abstract = str_replace_all(Abstract, "\\s-", "_")) %>% 
  mutate(Abstract = str_replace_all(Abstract, "-", "_")) %>%      # these mutations help keep hyphenated words together 
  unnest_tokens(word, Abstract) %>%  # abstract to specify it is that being tokenised, not the title
  anti_join(add_stopwords_df) %>% 
  filter(is.na(as.numeric(word)))  # remove lone numbers 

# find the most common words 
ip_abstracts_tidy %>% 
  count(word, sort = TRUE) # word counts stored in a tidy data frame 

pni_abstracts_tidy %>% 
  count(word, sort = TRUE)

# visualise the most common words
ip_abstracts_tidy %>% 
  count(word, sort = TRUE) %>% 
  filter(n > 50) %>% 
  mutate(word = reorder(word, n)) %>% 
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL)

pni_abstracts_tidy %>% 
  count(word, sort = TRUE) %>% 
  filter(n > 700) %>% 
  mutate(word = reorder(word, n)) %>% 
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL)
