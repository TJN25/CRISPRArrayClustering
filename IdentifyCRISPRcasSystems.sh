#!/bin/bash
source /home/tomn/.bash_profile
#Script for running identifying crispr systems in genomes and getting a CRISPRDetect file
# with all of the arrays for genomes with a single subtype

##HMM search

###get_GCF_file_names.py
###proteins_and_file_locations.py
##keep non-redundant
##extract proteins
##rpsblast with these proteins
##non-redundant
##format for r
##Resultsv2.0
##CRISPR_types_from_results.py
##CRISPR_typeIn_genomes.py 
###assign systems a this step
##get_crispr_detect_files.py
##get_cripsr_detect_files.sh
##add_metadata_to_CRISPRDetect
##cat files together

#Output will be used for CRISPRTarget at this point

helpInfo='# identifyCRISPRcasSystems :: Identifies genomes that are likely to contain\n
CRRISPR-cas systems and outputs files that contain information about the scores, genes,\n
number of spacers etc. along with writing the CRISPRDetect outputs to a file.\n
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n
Usage: run_hmmsearch -i <fastafile> -o <outputfile> -d <hmm profile>\n
\n
Basic options:\n
  -h : show brief help on version and usage\n
  -i : sequence files which the hmmsearch will be run over\n
  -o : output file where all the results will be written is table format\n
  -d : the hmm profiles\n

'

while getopts "f:p:o:h" arg; do
  case $arg in
    i)
      fastafiles=$OPTARG
      #echo $file1
      ;;
    o)
      hmmoutput=$OPTARG
      #echo $delim
      ;;
    d)
      hmmprofile=$OPTARG
      #echo $delim
      ;;   
    h)
      echo -e $helpInfo
      exit
      ;;       
  esac
done
#fastafiles example /mnt/SAN/scratch/brownlab/chrisbr/DB/RefSeq79/bacteria/*/*/*_protein.faa
#hmmoutput example ../Working/predicted_cas_genes_in_bacteria_of_refseq79.txt
#hmmprofile example ../DB/CRISPR_models.hmm





#Identify putative cas proteins with hmmsearch
run_hmmsearch.sh -i $fastafiles -o $hmmoutput.txt -d $hmmprofile

##Make a lookup table for all the putative cas genes for the filepath to the fasta file they originate from. 
proteins_and_file_location.py $hmmoutput.txt $hmmoutput.filelocations.txt

##get the protein sequences for the putative cas genes in order to carry out the rpsblast.
extract_protein_sequences $hmmoutput.filelocations.txt $hmmoutput.faa

##Take the hmmsearch output and reformat into tab delimited form for use in R.
reformat_hmm_output_for_r.py $hmmoutput.txt $hmmoutput.all.tab

##Compare putative cas proteins to other models with rpsblast
rpsblast -db $cddfiles -query $hmmoutput.faa -outfmt 7 -out $hmmoutput.cddcomparison.txt -evalue 0.000001 -max_target_seqs 1

##Take rpsblast output and format for use in R.
reformat_output_from_rpsblast.py $hmmoutput.cddcomparison.txt $hmmoutput.cddtable.txt

##Filter out the CDD matches to proteins where a protein had a better score to another conserved domain (a redundant list is not needed as the best score will be the only one considered in R anyway).
keep_highest_score_rps.py $hmmoutput.cddtable.txt $hmmoutput.cddnr.tab
#combine the cas and cdd model results for analysis 
###The script on the server should be up to date. The file paths and other info is being added manually at the moment and these files are likely out of date.
Rscript /home/tomn/masters/scripts/identifycasproteins_server.R 

##Get CRISPRDetect files and append data
get_crispr_detect_files.py $hmmoutput.single_systems.txt $hmmoutput.CRISPRDetect.txt


##Get info about the number of arrays and spacers. 
###This is currently not working and should be fixed up.
#spacer_and_array_count.py $hmmoutput.genomes_with_cas_genes.txt $hmmoutput.spacer.counts.txt

###Leave Script to run CRISPRTarget


##carry on analysis using the masters_work.Rmd file. 

