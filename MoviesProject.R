#install.packages("")
library(ggplot2)
library(plotly)
library(tidyr)
library(dplyr)
library(readr)
library(tidyverse)
library(scales) 
library(visdat) #checks
library(viridis) #colors
library(RColorBrewer) #colors

###Import data + basic checks of data

movies=read.csv("C:\Users\Carla\Desktop\Projects\Movies_Raw_Data","Clean_IMDB-Movie-Data_CSV2.csv")

head(movies)
attributes(movies)
summary(movies)
str(movies)
vis_dat(movies)
vis_miss(movies)

names(movies)
fivenum(movies$Revenue..Millions.)


### Relation between Movie Rating and Revenue
# First find the average revenue per rating
  avg_rate_revenue=as.vector(tapply(movies$Revenue..Millions., movies$Rating, mean))

# Second find all unique ratings
  uniq_rate=round(sort(unique(movies$Rating)),digits=1)

# Third create data frame and study relations
  rate_revenue=data.frame(x=uniq_rate,y=avg_rate_revenue)

  cor(x=uniq_rate,y=avg_rate_revenue) #Seems to exist a positive correlation between higher rating and higher revenue

# Fourth graph to visualize correlation
  pointschart=ggplot(data=rate_revenue,aes(x=uniq_rate,y=avg_rate_revenue))+
  geom_smooth(method='lm',size=0.5,col='mediumvioletred')+
  geom_point(size=2,col='darkslateblue')+
  scale_y_continuous(limit=c(0,200))+ 
    xlab('Movie Rating') + ylab('Average Revenue per Million')+
      ggtitle('Revenue vs Rating')
  
  pointschart + 
      theme(plot.title = element_text(colour = "darkred", size = 14, face = "bold"))+
      theme(axis.title.x = element_text(colour = "midnightblue", face = "bold"))+
      theme (axis.title.y = element_text(colour = "midnightblue", face = "bold"))
       



### Movie Industry Revenue per year
# First find the average revenue per rating
  sum_revenue=as.vector(tapply(movies$Revenue..Millions., movies$Year, sum))
  
# Second find all unique years
  uniq_year=sort(unique(movies$Year))
  
# Third create data frame 
  year_revenue=data.frame(x=uniq_year,y=sum_revenue)
  
# Fourth graph to visualize data
  barscharts= ggplot(data=year_revenue,aes(x=uniq_year,y=sum_revenue,fill=uniq_year))+
    geom_bar(stat = "identity", aes(x=uniq_year))+
        theme_classic()+
          scale_x_discrete(limits = movies$Year)+
               xlab('Year') + ylab('Revenue per Million')+
                    ggtitle("Revenue vs Year")+
    geom_text(aes(label=sum_revenue), position=position_dodge(width=0.9), vjust=-0.25)
  
   
    barscharts + 
      theme(plot.title = element_text(colour = "darkred", size = 14, face = "bold"))+
      theme(axis.title.x = element_text(colour = "midnightblue", face = "bold"))+
      theme (axis.title.y = element_text(colour = "midnightblue", face = "bold"))+
      theme(legend.position = "none")


   

    
  
### View of Average Movie duration against Revenue per Year  
# First find the average revenue and runtime per year   
    avg_year_runtime=as.vector(tapply(movies$Runtime..Minutes., movies$Year, mean))
    avg_year_revenue=as.vector(tapply(movies$Revenue..Millions., movies$Year, mean))
    yearvector=as.vector(sort(unique(movies$Year)))

# Second find the relation of the data
    cor(avg_year_runtime,avg_year_revenue) #It appears that movie duration doesn't correlate strongly with revenue
   
# Third to support findings create a visual aid  
  DurationRevenue=cbind.data.frame(avg_year_runtime,avg_year_revenue,yearvector)

areachart=ggplot(data=DurationRevenue,aes(x=avg_year_runtime,y=avg_year_revenue,key=yearvector))+
          geom_line(size=0.5,color='chartreuse4')+
           geom_point(size=3, color='chartreuse3')+
            geom_area( fill="chartreuse2", alpha=0.4)+
              geom_text(label=yearvector,nudge_x = 0.25, nudge_y = 1,check_overlap = T)+
   xlab('Average Movie Duration') + ylab('Average Revenue per Million')+
   ggtitle("Duration vs Revenue per Year")
   
 
areachart + 
  theme(plot.title = element_text(colour = "darkred", size = 14, face = "bold"))+
  theme(axis.title.x = element_text(colour = "midnightblue", face = "bold"))+
  theme (axis.title.y = element_text(colour = "midnightblue", face = "bold"))+
  theme(legend.position = "none")   
    



