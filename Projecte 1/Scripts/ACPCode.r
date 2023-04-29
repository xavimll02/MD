
#PREREQUISITES: 
#factors are properly labelled and reading data makes R to directly recognize them
#Numerical variables do not contain missing values anymore. They have been imputed in preprocessing step

dd <- read.table("Airbnb_clean.csv",header=T, sep=",", stringsAsFactors = TRUE);

objects()
attributes(dd)

# VISUALISATION OF DATA
## PRINCIPAL COMPONENT ANALYSIS OF CONTINcUOUS VARIABLES, WITH Dictamen PROJECTED AS ILLUSTRATIVE
### CREATION OF THE DATA FRAME OF CONTINUOUS VARIABLES

attach(dd)
names(dd)

#is R understanding well my factor variables?
sapply(dd,class)

#set a list of numerical variables (with no missing values)

dcon <- data.frame (lat,price,number.of.reviews,review.rate.number,long,service.fee,calculated.host.listings.count,Construction.year,minimum.nights,reviews.per.month,availability.365)
sapply(dcon, class)

#be sure you don't have missing data in your numerical variables.

#in case of having missing data, select complete rows JUST TO FOLLOW THE CLASS
#dd<-dd[!is.na(dd[,indecCon[1]])& !is.na(dd[,indecCon[2]]) & !is.na(dd[,indecCon[3]])& !is.na(dd[,indecCon[4]]),]
#then preprocess your complete data set to IMPUTE all missing data, and reproduce
#the whole analysis again
# PRINCIPAL COMPONENT ANALYSIS OF dcon

pc1 <- prcomp(dcon, scale=TRUE)
class(pc1)
attributes(pc1)

print(pc1)

# WHICH PERCENTAGE OF THE TOTAL INERTIA IS REPRESENTED IN SUBSPACES?
pc1$sdev
inerProj<- pc1$sdev^2 
inerProj
totalIner<- sum(inerProj)
totalIner
pinerEix<- 100*inerProj/totalIner
pinerEix
barplot(pinerEix)

#Cummulated Inertia in subspaces, from first principal component to the 11th dimension subspace
barplot(100*cumsum(pc1$sdev[1:dim(dcon)[2]]^2)/dim(dcon)[2])
percInerAccum<-100*cumsum(pc1$sdev[1:dim(dcon)[2]]^2)/dim(dcon)[2]
percInerAccum

# SELECTION OF THE SINGIFICNT DIMENSIONS (keep 80% of total inertia)
nd = 6 

print(pc1)
attributes(pc1)
pc1$rotation

# STORAGE OF THE EIGENVALUES, EIGENVECTORS AND PROJECTIONS IN THE nd DIMENSIONS
View(pc1$x)
dim(pc1$x)
dim(dcon)
dcon[2000,]
pc1$x[2000,]

Psi = pc1$x[,1:nd]
dim(Psi)
Psi[2000,]

# STORAGE OF LABELS FOR INDIVIDUALS AND VARIABLES

iden = row.names(dcon)
etiq = names(dcon)
ze = rep(0,length(etiq)) # WE WILL NEED THIS VECTOR AFTERWARDS FOR THE GRAPHICS

# PLOT OF INDIVIDUALS

eje1<-1
eje2<-2

{plot(Psi[,eje1],Psi[,eje2])
text(Psi[,eje1],Psi[,eje2],labels=iden, cex=0.5)
axis(side=1, pos= 0, labels = F, col="cyan")
axis(side=3, pos= 0, labels = F, col="cyan")
axis(side=2, pos= 0, labels = F, col="cyan")
axis(side=4, pos= 0, labels = F, col="cyan")}


#Projection of variables

Phi = cor(dcon,Psi)
View(Phi)

#select your axis
X<-Phi[,eje1]
Y<-Phi[,eje2]

{plot(Psi[,eje1],Psi[,eje2],type="n")
axis(side=1, pos= 0, labels = F)
axis(side=3, pos= 0, labels = F)
axis(side=2, pos= 0, labels = F)
axis(side=4, pos= 0, labels = F)
arrows(ze, ze, X, Y, length = 0.07,col="blue")
text(X,Y,labels=etiq,col="darkblue", cex=0.7)}


#zooms
{plot(Psi[,eje1],Psi[,eje2],type="n",xlim=c(min(X,0),max(X,0)), ylim=c(-1,1))
axis(side=1, pos= 0, labels = F)
axis(side=3, pos= 0, labels = F)
axis(side=2, pos= 0, labels = F)
axis(side=4, pos= 0, labels = F)
arrows(ze, ze, X, Y, length = 0.07,col="blue")
text(X,Y,labels=etiq,col="darkblue", cex=0.7)}

# PROJECTION OF ILLUSTRATIVE qualitative variables on individuals' map

meanPrice = mean(price)
above.mean.price<-seq(0:length(dd))
dd$above.mean.price[dd$price < meanPrice] <- FALSE
dd$above.mean.price[dd$price >= meanPrice] <- TRUE

meanservicefee = mean(service.fee)
dd$above.mean.service.fee[dd$service.fee < meanservicefee] <- FALSE
dd$above.mean.service.fee[dd$service.fee >= meanservicefee] <- TRUE

mean.reviews.per.month = mean(reviews.per.month)
dd$above.mean.reviews.per.month[dd$reviews.per.month < mean.reviews.per.month] <- FALSE
dd$above.mean.reviews.per.month[dd$reviews.per.month >= mean.reviews.per.month] <- TRUE

