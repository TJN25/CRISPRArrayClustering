args<-commandArgs(TRUE)
cdd <- read.table(args[1], header=T)
full <- read.table(args[2], header=T)
cas <- read.table(args[3], header=T)
models <- read.table(args[4], header=T)
signatures <- read.table(args[5], header=F)
lenDat <- length(cas[,1])
dat <- as.matrix(cas)
full <- as.matrix(full)
lenFull <- length(full[,1])
aa <- c('-','-','-','-')
bb <- c('No_hits','-','-','-')
bb <- matrix(bb, nrow=1)
aa <- matrix(aa, nrow=1)
i <- 1
a <- c('-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-','-')
a <- matrix(a, nrow=1)
for(i in 1:lenFull){
  if(as.character(dat[i,1])==as.character(full[i,2])){
    a <- rbind(a,dat[i,])
    aa <- rbind(aa,full[i,])
  }else{
   x <- 'n'
    for(j in 1:lenFull){
     if(as.character(dat[i,1])==as.character(full[j,2])){
       a <- rbind(a,dat[i,])
       aa <- rbind(aa,full[j,])
       x <- 'y'
     }
    }
    if(x=='n'){
      a <- rbind(a,dat[i,])
      aa <- rbind(aa,bb)      
    }
   
}
lenDat <- length(dat[,1])
ll <- lenFull+1
} 
for(i in ll:lenDat){
    x <- 'n'
    for(j in 1:lenFull){
      if(as.character(dat[i,1])==as.character(full[j,2])){
        a <- rbind(a,dat[i,])
        aa <- rbind(aa,full[j,])
        x <- 'y'
      }
    }
    if(x=='n'){
      a <- rbind(a,dat[i,])
      aa <- rbind(aa,bb)      
    }
    
  }


abc <- cbind(a,aa)
abc <- abc[,-c(2,4,6,7,8,9,10,11,12,13,14,15,16,17,18)]



#####
cdd <- as.matrix(cdd)
lenCDD <- length(cdd[,1])
abc <- as.data.frame(abc)
lev <- levels(abc$Species_Name)
lev <- as.matrix(lev)
nn <- abc
nn <- as.matrix(nn)
lenDat <- length(nn[,1])
xx <- c()
yy <- c()
for(i in 1:lenDat){
  if(as.character(nn[i,8])=='-'){
    xx[i] <- '-'
    yy[i] <- '-'
  }else{
    for(j in 1:lenCDD){
      
      if(as.numeric(nn[i,8])==as.numeric(cdd[j,1])){
        xx[i] <- cdd[j,2]
        yy[i] <- cdd[j,3]
      }
    }
    
  }
}
xx <- as.matrix(xx, ncol=1)
colnames(xx) <- c('Cdd_Name')
yy <- as.matrix(yy, ncol=1)
colnames(yy) <- c('Cdd_Description')
nn <- cbind(nn, xx, yy)
ll <- length(nn[,1])
rr <- c()
for(i in 2:ll){
  cas_value <- nn[i,3]
  cas_value <-as.numeric(cas_value)
  if(cas_value<=1e-10){
    rr[i] <- 'Cas'
  }else  if(nn[i,9]=='-'){
    rr[i] <- 'Cas'
  }else if(nn[i,2]==nn[i,10]){
    rr[i] <- 'Cas'
  }else{
    cas_value <- nn[i,3]
    cas_value <-as.numeric(cas_value)
    cdd_value <- nn[i,9]
    cdd_value <- as.numeric(cdd_value)
    rr[i] <- ifelse(cas_value<cdd_value*100,'Cas','Cdd')
  }
}
rr <- as.matrix(rr, ncol=1)
nn <- cbind(nn,rr)
sig <- nn[nn[,12]=='Cas',]
not <- nn[nn[,12]=='Cdd',]
LenM <- length(models[,1])
ll <- length(sig[,1])
x <- c()
for(i in 2:ll){
  for(j in 1:LenM){
    if(sig[i,2]==models[j,1]){
      x[i] <- as.character(models[j,3])
    }
  }
  
}
x <- as.matrix(x, ncol=1)
sig <- cbind(sig,x)
write.table(sig, file = args[5], sep = "\t")