### Genres Analysis

#Per genre I get how many movies where made by year
Dramav=as.vector(tapply(movies$Drama, movies$Year, sum))
Actionv=as.vector(tapply(movies$Action, movies$Year, sum))
Adventurev=as.vector(tapply(movies$Adventure, movies$Year, sum))
Horrorv=as.vector(tapply(movies$Horror, movies$Year, sum))
Animationv=as.vector(tapply(movies$Animation, movies$Year, sum))
Comedyv=as.vector(tapply(movies$Comedy, movies$Year, sum))
Biographyv=as.vector(tapply(movies$Biography, movies$Year, sum))
Crimev=as.vector(tapply(movies$Crime, movies$Year, sum))
Romancev=as.vector(tapply(movies$Romance, movies$Year, sum))
Mysteryv=as.vector(tapply(movies$Mystery, movies$Year, sum))
Thrillerv=as.vector(tapply(movies$Thriller, movies$Year, sum))
Sci.Fiv=as.vector(tapply(movies$Sci.Fi, movies$Year, sum))
Fantasyv=as.vector(tapply(movies$Fantasy, movies$Year, sum))

#Creation of my data frame

genresyear=as.data.frame(cbind(Dramav,Actionv,Adventurev,Horrorv,Animationv,Comedyv,Biographyv,Crimev,Romancev,Mysteryv,Thrillerv,Sci.Fiv,Fantasyv,yearvector))


# Creation of Graph
genre1= ggplot(genresyear)+
  geom_line(aes(x=yearvector,y=Dramav,color='Drama'),size=0.5,color='brown3')+
  geom_point(aes(x=yearvector,y=Dramav,color='Drama'),size=3, color='brown3')

genre2= genre1 + 
  geom_line(aes(x=yearvector,y=Actionv,color='Action'),size=0.5,color='chartreuse3')+
  geom_point(aes(x=yearvector,y=Actionv,color='Action'),size=3, color='chartreuse3')

genre3= genre2 + 
  geom_line(aes(x=yearvector,y=Adventurev,color='Adventure'),size=0.5,color='dodgerblue3')+
  geom_point(aes(x=yearvector,y=Adventurev,color='Adventure'),size=3, color='dodgerblue3')
 
genre4=genre3 + 
  geom_line(aes(x=yearvector,y=Horrorv,color='Horror'),size=0.5,color='darkorchid1')+
  geom_point(aes(x=yearvector,y=Horrorv,color='Horror'),size=3, color='darkorchid1')

genre5=genre4 + 
  geom_line(aes(x=yearvector,y=Animationv,color='Animation'),size=0.5,color='darkorange3')+
  geom_point(aes(x=yearvector,y=Animationv,color='Animation'),size=3, color='darkorange3')

genre6=genre5 + 
  geom_line(aes(x=yearvector,y=Comedyv,color='Comedy'),size=0.5,color='gold1')+
  geom_point(aes(x=yearvector,y=Comedyv,color='Comedy'),size=3, color='gold1')

genre7=genre6 + 
  geom_line(aes(x=yearvector,y=Biographyv,color='Biography'),size=0.5,color='deeppink3')+
  geom_point(aes(x=yearvector,y=Biographyv,color='Biography'),size=3, color='deeppink3')

genre8=genre7 + 
  geom_line(aes(x=yearvector,y=Crimev,color='Crime'),size=0.5,color='darkseagreen3')+
  geom_point(aes(x=yearvector,y=Crimev,color='Crime'),size=3, color='darkseagreen3')

genre9=genre8 + 
  geom_line(aes(x=yearvector,y=Romancev,color='Romance'),size=0.5,color='lightblue3')+
  geom_point(aes(x=yearvector,y=Romancev,color='Romance'),size=3, color='lightblue3')

genre10=genre9 + 
  geom_line(aes(x=yearvector,y=Mysteryv,color='Mystery'),size=0.5,color='indianred2')+
  geom_point(aes(x=yearvector,y=Mysteryv,color='Mystery'),size=3, color='indianred2')

genre11=genre10 + 
  geom_line(aes(x=yearvector,y=Thrillerv,color='Thriller'),size=0.5,color='mediumpurple3')+
  geom_point(aes(x=yearvector,y=Thrillerv,color='Thriller'),size=3, color='mediumpurple3')

genre12=genre11 + 
  geom_line(aes(x=yearvector,y=Sci.Fiv,color='Sci-Fi'),size=0.5,color='navyblue')+
  geom_point(aes(x=yearvector,y=Sci.Fiv,color='Sci-Fi'),size=3, color='navyblue')

