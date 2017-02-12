#args <- commandArgs(trailingOnly=TRUE)
#print(args)

#------------------------------------Functions---------------------------------------------#

transform.df <- function(dat){
  for(i in 1:length(dat[1,])){
    if(substr(colnames(dat)[i],(nchar(colnames(dat)[i])-3),nchar(colnames(dat)[i]) )=='.num'){
      #print(paste(colnames(dat)[i], 'is numeric', sep = ' '))
      dat[,i] <- as.character(dat[,i])
      dat[,i] <- as.numeric(dat[,i])
    }else if(substr(colnames(dat)[i], nchar(colnames(dat)[i])-3, nchar(colnames(dat)[i]))=='.y.n'){
      # print(paste(colnames(dat)[i], 'is logical', sep = ' '))
      dat[,i] <- as.logical(dat[,i])
      #dat[,i] <- as.character(dat[,i])
    }else{
      #print(i)
      dat[,i] <- as.character(dat[,i])
    }
  }
  return(dat)
}
post.sapply.funct <- function(tmp, genes.dat){
  tmp <- t(tmp)
  tmp <- unlist(tmp)
  tmp <- data.frame(matrix(tmp, ncol = length(genes.dat[1,])))
  colnames(tmp) <- colnames(genes.dat)
  tmp <- transform.df(tmp)
  return(tmp)
}
write.genes.dat <- function(i, cas, cdd, genes.dat, signatures, gene.summary.dat, genomes, print.i, genomes.dat){
  if(missing(print.i)){
    print.i <- F
  }
  if(print.i == T){
    print(i)
  }
  ##Align the hmm and cdd results
  x <- match(cas[i,1], cdd$Protein_ID)
  x <- x[!is.na(x)]
  if(length(x) == 0){
    genes.dat[i,6] <- 1
    genes.dat[i,8] <- T
  }else if(length(x) > 0){
    genes.dat[i,6] <- cdd[x,4]
    if(cas[i,5] < 1e-10){
      genes.dat[i,8] <- T
    }else if(genes.dat[i,6] > 1e-20){
      genes.dat[i,8] <- T
    }else if(as.numeric(genes.dat[i,5])/1000 < genes.dat[x,6]){
      genes.dat[i,8] <- T
    }
  }
  
  ##Identifying the genes and crispr systems
  x <- grep(cas[i,2], gene.summary.dat$models)
  x <- x[!is.na(x)]
  if(length(x) > 0){
    genes.dat[i,3] <- gene.summary.dat[x, 1]##gene name
    if(gene.summary.dat[x,3]==T & gene.summary.dat[x,4]==T){
      genes.dat[i,4] <- gene.summary.dat[x, 2]##subtype name
    }
  }
  
  ##Labelling the genomes
  x <- grep(cas[i,1], genomes.dat$all.proteins)
  genes.dat[i,7] <- genomes.dat[x[1],1]
  if(length(x)>1){
    #print(length(x))
    genes.dat[i,9] <- paste(genomes.dat[x[2:length(x)],1], nchar(genomes.dat[x[2:length(x)],1]), collapse = ',')
    
  }
  genes.dat[i,3] <- changeGeneNames(genes.dat, i)
  
  return(genes.dat[i,])
  
}
changeGeneNames <- function(genes.dat, i){
  y <- grep('cas7', genes.dat[i,3])
  if(length(y)!=0){
    #print(y)
    
    return('cas7')
    
  }else{
    return(genes.dat[i,3])
  }
  y <- grep('cas8b', genes.dat[i,3])
  if(length(y)!=0){
    return('cas8b')
    
  }else{
    return(genes.dat[i,3])
  }
  y <- grep('cas5', genes.dat[i,3])
  if(length(y)!=0){
    return('cas5')
    
  }else{
    return(genes.dat[i,3])
  }
  y <- grep('cas3', genes.dat[i,3])
  if(length(y)!=0){
    return('cas3')
  }else{
    return(genes.dat[i,3])
  }
  
  
}
#------------------------------------Unused Functions---------------------------------------------#



