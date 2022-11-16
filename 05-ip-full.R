## look at whole ip papers ##

# find the most common words 
full_count <- ip_full_tidy %>% 
  count(term, wt = count, sort = TRUE) # need wt = count to add up all the times a word is used, not just paper it is in 

# plot the top 30 words 
full_count %>% 
  top_n(30) %>% 
  ggplot(aes(x = fct_reorder(term, n), y = n)) +
  geom_col(colour = "black",  fill = "steelblue2") +
  geom_text(vjust = 0.5, hjust = 1.5,
            aes(label = n), size = 3, fontface = "italic") +
  coord_flip() +
  scale_x_reordered() +
  scale_y_continuous(expand = c(0,0)) +
  scale_fill_manual(values = c("steelblue2","gray87")) +
  labs(y = "Count", 
       x = "Words") +
  theme_bw(base_size = 13) # a lot of these words are filler
                           # would tell us more if we removed them 

# remove stopwords then try again 
full_count %>% 
  anti_join(full_stopwords) %>% 
  top_n(30) %>% 
  ggplot(aes(x = fct_reorder(term, n), y = n)) +
  geom_col(colour = "black",  fill = "steelblue2") +
  geom_text(vjust = 0.5, hjust = 1.5,
            aes(label = n), size = 3, fontface = "italic") +
  coord_flip() +
  scale_x_reordered() +
  scale_y_continuous(expand = c(0,0)) +
  scale_fill_manual(values = c("steelblue2","gray87")) +
  labs(y = "Count", 
       x = "Words") +
  theme_bw(base_size = 13)  # this however may not be the best method 
                            # might be better to examine tf-id

# add term frequency and total words to ip_full_tidy
pdf_words <- ip_full_tidy %>% 
  count(document, term, wt = count, sort = TRUE)

total_words_pdf <- pdf_words %>% 
  group_by(document) %>% 
  summarise(total = sum(n))

pdf_words <- left_join(pdf_words, total_words_pdf)  
  
# examine zipf's law 
freq_by_rank <- pdf_words %>% 
  group_by(document) %>% 
  mutate(rank = row_number(), 
         `term frequency` = n/total) %>% 
  ungroup()

# calculate tf-idf and add to df
pdf_tf_idf <- pdf_words %>% 
  bind_tf_idf(term, document, n)

# look at words with high tf_idf = words that are important to a document 
pdf_tf_idf %>% 
  select(-total) %>% 
  arrange(desc(tf_idf))









