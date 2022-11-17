## look at whole ip papers ##

# find the most common words 
full_count <- ip_full_tidy %>% 
  count(term, wt = count, sort = TRUE) # need wt = count to add up all the times a word is used, not just paper it is in 

# plot the top 30 words 
full_count %>% 
  top_n(40) %>% 
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
  theme_bw(base_size = 13) # some of these words are filler
                           # would tell us more if we removed them 

# remove stopwords then try again 
full_count %>% 
  anti_join(full_stopwords) %>% 
  top_n(40) %>% 
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
  theme_bw(base_size = 13)  

# make a wordcloud 
wordcloud_fig <- wordcloud2(data = full_count, size = 1.6, 
           color = rep_len(c("darkslateblue", "slateblue", "royalblue",
                             "cornflowerblue", "steelblue"), 
                           nrow(full_count)))

# save graph (first to html, then in png) 
saveWidget(wordcloud_fig,"wordcloud.html",selfcontained = F)









