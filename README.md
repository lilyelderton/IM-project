# Lab Book

This is my lab book for my text mining project.

## Autumn Term 
### 7/10/22: 
Today I had my first proper meeting with Emma and Alice. I learnt how to connect my project to github, which I am excited to use as it sounds very useful for keeping track of the changes i make to mny project. The plan for the week ahead is to try and read full pubmed articles into R that can then be used for analysis. I am apprehenisve about this because i have tried briefly before and google wasn't helpful. I am still trying to adjust from learning R with clear instructions (like previous years) to learning through my own exploration. We were given an example using the fulltext package, so hopefully this will help me.

### 10/10/22 - 12/10/22: 
I have been trying to use fulltext to read in full articles from pubmed into R but I haven't had much luck. It is much harder than I thought to follow someone else's work when there isn't clear explanation as to why each step was taken. I got very frustrated and wanted to give up, but I decided to practice some other skills instead so that i didn't get dejected with R overall - I needed the confidence that comes with getting something right. Thus, I read in some other files and practiced tidying them following along the example articles. This restored my confidence to try again on reading in my own work tomorrow. I will try to read in just the abstracts at first since there are a few packages for this that seem easier to use, and I will talk with Emma about reading in the full text on Friday in our meeting. 

### 13/10/22: 
Tried a few packages to read in the abstracts from R. Lots of trial and error which was frustrating - even though i do feel accomplished when i finally figure out how it works. I managed to get as far as reading in the text (using RISmed - http://amunategui.github.io/pubmed-query/) and then tokenise the abstracts. Plan is to then practice some analysis on these abstracts.

### 14/10/22: 
Had a meeting with Emma. We worked through all the problems I'd had in my script and managed to fix most of them! It was nice just having another brain to help find where I went wrong as this can sometimes be hard to do alone - you get stuck on one path looking for a solution and then just end up frustrated. I left the meeting feeling much more confident in where I was at with my project - a result of fixing the problems and knowing i was doing enougb work (something i had been worried about). I think in future I need to try contacting Emma or Alice more often to help if I'm stuck as I do enjoy the team work/having a support network when it comes to R. I then came home and managed to fix the problem of keeping hyphenated words together myself, and then performed some simple analysis. In the next week, I would like to try topic modelling - Emma recommended it as a method that would be good in the project - and look into litsearchR as another package that I could use in my project. 

### 18/10/22:
I practiced tf-idf and started on topic modeling for my practice dataset. Most of this went smoothly and so has built my confidence in using R. 

### 19/10/22:
Finished topic modeling for my dataset. Had to troubleshoot in a few places, but this did not take too long - my R problem solving is improving with practice. Topic modeling in this way didn't seem too suited to my dataset however - I think either the search was too narrow to divide into topics, or there were too many confounding terms (a lot of numbers?). I will discuss this with Emma at my meeting on Friday. Next I would like to look into litsearchR as a package. 

### 21/10/22: 
Today I practiced using litsearchR to assess the keywords associated with a pubmed search, and then using these to create a new search that should encompass the topic more effectively. The instructions were very clear to follow and so everything ran smoothly. I think that this package could be very useful in my project to assess whether keywords have changed over time as the PNI moves into IP, although I think the creating a new search tool may be harder to use - the results from those searches are massive making them too large to read into R. 
I also had a short meeting with Emma. I had no problems to talk about this week so the meeting didn't feel very useful to me. In future I think I will plan out more of what I want to cover in these meetings so I can get the most out of them, as I don't enjoy feeling directionless. She did recommend making a full plan for my literature review that she can look over, so I will do this, as well as trying to make a comprehensive plan for the analysis i'd like to do for my project that I can show her next week. 

### 28/10/22:  
Meeting with Emma. I hadn't done much preparation for it as i was focusing on my literature review, and tbh i felt it. I learnt that to get something out of these meetings i need to put work into preparing for them each week. We tried to read full text into R from the articles but the packages that used to do that have been archived and there are no replacements. We didn't get anywhere with it and so it felt like a waste of a meeting. 

### 4/11/22: 
I haven't done much R work again this week because of the lit review. We tried again in our meeting to read in the full text in various ways but nothing was working. I was ready to give up on analysing the full text going into the meeting, but then Emma managed to download the PDFs of most of the papers on the topic for me so that i could read those in to analyse. This reminded me to always persevere if i really want something done because with some applied problem solving there is a solution for most things in coding. Don't let frustration get the best of you! and be prepared to put in the time - even though it doesn't feel like the project is developing, it will be worth it in the long run. 
I successfully read the PDFs into R and in the coming week I will try out all of the text mining methods on them before setting up my actual project. 

### 7/11/22:
Basic count analysis on the PDFs. Worked out that I need to exclude number stopwords after the tdm with removeNumbers = FALSE is done to stop it getting confused - and can't just straight up remove numbers since cytokines have numbers e.g. IL-6. Easy function with tm package to keep "-" included in the text. I would like to find a way to combine the words for the articles with the date and article ID ect for the actual project, but not what the best way to do this is. 

### 8/11/22:
Trialing other text mining techniques on dataset went smoothly. I am now ready to get started on the actual project I think. I am struggling with feeling a bit directionless in the project though. I will discuss a game plan with Emma on Friday as I like to work with a clear goal in mind for what comes next, or I tend to feel unmotivated/lost. 

### 9/11/22:
Read in the PDFs for immunopsychiatry into the project and made a tdm, dtm and tidy dataframe from this for future analysis. Had to play around for a bit to get the format for the punctuation correct but i persevered and it all worked out well. I would like to look at splitting the title into date and then title, and maybe adding the information for the authors and doi etc, but I need to look into the best way to do this. I also need to go over the differences in a dtm and tdm to decide which format is best for each bit of analysis. 
My aim for tomorrow is to sort out that formatting and then use RISmed to make figures of the popularity of immunopsychiatry in papers over time compared with psychoneuroimmunology

### 10/11/22:
Used RISmed to read in the dates for ip and pni articles and then made a grouped barplot to compare the two. It took a while to get the data read in and formatted correctly but I worked it out eventually. I don't really like the format of the graph atm, I think it either needs a change in format as a grouped plot or it could work instead as an overlay barplot. 

### 11/11/22: 
Came into meeting with Emma with targettedd questions this week, and feel like I got a lot more out of it, including a clear plan for my project going forwards. 

### 13/11/22: 
Fixed barplot problem so now have an overlaid plot (so real counts are clear, not just summed count). Would like to increase axis ticks for both y and x axes though. 

### 14/11/22:
Perfected dates published graph so now I have my first figure! I have also thoroughly tidied my dataframes and tokenised them so they are ready to be analysed. I need to write the tidied IP and PNI dataframes to file, and then I can go through and analyse these to make more figures with tomorrow - preferrably a word count one, a network, and then some topic modelling ones? I want to try and sue topic modelling with ip as 1 topic and pni as another to see if there are differences. 
