genre13=genre12 + 
  geom_line(aes(x=yearvector,y=Fantasyv,color='Fantasy'),size=0.5,color='red3')+
  geom_point(aes(x=yearvector,y=Fantasyv,color='Fantasy'),size=3, color='red3')

genrefinal=genre13 + xlab('Year') + ylab('Number of Movies')+
             ggtitle("Movies by Genre") +
  theme(plot.title = element_text(colour = "darkred", size = 14, face = "bold"))+
  theme(axis.title.x = element_text(colour = "midnightblue", face = "bold"))+
  theme (axis.title.y = element_text(colour = "midnightblue", face = "bold"))
  
genrefinal+scale_color_manual(name="Genres",values=color, guide='none')+
theme(legend.position = c(0.95, 0.95),legend.justification = c("left", "top"))

color=c('Drama','Action','Adventure','Horror','Animation','Comedy','Biography','Crime','Romance','Mystery','Thriller','Sci-Fi','Fantasy')



## genresc=cbind(Dramav,Actionv,Adventurev,Horrorv,Animationv,Comedyv,Biographyv,Crimev,Romancev,Mysteryv,Thrillerv,Sci.Fiv,Fantasyv)
## x=c('Drama','Action','Adventure','Horror','Animation','Comedy','Biography','Crime','Romance','Mystery','Thriller','Sci-Fi','Fantasy')
## y=c('2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016')
##  values=c('brown3', 'chartreuse3','dodgerblue3','darkorchid1','darkorange3','gold1','deeppink3','darkseagreen3','lightblue3','indianred2','mediumpurple3','navyblue','red3')) 





### Top 10 Revenue movies by genre Prevalence

#Filtering specific dta to use
topmovies=movies[rev(order(movies$Revenue..Millions.)),] %>% head(10)

Topmov=as.data.frame(cbind(Movie=topmovies$Title,Revenue=topmovies$Revenue..Millions.,Genre=topmovies$Genre1,Duration=topmovies$Runtime..Minutes.,Rating=topmovies$Rating))

#Reorder the titles so we always have them by Revenue desc
Topmov$Movie=factor(Topmov$Movie,levels = c('Star Wars: Episode VII - The Force Awakens','Avatar','Jurassic World','The Avengers','The Dark Knight',
'Rogue One','Finding Dory','Avengers: Age of Ultron','The Dark Knight Rises','The Hunger Games: Catching Fire'))

#Top Movies by Revenue
ggplot(Topmov,aes(x= Movie,y=Revenue,col=Movie),col='Movie',fill='Movie')+geom_bar(stat='identity',fill='white')+
  xlab(NULL) + ylab('Revenue in Millions')+
  ggtitle("Top Movies by Revenue") +
  theme(plot.title = element_text(colour = "darkred", size = 14, face = "bold"))+
  theme(axis.title.x = element_text(colour = "midnightblue", face = "bold"))+
  theme (axis.title.y = element_text(colour = "midnightblue", face = "bold"))+ scale_x_discrete(labels = abbreviate)

#Top Movies genre
GenreDF=as.data.frame(table(Topmov$Genre))
names(GenreDF)=c("Genre","Freq")


ggplot(GenreDF,aes(x= "",y=Freq,fill=Genre))+
  geom_bar(width = 1, stat = "identity")+
    coord_polar("y", start=0)+ 
  
  scale_fill_manual(values=c("green3", "deepskyblue"))+
  geom_text(aes(label = paste0(round(Freq*10), "%")), position = position_stack(vjust = 0.5))+

      labs(x = NULL, y = NULL, fill = NULL, title = "Top Movies by Genres Prevalence")+
  theme(plot.title = element_text(colour = "darkred", size = 14, face = "bold"))+
theme(axis.line = element_blank(), axis.text = element_blank(), axis.ticks = element_blank())



#Top Movies by Duration

ggplot(Topmov,aes(x= Movie,y=Duration,col=Movie),col='Movie',fill='Movie')+
  geom_point(shape = 21, size = 5, stroke = 5)+
  geom_point(size = 1, stroke = 4,alpha=0.4)+
    xlab(NULL) + ylab('Duration in Minutes')+
        scale_x_discrete(labels = abbreviate)+ 
            scale_y_discrete(limits=c('97','124','133','136','141','143','146','152','162','164'))+
    ggtitle("Top Movies by Duration") +
  theme(plot.title = element_text(colour = "darkred", size = 14, face = "bold"))+
  theme(axis.title.x = element_text(colour = "midnightblue", face = "bold"))+
  theme (axis.title.y = element_text(colour = "midnightblue", face = "bold"))