#------------------------------------Setup and import data---------------------------------------------#

setwd('~/Desktop/Scripts/testing/')
args <- c('archaea_refseq_79.hmm.tab',
          'archaeal_proteins_rps_results_refseq79.nr.tab',
          'fasta_file_location_archaeal_refseq79.txt',
          'cas_genes_and_systems.txt', 
          '../../Project/Extras/models_and_systems.txt',
          'Archaea')
cas <- read.table(args[1], header = T, comment.char = '#', as.is = T, fill = T)
cdd <- read.table(args[2], header = T, sep = '\t', comment.char = '', as.is = T, fill = T)
genomes <- read.table(args[3], header = F, sep = '\t', comment.char = '', as.is = T, fill = T)
genes <- read.table(args[4], header = T, sep = '\t', comment.char = '', as.is = T, fill = T)
signatures <- read.table(args[5], header = T, sep = '\t', comment.char = '', as.is = T, fill = T)
genes.dat <- data.frame(Accession = cas$Protein_ID, cas.id = cas$Cas_Model, 
                        gene.name = vector(mode='character', length=length(cas$Protein_ID)), putative.system = vector(mode='character', length=length(cas$Protein_ID)), 
                        cas.e.value.num= cas$Cas_E_value, cdd.e.value.num = vector(mode='numeric', length=length(cas$Protein_ID)),
                        genome = vector(mode='character', length=length(cas$Protein_ID)), keep.y.n = vector(mode='logical', length=length(cas$Protein_ID)), 
                        also.in.genomes = vector(mode='character', length=length(cas$Protein_ID)))
cas <- cas[,c(1,3,5,19,20)]
x1 <- vector(mode = 'character', length = length(unique(genomes$V2)))
for(i in 1:length(unique(genomes$V2))){
  y <- strsplit(unique(genomes[i,2]), '/')[[1]][14]
  x1[i] <- y
}
x2 <- vector(mode = 'character', length = length(unique(genomes$V2)))
for(i in 1:length(unique(genomes$V2))){
  y <- paste('/mnt/SSD/CD_Tracr_Cas9',paste(strsplit(substr(genomes[i,2], 57, nchar(genomes[i,2])),'/')[[1]][1:4], collapse = '/'),'/*repeat.txt', sep = '')
  x2[i] <- y
}
x3 <- vector(mode = 'character', length = length(unique(genomes$V2)))
for(i in 1:length(unique(genomes$V2))){
  y <- substr(unique(genomes[i,2]),12,nchar(genomes[i,2]))
  x3[i] <- y
}
genomes.dat <- data.frame(genome =x1,
                          genes = vector(mode = 'character', length=length(unique(genomes$V2))),
                          basic.genes.present.y.n = vector(mode = 'logical', length=length(unique(genomes$V2))), single.system.y.n =vector(mode = 'logical', length=length(unique(genomes$V2))),
                          subtypes = vector(mode = 'character', length=length(unique(genomes$V2))), 
                          fastafile_path =  x3,
                          CRISPRDetect_path = x2,
                          Classification = vector(mode = 'character', length=length(unique(genomes$V2))), 
                          cas.e.values.num = vector(mode = 'character', length=length(unique(genomes$V2))), 
                          cdd.e.values.num = vector(mode = 'character', length=length(unique(genomes$V2))), 
                          cas.models = vector(mode = 'character', length=length(unique(genomes$V2))), 
                          all.proteins = genomes$V1)
genes[genes[,3]=='CAS-III-C' & genes[,2]=='cas10', 2] <- 'cas10c'
gene.summary.dat <- data.frame(gene = unique(genes$Gene), systems = vector(mode = 'character', length = length(unique(genes$Gene))), unique.y.n = vector(mode = 'logical', length = length(unique(genes$Gene))),subtypes.y.n = vector(mode = 'logical', length = length(unique(genes$Gene))), models = vector(mode = 'character', length = length(unique(genes$Gene))) )
gene.summary.dat <- transform.df(gene.summary.dat)
#unique(genes$Gene)[substr(unique(genes$Gene), 1, 5)=='cas10']
for(i in 1:length(unique(genes$Gene))){
  cas.gene <- unique(genes$Gene)[i]
  dat <- genes[genes[,2]==cas.gene,]
  gene.summary.dat[i, 2] <- paste(sort(unique(dat[,3])), collapse = ',')
  gene.summary.dat[i, 5] <- paste(sort(unique(dat[,1])), collapse = ',')
  if(length(unique(dat[,3]))==1){
    gene.summary.dat[i, 3] <- T
  }else{
    gene.summary.dat[i, 3] <- F
  }
  
}

