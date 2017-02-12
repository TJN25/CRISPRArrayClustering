#!/usr/bin/python

'''
Takes the rpsblast output and reformats so that it is in a tabular format that can be 
analysed the same way that the hmmsearch output is.

input file example output.cddcomparison.txt
outputfile example output.cddtable.txt
'''

import sys

ff = sys.argv[1]
nn = sys.argv[2]
II=open(ff, 'r')
oo=open('%s' % nn, 'a')
oo.write('GI\tProtein_ID\tCdd_ID\tCdd_E_value\n')
#oo2=open('%s_cdd_numbers.txt' % nn, 'a')
for line in II:
	line=line.rstrip()
	if '#' in line:
		if '0 hits' in line:
			oo.write ('No_hits\t-\t-\t-\n')
		else:
			pass
	else:
		#print line
		words=line.split('\t')
		protein=words[0]
		#print protein
		cdd=words[1]
		eval=words[10]
		#protein=protein.split('|')
		#gi=protein[1]
		#protein=protein[3]
		cdd=cdd.split('|')
		cdd=cdd[2]
		oo.write('%s\t%s\t%s\t%s\n' %(protein,protein,cdd,eval))
		#oo2.write('%s\n' % cdd)