#Top Movies by Rating

ggplot(Topmov,aes(x= Movie,y=Rating,col=Movie),col='Movie',fill='Movie')+
  geom_point(size=5)+
  xlab('Movie') + ylab('Rating')+
  scale_x_discrete(labels = abbreviate)+ 
    ggtitle("Movies Rating") +
  theme(plot.title = element_text(colour = "darkred", size = 14, face = "bold"))+
  theme(axis.title.x = element_text(colour = "midnightblue", face = "bold"))+
  theme (axis.title.y = element_text(colour = "midnightblue", face = "bold"))





### New filtering to develop Actors information

mov2 = movies %>% 
  select(Title,Year,Runtime..Minutes.,Rating,Revenue..Millions.,Genre1,Genre2,Genre3,Actor1,Actor2,Actor3) %>%
  filter(Year>=2010) %>%
  filter(Rating>6.0) %>%
  arrange(desc(Revenue..Millions.)) %>%
  rename(Duration=Runtime..Minutes.) %>%
  rename(Revenue=Revenue..Millions.) 


### Actors - Finding top 10 Actors that appear most frequently in movies from 2010-2016

#finding top 10 actors and their appearances 
actorsall=cbind(mov2$Actor1,mov2$Actor2,mov2$Actor3)

topactors=as.data.frame(sort(desc(table(actorsall))) %>% head(10))

ActorName=c('Jake Gyllenhaal','Mark Wahlberg','Tom Hanks','Tom Hardy','Anne Hathaway','Joel Edgerton','Jonah Hill','Liam Hemsworth','Ben Affleck','Denzel Washington')
topactors=cbind(topactors,ActorName)

names(topactors)[1]='Appearances'
topactors$Aperances=topactors$Appearances*-1

# Select all titles where those actors appear
a1 = mov2 %>% 
  select(Title,Year,Actor1) %>%
  filter(Actor1 %in% ActorName)

a2 = mov2 %>% 
  select(Title,Year,Actor2) %>%
  filter(Actor2 %in% ActorName)

a3 = mov2 %>% 
  select(Title,Year,Actor3) %>%
  filter(Actor3 %in% ActorName)

mov3=rbind.data.frame(a1,a2,a3)
names(mov3)[3]='Actor_Name'


#Illustrate Actors appearances

ggplot(mov3,aes(x=Actor_Name,y=Title,color=Actor_Name))+geom_point()+
  xlab('') + ylab('')+
  ggtitle("Most Frequent Appearances") +
  theme(plot.title = element_text(colour = "darkred", size = 14, face = "bold"))+
  theme(axis.title.x = element_text(colour = "midnightblue", face = "bold"))+
  theme (axis.title.y = element_text(colour = "midnightblue", face = "bold"))
  





####################

### IMDB data

####################

#Import of Data with removal of non-needed columns
IMDB <- read_csv("C:/Users/Carla/Desktop/Projects/Movies_Raw_Data/IMDb movies.csv", 
                 col_types = cols(original_title = col_skip(), 
                                  year = col_integer(), date_published = col_skip(), 
                                  duration = col_integer(), description = col_skip(), 
                                  avg_vote = col_skip(), votes = col_skip(), 
                                  budget = col_skip(), usa_gross_income = col_skip(), 
                                  worlwide_gross_income = col_skip(), 
                                  metascore = col_skip(), reviews_from_users = col_skip(), 
                                  reviews_from_critics = col_skip()))


##Separate Genre and Actors by delimeter

IMDB=separate(
  data=IMDB,
  col=genre,
  into=c('Genre1','Genre2','Genre3'),
    sep = ", ",
  remove = TRUE,
)

IMDB=separate(
  data=IMDB,
  col=actors,
  into=c('Actor1','Actor2','Actor3','Actor4','Actor5'),
  sep = ", ",
  remove = TRUE,
)


##Pivot genre

IMDB= IMDB %>% 
  pivot_longer(
    cols = starts_with("Genre"), 
    names_to = "Rmv", 
    values_to = "Genre",
    values_drop_na = TRUE
  )

##Pivot actors

IMDB= IMDB %>% 
  pivot_longer(
    cols = starts_with("Actor"), 
    names_to = "Rmv2", 
    values_to = "Actor",
    values_drop_na = TRUE
  )

##Removing extra columns

IMDB2 = select(IMDB, -10, -12)


##Get top 20 Actors by number of movies appeared in since 2010

