#Retrieve the data saved AFTER the profiling practice...... this means data already cleaned

setwd("C:/Users/xavier.marti.llull/Desktop")
dd <- read.csv("OUTLIERS_OUT.csv",header=T, sep=",", stringsAsFactors=TRUE);
names(dd)
dim(dd)
summary(dd)

attach(dd)

#set a list of numerical variables
names(dd)

dcon <- data.frame (lat,price,number.of.reviews,review.rate.number,long,service.fee,last.review,calculated.host.listings.count,Construction.year,minimum.nights,reviews.per.month,availability.365)
dim(dcon)

#
# CLUSTERING

#move to Gower mixed distance to deal 
#simoultaneously with numerical and qualitative data

library(cluster)

#dissimilarity matrix

actives<-c(2:16)
dissimMatrix <- daisy(dd[,actives], metric = "gower", stand=TRUE)

distMatrix<-dissimMatrix^2

h1 <- hclust(distMatrix,method="ward.D")  # NOTICE THE COST
#versions noves "ward.D" i abans de plot: par(mar=rep(2,4)) si se quejara de los margenes del plot

plot(h1)

c2 <- cutree(h1,4)

#class sizes 
table(c2)

#comparing with other partitions

names(dd)
# service.fee
boxplot(dd[,14]~c2, horizontal=TRUE)

#lat
boxplot(dd[,7]~c2, horizontal=TRUE)

#long
boxplot(dd[,8]~c2, horizontal=TRUE)

# price
boxplot(dd[,13]~c2, horitzontal=TRUE)

# Construction.year
boxplot(dd[,12]~c2, horitzontal=TRUE)

# minimum.nights
boxplot(dd[,15]~c2, horitzontal=TRUE)

# number.of.reviews
boxplot(dd[,16]~c2, horitzontal=TRUE)

# last.review
boxplot(dd[,17]~c2, horitzontal=TRUE)

# reviews.per.month
boxplot(dd[,18]~c2, horitzontal=TRUE)

# review.rate.number
boxplot(dd[,19]~c2, horitzontal=TRUE)

# calculated.host.listings.count"
boxplot(dd[,20]~c2, horitzontal=TRUE)

# availability.365
boxplot(dd[,21]~c2, horitzontal=TRUE)

pairs(dcon[,1:7], col=c2)

plot(minimum.nights,lat,col=c2,main="Clustering of credit data in 3 classes")
legend("topright",levels(c2),pch=1,col=c(1:4), cex=0.6)

cdg <- aggregate(as.data.frame(dcon),list(c2),mean)
cdg

plot(lat, long, col= c2)
points(cdg[,4],cdg[,5],pch=16,col="orange")
text(cdg[,4],cdg[,5], labels=cdg[,1], pos=2, font=2, cex=0.7, col="orange")

potencials<-c(3,4,6,7,10,11)
pairs(dcon[,potencials],col=c2)

#Profiling plots