gene.summary.dat <- gene.summary.dat[gene.summary.dat[,2]!='CAS-I,CAS-III',]
gene.summary.dat$subtypes.y.n <- T
gene.summary.dat[gene.summary.dat[,2]=='CAS-I', 4] <- F
gene.summary.dat[gene.summary.dat[,2]=='CAS-II', 4] <- F
gene.summary.dat[gene.summary.dat[,2]=='CAS-III', 4] <- F
gene.summary.dat[gene.summary.dat[,1]=='csa3', 3] <- F
gene.summary.dat[gene.summary.dat[,1]=='DinG', 3] <- F
gene.summary.dat[gene.summary.dat[,1]=='csf2gr7', 3] <- F
gene.summary.dat[gene.summary.dat[,1]=='csf3gr5', 3] <- F
gene.summary.dat[gene.summary.dat[,1]=='csf4gr11', 3] <- F
gene.summary.dat[gene.summary.dat[,1]=='csf5gr6', 3] <- F

#------------------------------------commands to run single core---------------------------------------------#
#genes.dat <- transform.df(genes.dat)
#genomes.dat <- transform.df(genomes.dat)
#ptm <- proc.time()
#tmp <- sapply(1:length(cas[,1]),
#               function(x) {write.genes.dat(x, cas, cdd, genes.dat, signatures, gene.summary.dat, genomes, print.i = T)})
#proc.time() - ptm
#genes.dat <- post.sapply.funct(tmp, genes.dat)

genes.dat <- transform.df(genes.dat)
genomes.dat <- transform.df(genomes.dat)
gene.summary.dat <- transform.df(gene.summary.dat)

ptm <- proc.time()
for(i in 1:length(cas[,1])){
  #print(i)
  genes.dat[i,] <- write.genes.dat(i, cas, cdd, genes.dat, signatures, gene.summary.dat, genomes, print.i = T, genomes.dat)
}

proc.time() - ptm
genes.dat[genes.dat[,3]=='DinG',3] <- ''
genes.dat[genes.dat[,3]=='casR',3] <- ''
genes.dat[genes.dat[,3]=='cas3HD',3] <- ''
genes.dat[genes.dat[,3]=='cmr4gr7',3] <- ''
genes.dat[genes.dat[,3]=='cmr6gr7',3] <- ''
genes.dat[genes.dat[,3]=='csm3gr7',3] <- ''
genes.dat[genes.dat[,3]=='csm6gr7',3] <- ''
genes.dat[genes.dat[,3]=='csx1gr7',3] <- ''
genes.dat[genes.dat[,3]=='csm5gr7',3] <- ''
genes.dat[genes.dat[,3]=='cmr1gr7',3] <- ''
genes.dat[genes.dat[,3]=='csm4gr5',3] <- ''
#genes.dat[genes.dat] <- ''
genes.dat[genes.dat[,3]=='csm6',3] <- ''
genes.dat[genes.dat[,3]=='csx1',3] <- ''
genes.dat[genes.dat[,3]=='DEDDh',3] <- ''

y <- grep('cas7', genes.dat[,3])
if(length(y)!=0){
  for(i in 1:length(y)){
    genes.dat[y[i],3] <- 'cas7'
  }
  
}
y <- grep('cas8b', genes.dat[,3])
if(length(y)!=0){
  for(i in 1:length(y)){
    genes.dat[y[i],3] <- 'cas8b'
  }  
}
y <- grep('cas5', genes.dat[,3])
if(length(y)!=0){
  for(i in 1:length(y)){
    genes.dat[y[i],3] <- 'cas5'
  }  
}
y <- grep('cas3', genes.dat[,3])
if(length(y)!=0){
  for(i in 1:length(y)){
    genes.dat[y[i],3] <- 'cas3'
  }
}

