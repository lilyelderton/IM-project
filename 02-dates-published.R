## comparing use of ip and pni in the field over time ## 

# how many articles were published in each year? Add count to dataframe 
ip_date_count <- ip_data %>% 
  group_by(Year) %>% 
  mutate(count = n())

pni_date_count <- pni_data %>% 
  group_by(Year) %>% 
  mutate(count = n())

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
fig1 <- ggplot() +
  geom_bar(data = pni_date_count, aes(x = Year, y = count,     # barplot for pni dates 
                                     fill = Topic), 
           stat = "identity", position = "identity") +
  geom_bar(data = ip_date_count, aes(x = Year, y = count,      # barplot for ip dates on top 
                                     fill = Topic), 
           stat = "identity", position = "identity", color = "black") +
  scale_y_continuous(expand = c(0,0), 
                     limits = c(0, 160),
                     breaks = seq(0, 160, 10)) +  # change the amount of axis ticks 
  scale_x_continuous(limits = c(1944, 2025), 
                     breaks = seq(1940, 2025, 5)) +
  scale_fill_manual(values = c("steelblue2", "gray87")) +
  ggtitle("The Use of Immunopsychiatry and Psychoneuroimmunology Over Time") +
  ylab("Number of Articles Published") +
  theme_classic(base_size = 15) + 
  theme(axis.text.x = element_text(angle = 75, vjust = 0.5)) 

# figure saving settings
units <- "in"  # inches
fig_w <- 10
fig_h <- fig_w
dpi <- 500
device <- "png"   

# save figure 
ggsave("figures/fig1.png",
       plot = fig1,
       device = device,
       width = fig_w,
       height = fig_h,
       units = units,
       dpi = dpi)









