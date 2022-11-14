## comparing use of ip and pni in the field over time ## 

# set topics for search on pubmed
ip_pm <- "immunopsychiatry OR immuno-psychiatry" # try to catch all that come up in pubmed
pni_pm <- "psychoneuroimmunology OR psycho-neuro-immunology" 

# search for topics on pubmed 
search_ip <- EUtilsSummary(ip_pm)
summary(search_ip) # collects 148 

search_pni_1000 <- EUtilsSummary(pni_pm, retstart = 0, retmax = 1000)     # pni needs to be split because its too large for RISmed
search_pni_2000 <- EUtilsSummary(pni_pm, retstart = 1000, retmax = 1000)
search_pni_3000 <- EUtilsSummary(pni_pm, retstart = 2000, retmax = 1005)

# use EUtislGet to fetch the actual data 
records_ip <- EUtilsGet(search_ip)

records_pni_1000 <- EUtilsGet(search_pni_1000)
records_pni_2000 <- EUtilsGet(search_pni_2000)
records_pni_3000 <- EUtilsGet(search_pni_3000)

# collect ID, year and title in a dataframe
# pni will then need to be combined into one dataframe
ip_data <- data.frame("ID" = ArticleId(records_ip), 
                      "Year" = YearPubmed(records_ip), 
                      "Title" = ArticleTitle(records_ip))
ip_data$Topic <- "Immunopsychiatry" # need to mark that these are immunopsychiatry

pni_data_1000 <- data.frame("ID" = ArticleId(records_pni_1000), 
                       "Year" = YearPubmed(records_pni_1000), 
                       "Title" = ArticleTitle(records_pni_1000))

pni_data_2000 <- data.frame("ID" = ArticleId(records_pni_2000), 
                            "Year" = YearPubmed(records_pni_2000), 
                            "Title" = ArticleTitle(records_pni_2000))

pni_data_3000 <- data.frame("ID" = ArticleId(records_pni_3000), 
                            "Year" = YearPubmed(records_pni_3000), 
                            "Title" = ArticleTitle(records_pni_3000))

pni_data <- rbind(pni_data_1000, pni_data_2000, pni_data_3000) # combine pni dfs
pni_data$Topic <- "Psychoneuroimmunology"

# how many articles were published in each year 
ip_date_count <- ip_data %>% 
  group_by(Year) %>% 
  mutate(count = n())
ip_date_count$Topic <- "Immunopsychiatry" # need to mark that these are immunopsychaitry

pni_date_count <- pni_data %>% 
  group_by(Year) %>% 
  mutate(count = n())
pni_date_count$Topic <- "Psychoneuroimmunology"

# bind the two dataframes
dates <- rbind(ip_data, pni_data) %>% 
  count(Year, Topic)

# stacked barplot
ggplot(data = dates, aes(x = Year, y = n, fill = Topic)) +
  geom_bar(stat= "identity", position = position_stack(reverse = TRUE)) +
  scale_y_continuous(expand = c(0,0), 
                     limits = c(0, 200)) +
  scale_x_continuous(limits = c(1940, 2025)) +
  scale_fill_manual(values = c("darksalmon", "darkolivegreen")) +
  ggtitle("The Use of Immunopsychiatry and Psychoneuroimmunology Over Time") +
  ylab("Number of Articles Published") +
  theme_classic(base_family = "Times") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) 

# overlay barplot (doesn't sum the count)
ggplot() +
  geom_bar(data = pni_date_count, aes(x = Year, y = count,
                                     fill = Topic), 
           stat = "identity", position = "identity") +
  geom_bar(data = ip_date_count, aes(x = Year, y = count,
                                     fill = Topic), 
           stat = "identity", position = "identity") +
  scale_y_continuous(expand = c(0,0), 
                     limits = c(0, 160)) +
  scale_x_continuous(limits = c(1940, 2025)) +
  scale_fill_manual(values = c("blue", "gray")) +
  ggtitle("The Use of Immunopsychiatry and Psychoneuroimmunology Over Time") +
  ylab("Number of Articles Published") +
  theme_classic(base_family = "Times") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) 










