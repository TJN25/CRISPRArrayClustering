setup <- function(){
#setwd('~/Desktop/Scripts/testing/')
library(ggplot2)
#library(GenomeGraphs)
#library(genoPlotR)
#library(RColorBrewer)
library(lattice)
#library(genomation)
  #gff <- read.table('test.gff',header=F, sep='\t')
  #genes <- read.table('test_types.txt', header=F)
  #array <- read.table('test_repeat.gff', header=F, sep='\t')
  }
args<-commandArgs(TRUE)
plotScores <- function(gff, genes,array,title,graphtitle){
Dat <- gff
colnames(Dat) <- c('seqname','source','feature', 'start','end','score','strand','frame','attribute')
colnames(array) <- c('seqname','source','feature', 'start','end','score','strand','frame','attribute')
#head(Dat)
Dat <- Dat[Dat$feature=='CDS',]
lenD <- length(Dat$attribute)
num <- genes
colnames(num) <- c('gene','model','type','genome')
lenN <- length(num$gene)
levN <- levels(num$gene)
xx <-c()
prot_score <- c()
yy <- c()
for(j in 1:lenD){
  x <- 'n'
    for(i in levN){
    tt <- as.character(Dat[j,9])
    tt <- unlist(strsplit(tt,'Name='))
    tt <- unlist(strsplit(tt[2],';gbkey'))
    tt <- tt[1]
    if(i==tt){
      xx[j] <- 'Green'
      x <- 'y'
    }
  }
  if(x=='n'){
    xx[j] <- 'Grey'
  }
  tt <- as.character(Dat[j,9])
  tt <- unlist(strsplit(tt,'Name='))
  tt <- unlist(strsplit(tt[2],';gbkey'))
  tt <- tt[1]
  yy[j] <- tt
  prot_score[j] <- 1e-30
}
arrayNames <- c()
arrayScore <- c()
lenArray <- length(array$start)
for(j in 1:lenArray){
    tt <- as.character(array[j,9])
    tt <- unlist(strsplit(tt,'_'))
    tt <- tt[2]
  arrayNames[j] <- tt
  arrayScore[j] <- 1e-30
}
namesD <- yy
lenD <- length(Dat$feature)

##

prot_score <- ifelse(prot_score<=1e-30,30,-log10(prot_score))
##set up the gene length and colour based on starch.
a <- c()
colD <- c()
colS <- c()
namesDat <- c()
z <- 0
b <- c()
arch <- c()
lenD <- length(Dat$start)
##build a list of the lengths of genes and spaces and the corresponding colouring for graphing
for(i in 1:lenD){
  x <- Dat$start[i]

  colD <- c(colD, "black")
  colS <- c(colS, 'white',ifelse(xx[i]=="Green",'green','grey'))
  arch <- c(arch, 30)
    namesDat <- c(namesDat, NA)
  for(j in 1:lenArray){
    aa <- array$start[j]
    if(aa < x){
      jj <- Dat$start[i-1]
      if(aa > jj){
        a <- c(a, abs(aa-z))
        
        a <- c(a, abs(array$end[j] - array$start[j])) 
        colD <- c(colD, 'yellow')
        namesDat <- c(namesDat, arrayNames[j])
        arch <- c(arch,30)
        b <- c(b, 0, -10)
        z <- array$end[j]
        colD <- c(colD, "black")
        colS <- c(colS, 'white',ifelse(xx[i]=="Green",'green','grey'))
        arch <- c(arch, 30)
        namesDat <- c(namesDat, NA)
      }
    }
  }
    a <- c(a, abs(x-z))  
      a <- c(a, abs(Dat$end[i] - Dat$start[i]))
  if(xx[i]=="Green"){
    colD <- c(colD, 'green')
  }else{
    colD <- c(colD, ifelse(Dat$strand[i]=="+", "red", "blue"))
  }
  namesDat <- c(namesDat, namesD[i])
  arch <- c(arch,30)
  b <- c(b, 0, -10)
    z <- Dat$end[i]
}

##Set up the barplot heights for the spaces and proteins for mapping
ff<- seq(-5,-5,length.out = length(a))
##Make the data frames for the gene plot and the score plot
dfgenes <- data.frame(a,b)
dfscore <- data.frame(a,arch)
sumA <- sum(a)+sum(a)/10+a[1]
dfhide <- data.frame(a,ff)
##Plot the gene positions
##Add the scores plot
exten <- '.pdf'
pdf(paste(title,exten, sep=''), width=300, height=10)
y <- c(barplot(dfscore$arch, dfscore$a,col='white',##ifelse(b==0, "white", colS[colR]) 
        border=NA,##ifelse(b==0, NA, 'Black')  
        ylim=c(-10,1), space=0.1, las=2, 
        main=graphtitle),lines(x=c(0,sumA), y=c(-5,-5), col='black', lwd=3),barplot(dfgenes$b,dfgenes$a,
        col=colD, space=0.1, border=ifelse(colD=='yellow','yellow',NA),
        names.arg=namesDat,cex.names=(0.5), las=2,
        axes=T,  add=T,
        ylab="Score")#,barplot(-5,sumA*10, las=2, space=0,col="white", border=NA, add=T)
       )
print(y)
dev.off()
}

gff <- read.table(args[1], header=F, sep='\t')
genes <- read.table(args[2], header=F)
array <- read.table(args[3], header=F, sep='\t')

setup()
plotScores(gff,genes,array,args[4],args[5])





