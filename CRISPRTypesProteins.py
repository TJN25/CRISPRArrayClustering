#!/usr/bin/python
'''

'''
import sys
ff = sys.argv[1]
dd = sys.argv[2]
nn = sys.argv[3]

def RemoveRedundant(List):
	List=str(List)
	List=List.replace('[','')
	List=List.replace(']','')
	List=List.replace("'","")
	List=List.replace('"','')
	List=List.replace(',','')
	return List#remove_extra_characters_from_list_function

II = open(ff) # hmmsearch output file
DD = open(dd)
OO = open(nn, 'a')

dd={}
for line in DD:
	line=line.replace(',','|')
	words=line.rstrip()
	names=words.split('\t')
	try:
		proteins=names[0]
		genome=names[1]
		proteins=str(proteins)
		proteins=proteins.split('|')
		protein_length=len(proteins)-1
		for i in range(0,protein_length):
			key=proteins[i]
			key=RemoveRedundant(key)
			dd[key]= genome
	except IndexError:
		print line

for line in II:
	line=line.rstrip()
	line=line.replace(',','|')
	line=RemoveRedundant(line)
	words=line.split('\t')
	proteinID=words[1]
	casmodel=words[2]
	types=words[-1:]
	types=str(types)
	types=types.split('|')
	proteinID=RemoveRedundant(proteinID)
	casmodel=RemoveRedundant(casmodel)
	types=RemoveRedundant(types)
	if 'Cas_Model	Cas_E_value' in line:
		OO.write('Protein_ID\tCas_Model\tCRISPR_Type\tGenome\n' )
	else:
		try:
			genome_name=dd[proteinID]
			OO.write('%s\t%s\t%s\t%s\n' %(proteinID,casmodel,types,genome_name) )
		except KeyError:
			pass