mean.minimum.nights = mean(minimum.nights)
dd$above.mean.minimum.nights[dd$minimum.nights < mean.minimum.nights] <- FALSE
dd$above.mean.minimum.nights[dd$minimum.nights >= mean.minimum.nights] <- TRUE

names(dd)

dd[,c(13,22)]

#Neighbourhood Group
varcat=as.factor(dd[,5])
plot(Psi[,1],Psi[,2],col = varcat)
axis(side=1, pos= 0, labels = F, col="darkgray")
axis(side=3, pos= 0, labels = F, col="darkgray")
axis(side=2, pos= 0, labels = F, col="darkgray")
axis(side=4, pos= 0, labels = F, col="darkgray")
legend("bottomleft",levels(varcat),pch=1,col = 1:length(levels(varcat)), cex=0.6)

#Mean Price
varcat=as.factor(dd[,22])
plot(Psi[,1],Psi[,2],col = varcat)
axis(side=1, pos= 0, labels = F, col="darkgray")
axis(side=3, pos= 0, labels = F, col="darkgray")
axis(side=2, pos= 0, labels = F, col="darkgray")
axis(side=4, pos= 0, labels = F, col="darkgray")
legend("bottomleft",levels(varcat),pch=1,col = 1:length(levels(varcat)), cex=0.6)

#Mean Service Fee
varcat=as.factor(dd[,23])
plot(Psi[,1],Psi[,2],col = varcat)
axis(side=1, pos= 0, labels = F, col="darkgray")
axis(side=3, pos= 0, labels = F, col="darkgray")
axis(side=2, pos= 0, labels = F, col="darkgray")
axis(side=4, pos= 0, labels = F, col="darkgray")
legend("bottomleft",levels(varcat),pch=1,col = 1:length(levels(varcat)), cex=0.6)

#Mean Reviews per month
varcat=as.factor(dd[,24])
plot(Psi[,1],Psi[,2],col = varcat)
axis(side=1, pos= 0, labels = F, col="darkgray")
axis(side=3, pos= 0, labels = F, col="darkgray")
axis(side=2, pos= 0, labels = F, col="darkgray")
axis(side=4, pos= 0, labels = F, col="darkgray")
legend("bottomleft",levels(varcat),pch=1,col = 1:length(levels(varcat)), cex=0.6)

#Mean Miminum Nights
varcat=as.factor(dd[,25])
plot(Psi[,1],Psi[,2],col = varcat)
axis(side=1, pos= 0, labels = F, col="darkgray")
axis(side=3, pos= 0, labels = F, col="darkgray")
axis(side=2, pos= 0, labels = F, col="darkgray")
axis(side=4, pos= 0, labels = F, col="darkgray")
legend("bottomleft",levels(varcat),pch=1,col = 1:length(levels(varcat)), cex=0.6)

#all qualitative together
plot(Psi[,eje1],Psi[,eje2],type="n")
axis(side=1, pos= 0, labels = F, col="cyan")
axis(side=3, pos= 0, labels = F, col="cyan")
axis(side=2, pos= 0, labels = F, col="cyan")
axis(side=4, pos= 0, labels = F, col="cyan")

#nominal qualitative variables

dcat<-c(5,11,22,23,24,25)
#divide categoricals in several graphs if joint representation saturates

#build a palette with as much colors as qualitative variables 

#colors<-c("blue","red","green","orange","darkgreen")
#alternative
colors<-rainbow(length(dcat))

c<-1
for(k in dcat){
  seguentColor<-colors[c]
fdic1 = tapply(Psi[,eje1],dd[,k],mean)
fdic2 = tapply(Psi[,eje2],dd[,k],mean) 

text(fdic1,fdic2,labels=levels(dd[,k]),col=seguentColor, cex=0.6)
c<-c+1
}
legend("bottomleft",names(dd)[dcat],pch=1,col=colors, cex=0.6)

#determine zoom level
#use the scale factor or not depending on the position of centroids
# ES UN FACTOR D'ESCALA PER DIBUIXAR LES FLETXES MES VISIBLES EN EL GRAFIC
#fm = round(max(abs(Psi[,1]))) 
# fm=20



#scale the projected variables
# X<-fm*U[,eje1]
# Y<-fm*U[,eje2]

#represent numerical variables in background
plot(Psi[,eje1],Psi[,eje2],type="n",xlim=c(-1,1), ylim=c(-3,1))
plot(X,Y,type="none",xlim=c(-2,1), ylim=c(-2,2))
 axis(side=1, pos= 0, labels = F, col="cyan")
 axis(side=3, pos= 0, labels = F, col="cyan")
 axis(side=2, pos= 0, labels = F, col="cyan")
 axis(side=4, pos= 0, labels = F, col="cyan")

#add projections of numerical variables in background
 arrows(ze, ze, X, Y, length = 0.07,col="lightgray")
 text(X,Y,labels=etiq,col="gray", cex=0.7)

#add centroids
 c<-1
 for(k in dcat){
  seguentColor<-colors[c]
   
  fdic1 = tapply(Psi[,eje1],dd[,k],mean)
  fdic2 = tapply(Psi[,eje2],dd[,k],mean) 
 
 #points(fdic1,fdic2,pch=16,col=seguentColor, abels=levels(dd[,k]))
 text(fdic1,fdic2,labels=levels(dd[,k]),col=seguentColor, cex=0.6)
  c<-c+1
}
legend("bottomleft",names(dd)[dcat],pch=1,col=colors, cex=0.6)
