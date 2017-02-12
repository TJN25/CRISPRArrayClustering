#!/bin/bash

#echo 'Starting script'
#input file example /mnt/SAN/scratch/brownlab/chrisbr/DB/RefSeq79/bacteria/*/*/*_protein.faa
#output file example ../Working/predicted_cas_genes_in_bacteria_of_refseq79.txt
#dbFile example ../DB/CRISPR_models.hmm

helpInfo='# run_hmmsearch :: search profile(s) against multiple sequence database and write output to one file\n
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n
Usage: run_hmmsearch -i <fastafile> -o <outputfile> -d <hmm profile>\n
\n
Basic options:\n
  -h : show brief help on version and usage\n
  -i : sequence files which the hmmsearch will be run over\n
  -o : output file where all the results will be written is table format\n
  -d : the hmm profiles\n

'
while getopts "i:o:d:h" arg; do
  case $arg in
    i)
      inputFile=$OPTARG
      #echo $file1
      ;;
    o)
      outputFile=$OPTARG
      #echo $delim
      ;;
    d)
      dbFile=$OPTARG
      #echo $delim
      ;;   
    h)
      echo -e $helpInfo
      exit
      ;;       
  esac
done



let "fileNum=0"
for file in $inputFile
do 

hmmsearch --tblout tmp1 -E 1e-5 --cpu 3  --noali $dbFile $file >> output.log 


cat tmp1 >> $outputFile
rm tmp1
rm output.log
done
