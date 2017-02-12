#!/usr/bin/python
'''
reformats non redundant hmmsearch output into a tabular tab delimited format that can be
used in R.

input example is output.nr.txt
output example is output.nr.tab
'''
import sys
ff =sys.argv[1]
nn =sys.argv[2]
II=open(ff, 'r')
OO=open(nn, 'a')
OO.write('Protein_ID\t-\tCas_Model\t-\tCas_E_value\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\tProtein_Description\tSpecies_Name\n')

def replaceitems(line,rr,ww):
	words=line.replace('%s' % rr,'%s' % ww)
	return words


for line in II:
	line=line.rstrip()
	words=replaceitems(line,' ','_')
	while '__' in words:
		words=replaceitems(words, '__','\t')
	while '\t\t' in words:
		words=replaceitems(words, '\t\t','\t')
	words=replaceitems(words, '\t_', '\t')
	words=replaceitems(words, '_\t', '\t')
	for i in range(0,9):
		words=replaceitems(words,'\t%s_' % i, '\t%s\t' % i)	
		words=replaceitems(words,'.%s_' % i, '.%s\t' % i)
		for j in range(0,9):
			words=replaceitems(words,'%s_%s' % (i,j), '%s\t%s' % (i,j))	
	species=words.split('[')
	try:
		species=species[1]
	except IndexError:
		pass
	if '#' in line:
		pass
	else:
		OO.write('%s\t%s\n' % (words,species))

