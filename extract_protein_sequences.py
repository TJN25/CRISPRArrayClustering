#!/usr/bin/python


'''
Takes the list of putative cas proteins and extracts them from the multifasta files and 
writes them to a single file

input example output.filelocations.txt
output example output.faa
'''

import subprocess
import sys
ff= sys.argv[1]
nn=sys.argv[2]
II=open(ff,'r')
for line in II:
	line=line.rstrip()
	words=line.split('\t')
	file_location = words[1]
	protein_list = words[0]
	protein_list = protein_list.split(',')
	print file_location
	subprocess.call(["rm ../Testing/fastafile.faa"], shell=True)
	subprocess.call(["rm ../Testing/fastafile.faa.fai"], shell=True)

	x='cp %s ../Testing/fastafile.faa' % file_location
	subprocess.call([x], shell=True)
	for i in protein_list:
		#print i
		x = 'samtools faidx ../Testing/fastafile.faa %s >> %s' % (i, nn)
		subprocess.call([x], shell=True)
