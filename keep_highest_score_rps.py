#!/usr/bin/python
'''
Keeps only one result for each protein and removes all the rest. The file is left in the same format. 
I have noticed that in some cases there is the same accession number for a protein in two 
different organisms. Only one of the results is kept at the moment. I may have to change this.

input file example output.cddtable.txt
outputfile example output.cddnr.tab

'''
import math
import sys
ff = sys.argv[1]
nn = sys.argv[2]

def RemoveRedundant(List):
	List=str(List)
	List=List.replace('[','')
	List=List.replace(']','')
	List=List.replace("'","")
	return List#remove_extra_characters_from_list_function

InFile = open(ff, 'r') # hmmsearch output file
OutFile = open(nn, 'a')


AccDict = {}
for line in InFile:
	names=line.rstrip()
	names=names.split('\t')
	Acc = names[0] #accession number for the protein
	if Acc=='No_hits':
		pass
	else:
		value = names[0:4]
		value = RemoveRedundant(value)
		if Acc in AccDict:
			x = AccDict[Acc]
			x = RemoveRedundant(x)
			x =x.split(',')
			x = x[3]
			x = RemoveRedundant(x)			
			x = float(x)
			value=value.split(',')
			Score = value[-1]
			Score = RemoveRedundant(Score)
			if 'Cdd' in Score:
				pass
			else:
				Score = float(Score)
				if x > Score:
					pass
				else:
					AccDict[Acc]=value

		else:
			AccDict[Acc]=value#Builds the dictionary with protein name as the key and line as the value


InFile.seek(0)
for line in InFile:
	if 'No_hits' in line:
		OutFile.write('%s' % line)
	else:
		names=line
		words=names.split('\t')
		Acc = words[0]
		if Acc in AccDict:
			ll = AccDict[Acc]
			ll=str(ll)
			ll=ll.replace(',','')
			ll=ll.replace(' ','\t')
			if ll in names:
				OutFile.write('%s' % line)
			else:
				pass
		else:
			pass

