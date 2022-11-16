## compare word frequencies in the articles for ip to pni articles ## 

# find the most common words 
ip_abstracts_tidy %>% 
  count(word, sort = TRUE) # word counts stored in a tidy data frame 

pni_abstracts_tidy %>% 
  count(word, sort = TRUE) 

# combine the two dataframes
abstracts <- rbind( pni_abstracts_tidy, ip_abstracts_tidy) 

# plot facet wrap comparing top 20 words in ip and pni abstracts 
fig2 <- abstracts %>% 
  group_by(Topic) %>% 
  count(word, sort = TRUE) %>% 
  top_n(15) %>% 
  ungroup %>% 
  mutate(word = reorder_within(word, n, Topic)) %>% 
  ggplot(aes(x = word, y = n, fill = Topic)) +
  geom_col(show.legend = TRUE, colour = "black") +
  geom_text(vjust = 0.5, hjust = 1.5,
            aes(label = n), size = 3, fontface = "italic") +
  facet_wrap(~Topic, scales = "free") +
  coord_flip() +
  scale_x_reordered() +
  scale_y_continuous(expand = c(0,0)) +
  scale_fill_manual(values = c("steelblue2","gray87")) +
  labs(y = "Count", 
       x = "Words") +
  theme_bw(base_size = 13)

# save figure 
ggsave("figures/fig2.png",
       plot = fig2,
       device = device,
       width = fig_w,
       height = fig_h,
       units = units,
       dpi = dpi)

# create a dataframe comparing the proportion of times each word is seen in ip or pni 
frequency <- abstracts %>% 
  count(Topic, word, sort = TRUE) %>%
  group_by(Topic) %>%
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  pivot_wider(names_from = Topic, values_from = proportion) %>%
  pivot_longer(`Immunopsychiatry`,
               names_to = "topic", values_to = "proportion")

# create a plot 
fig3 <- ggplot(frequency, aes(x = proportion, y = `Psychoneuroimmunology`, 
                      color = abs(`Psychoneuroimmunology` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), 
                       low = "steelblue4", high = "steelblue3", na.value = "grey50",
                       guide = "none") +
  labs(y = "Psychoneuroimmunology", x = "Immunopsychiatry") +
  theme_bw(base_size = 18)


# quantify the correlation between word frequencies 
cor.test(data = frequency[frequency$topic == "Immunopsychiatry",],
         ~ proportion + `Psychoneuroimmunology`)  # cor = 0.631792

# save figure 
ggsave("figures/fig3.png",
       plot = fig3,
       device = device,
       width = fig_w,
       height = fig_h,
       units = units,
       dpi = dpi)

## topic modelling ip vs pni ##

# find word counts by topic 
abstract_counts <- abstracts %>% 
  group_by(Topic) %>% 
  count(word, sort = TRUE)

# cast dtm 
abstracts_dtm <- abstract_counts %>% 
  cast_dtm(Topic, word, n)

# create an LDA model with 2 topics
abstracts_lda <- LDA(abstracts_dtm, k = 2,
                    control = list(seed = 1234))
abstracts_lda

## examine per-topic-per-word probabilites
# use beta
abstract_topics <- tidy(abstracts_lda, matrix = "beta")
abstract_topics

# use slice_max to find top 5 terms per topic
top_terms <- abstract_topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 5) %>% 
  ungroup() %>%
  arrange(topic, -beta)
top_terms

# visualise
top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()







## examine per-document classification 
# make dataframe for topic and titles 
abstract_counts_by_topic <- abstracts %>% 
  group_by(Title, Topic) %>% 
  count(word, sort = TRUE)

abstract_counts_by_topic$document <- paste(abstract_counts_by_topic$Topic,
                                   "_", abstract_counts_by_topic$Title) # need to add new column with both title and topic to cast dtm

# cast dtm 
titles_dtm <- abstract_counts_by_topic %>% 
  cast_dtm(document, word, n)

# lda 
titles_lda <- LDA(titles_dtm, k = 2, 
                  control = list(seed = 1234))

# use gamma
topic_gamma <- tidy(titles_lda, matrix = "gamma")

# separate topic (ip/pni) from title
topic_gamma <- topic_gamma %>% 
  separate(document, c("group", "title"), sep = "_", convert = TRUE)

# how well did this unsupervised learning do at distinguishing between topics?
topic_gamma %>% 
  mutate(group = reorder(group, gamma * topic)) %>% 
  ggplot(aes(factor(topic), gamma)) +
  geom_boxplot() +
  scale_y_continuous(expand = c(0,0), 
                     limits = c(0, 1)) +
  facet_wrap(~ group) + 
  labs(x = "Topic", y = expression(gamma)) + 
  theme_bw()  

# find the topic most associated with each topic
topic_classifications <- topic_gamma %>% 
  group_by(group, title) %>% 
  slice_max(gamma) %>% 
  ungroup()

consensus_topics <- topic_classifications %>% 
  count(group, topic) %>% 
  group_by(group) %>% 
  slice_max(n, n = 1) %>% 
  ungroup() %>% 
  transmute(consensus = group, topic)

topic_classifications %>% 
  inner_join(consensus_topics, by = "topic") %>% 
  filter(group != consensus) # a lot of abstracts were misclassified

# find which words in each document were assigned to which topic 
assignments <- augment(titles_lda, data = titles_dtm)
assignments  # this is a df with an added column to show the topic each term was assigned to 

# combine this with consensus to see which were misclassified 
assignments %>% 
  separate(document, c("group", "title"), 
           sep = "_", convert = TRUE)  %>% 
  inner_join(consensus_topics, by = c(".topic" = "topic"))

# visualise with a confusion matrix 
assignments %>%
  count(group, consensus, wt = count) %>%
  mutate(across(c(group, consensus), ~str_wrap(., 20))) %>%
  group_by(group) %>%
  mutate(percent = n / sum(n)) %>%
  ggplot(aes(consensus, group, fill = percent)) +
  geom_tile() +
  scale_fill_gradient2(high = "yellow", mid = "darkred", low = "blue",
                       label = percent_format()) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        panel.grid = element_blank()) +
  labs(x = "Topic words were assigned to",
       y = "Topic words came from",
       fill = "% of assignments")     # all 50%?