a <- c()
for(i in 1:length(genomes.dat[,1])){
  print(i)
  genome <- genomes.dat[i,1]
  x <- grep(genome, genes.dat$genome)
  #if(length(x)==0){
  #x <- grep(x, genes.dat$also.in.genomes)
  #}
  #print(paste('Genome ',genome,' (',i, '): ',x, sep=''))
  dat <- genes.dat[x,]
  
  uniq.uids <- unique(dat[,1])
  uniq.dat <- dat[1:length(uniq.uids),]
  #print(uniq.dat)
  uniq.dat <- transform.df(uniq.dat)
  for(j in 1:length(uniq.uids)){
    x <- uniq.uids[j]
    tmp.dat <- dat[dat[,1]==x,]
    tmp.dat <- tmp.dat[order(tmp.dat[,5]),]
    if(length(unique(tmp.dat[,3]))<2){
      uniq.dat[j,] <- tmp.dat[1,]
    }else{
      uniq.dat[j,] <- tmp.dat[1,]
      a <- c(a, paste(unique(tmp.dat[,3]), collapse = ','))
      #print(uniq.genes)
    }
  }
  genomes.dat[i,8] <- args[6]
  gene.list <- uniq.dat[,3]
  print(gene.list)
  genomes.dat[i,2] <- paste(gene.list, collapse = ',')
  genomes.dat[i,5] <- paste(sort(unique(uniq.dat[,4])), collapse = ',')
  genomes.dat[i,9] <- paste(uniq.dat[,5], collapse = ',')
  genomes.dat[i,10] <- paste(sort(unique(uniq.dat[,5])), collapse = ',')
  genomes.dat[i,11] <- paste(uniq.dat[,2], collapse = ',')
  genomes.dat[i,12] <- paste(uniq.dat[,1], collapse = ',')
  x <-match('cas1', uniq.dat[,3])
  y <-match('cas2', uniq.dat[,3])
  
  if(!is.na(x) & !is.na(y)){
    genomes.dat[i,3] <- T
  }
  if(genomes.dat[i,5]==''){
    x <- grep('cas9', uniq.dat$gene.name)
    y <- grep('cas4', uniq.dat$gene.name)
    z <- grep('csn2', uniq.dat$gene.name)
    if(length(x)>0){
      if(length(y)>0){
        genomes.dat[i,5] <- ',CAS-II-B'
      }else if(length(z)==0){
        genomes.dat[i,5] <- ',CAS-II-C'
        
      }
    }
  }
  if(genomes.dat[i,5]==',CAS-I-E'){
    y <- grep('cas4', uniq.dat$gene.name)
    if(length(x)>0){
      genomes.dat[i,5] <- ',CAS-I-E, OTHER?'
      genomes.dat[i,4] <- F
    }
  }
  if(genomes.dat[i,5]==',CAS-I-F'){
    y <- grep('cas4', uniq.dat$gene.name)
    if(length(x)>0){
      genomes.dat[i,5] <- ',CAS-I-F, OTHER?'
      genomes.dat[i,4] <- F
    }
  }
  x <- strsplit(genomes.dat[i, 5], ',')
  if(length(x[[1]])!=0){
    if(x[[1]][1]==''){
      x[[1]] <- x[[1]][2:length(x[[1]])]
    }
    if(length(x[[1]])==1){
      genomes.dat[i,4] <- T
      
    }else{
      genomes.dat[i,4] <- F
    }
  }else{
    genomes.dat[i,4] <- F
    
  }
  if(genomes.dat[i,2]==F){
    print(i)
    #genomes.dat[i,7] <- ''
    
  }
  
  
}