IMDB3 = IMDB2 %>% 
  filter(year>=2010)%>% 
  filter(country=='USA')
  

Actors=as.vector(IMDB3$Actor)
IMDBtopactors=as.data.frame(sort(desc(table(Actors))) %>% head(20))

Actors_Names = c("Eric Roberts", "Danny Trejo", "Tom Sizemore", "James Franco", "Lance Henriksen", "Anna Kendrick", "Bruce Davison", "Michael Madsen", "Richard Riehle", "Vivica A. Fox", "Nicolas Cage", "Sean Patrick Flanery", "Kevin Sorbo", "Lin Shaye", "Michael Shannon", "Channing Tatum", "Chris Hemsworth", "Dolph Lundgren", "Samuel L. Jackson", "Chris Evans")
IMDBtopactors=cbind.data.frame(IMDBtopactors,Actors_Names)

names(IMDBtopactors)=c('Number_of_Movies','Actors_Names')

IMDBtopactors$Number_of_Movies=IMDBtopactors$Number_of_Movies*-1


topactorbars=ggplot(IMDBtopactors,aes(x=Actors_Names,y=Number_of_Movies,fill=Actors_Names))+
  geom_bar(col='black',width = 1, stat = "identity")+
  geom_text(aes(label=Number_of_Movies),color='white', position=position_dodge(width=0.9), vjust=-0.25)+
  
  xlab(NULL) + ylab('Number of Movies')+
  ggtitle("Actors Appearances in Movies Since 2010") +
  
  scale_x_discrete(labels = abbreviate)
  

topactorbars+
  theme(plot.title = element_text(colour = "darkred", size = 14, face = "bold"))+
  theme (axis.title.y = element_text(colour = "midnightblue", face = "bold"))+
  theme(panel.background = element_rect(fill='black',color='black'))+
  theme(panel.grid.major.x = element_line(color='black'))+
  theme(panel.grid.major.y = element_line(color='gray48'),panel.grid.minor.y = element_line(color='gray48'))




##Get top 5 Genres by number of movies since 2010

Genres=as.vector(IMDB3$Genre)
IMDBtopgenress=as.data.frame(sort(desc(table(Genres))) %>% head(5))
names(IMDBtopgenress)='Number_of_Films'

IMDBtopgenress$Number_of_Films=IMDBtopgenress$Number_of_Films*-1


#Graph of top 5 Genres by number of movies since 2010
genrefreq=as.vector(IMDBtopgenress$Number_of_Films)

labels=c("Drama", "Comedy", "Horror", "Thriller", "Action")
piepercent<- round(100*genrefreq/sum(genrefreq), 1)

labelfinal=paste(labels, piepercent)
labelfinal <- paste(labelfinal,"%",sep="")

pie(genrefreq,labelfinal, main='Genre Prevalence in Movies since 2010',col=viridis(length(genrefreq)))
#legend("topright", c("Drama", "Comedy", "Horror", "Thriller", "Action"), cex = 0.8,fill = viridis(length(genrefreq)))



### Number of movies per year by genre

sub_imdb3= IMDB3 %>% select(title,year,Genre) %>%
  group_by(year,Genre) %>% 
  summarise(obs.count = n())


# Visualized Number of movies per year by genre

movieyears = ggplot(sub_imdb3)+
  geom_point(mapping=aes(x=Genre, y=obs.count, col=Genre))+ 
  facet_wrap( ~ year)+
      xlab(NULL)+ ylab(NULL)+
      ggtitle('Number of Movies')+ 
           scale_colour_discrete('Genre')
 
movieyears +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+
  theme(legend.position = "bottom", legend.box = "horizontal")+
  guides(color = guide_legend(nrow = 2))



### Number of movies per year

sub2_imdb3=IMDB3 %>% select(title,year) %>%
  group_by(year) %>% 
  summarise(obs.count = n())

sub2_imdb3=sub2_imdb3 %>% filter(year<2019)

# Visualization Number of movies per year
moviesmade= ggplot(sub2_imdb3)+
  geom_point(mapping=aes(x=year, y=obs.count), col='green1',size=5)+ 
  geom_line(mapping=aes(x=year, y=obs.count), col='green1',size=3)

moviesmade + 
  theme(panel.background=element_rect(fill='black',color='black'))+
  xlab(NULL)+ ylab(NULL)+
  theme(panel.grid.minor.y = element_line(color='gray48'),
        panel.grid.minor.x = element_line(color='gray48'),
        panel.grid.major.y = element_line(color='gray48'),
        panel.grid.major.x = element_line(color='gray48'))
  