a.uniq <- data.frame(list = unique(a), counts.num = vector(mode = 'numeric', length = length( unique(a))))
a.uniq <- transform.df(a.uniq)
for(i in 1:length(a.uniq[,1])){
  x <- a.uniq[i,1]
  #print(x)
  y <- a[a==x]
  #print(length(y))
  a.uniq[i,2] <- length(y)
}
write.table(a.uniq, 'uids_matched_with_multiple_cas_models_archaea_refseq_79.txt', quote = F, row.names = F)
write.table(genes.dat, 'cas_protein_data_archaea_refseq_79.txt', quote = F, row.names = F, sep = '\t')
write.table(genomes.dat, 'genomes_with_cas_proteins_archaea_refseq_79.txt', quote = F, row.names = F, sep = '\t')
write.table(genomes.dat[genomes.dat[,4]==T, ], 'genomes_with_single_system_archaea_refseq_79.txt', quote = F, row.names = F, sep = '\t')
#write.table(gene.summary.dat, 'genes_and_systems_summary.txt', quote = F, row.names = F, sep = '\t')
#write.table(gene.summary.dat[gene.summary.dat[,3]==T & gene.summary.dat[,4]==T,], 'signature_genes.txt', quote = F, row.names = F, sep = '\t')

#------------------------------------commands to run multicore core---------------------------------------------#

#library(parallel)
#no_cores <- detectCores() - 1
#cl <- makeCluster(no_cores)
#clusterExport(cl, "cas")
#clusterExport(cl, "cdd")
#clusterExport(cl, "genes.dat"
#clusterExport(cl, "signatures")
#clusterExport(cl, "gene.summary.dat")
#clusterExport(cl, "genomes")
#clusterExport(cl, "genomes.dat")

#clusterExport(cl, "write.genes.dat")
#clusterExport(cl, "changeGeneNames")

#ptm <- proc.time()
#tmp <- parSapply(cl, 1:length(cas[,1]),
#                 function(x) {write.genes.dat(x, cas, cdd, genes.dat, signatures, gene.summary.dat, genomes, print.i = T, genomes.dat)})
#proc.time() - ptm
#genes.dat <- post.sapply.funct(tmp, genes.dat)
#rm(tmp)
#stopCluster(cl)
#genes.dat <- genes.dat.tmp
#genes.dat[genes.dat[,3]=='DinG',3] <- ''
#genes.dat[genes.dat[,3]=='casR',3] <- ''
#genes.dat[genes.dat[,3]=='cas3HD',3] <- ''
#genes.dat[genes.dat[,3]=='cmr4gr7',3] <- ''
#genes.dat[genes.dat[,3]=='cmr6gr7',3] <- ''
#genes.dat[genes.dat[,3]=='csm3gr7',3] <- ''
#genes.dat[genes.dat[,3]=='csm6gr7',3] <- ''
#genes.dat[genes.dat[,3]=='csx1gr7',3] <- ''
#genes.dat[genes.dat] <- ''
#genes.dat[genes.dat[,3]=='csm6',3] <- ''
#genes.dat[genes.dat[,3]=='csx1',3] <- ''
#genes.dat[genes.dat[,3]=='DEDDh',3] <- ''

#------------------------------------write files---------------------------------------------#


#------------------------------------current tests---------------------------------------------#

#for(i in 1:100){
  genes.dat[i,] <- write.genes.dat(i, cas, cdd, genes.dat, signatures, gene.summary.dat, genomes, print.i = T, genomes.dat)
}
#for(i in 1:length(genes.dat[,1])){
  genes.dat[i,] <- write.genes.dat(i, cas, cdd, genes.dat, signatures, gene.summary.dat, genomes, print.i = T, genomes.dat)
}
length(genomes.dat[genomes.dat[,2]=='NA',1])
grep('Halalkalicoccus_jeotgali_B3-795797#GCF_000196895.1', genomes$V2)
genomes[33,1]
grep('WP_008417324.1', cas$Protein_ID)

#------------------------------------other tests---------------------------------------------#

#cas.b <- read.table('bacteria_refseq_79.all.tab', header = T, sep = '\t', comment.char = '', as.is = T, fill = T)
#cas.b <- cas.b[cas.b[,20]!='',]





######


