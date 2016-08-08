#!/usr/bin/python
'''
Keeps only one result for each protein and removes all the rest. The file is left in the same format. 
I have noticed that in some cases there is the same accession number for a protein in two 
different organisms. Only one of the results is kept at the moment. I may have to change this.
'''
import math
import sys
ff = sys.argv[1]
def ChangeSpaceTab(line):
	words=line.rstrip()
	names=words.replace(' ','\t')
  while '\t\t' in names:
  	names=names.replace('\t\t','\t')
	return(names)#find_and_replace_space_with_tab
def RemoveRedundant(List):
	List=str(List)
	List=List.replace('[','')
	List=List.replace(']','')
	List=List.replace("'","")
	return List#remove_extra_characters_from_list_function
InFile = open(ff, 'r') # hmmsearch output file
OutFile = open('%s_non_redundant.txt' % ff, 'a')
AccDict = {}
for line in InFile:
	names = ChangeSpaceTab(line)
	names=names.split('\t')
	if '#' in line:# these line contain descriptors and other info but not the matches to models
		pass
	else:
		Acc = names[0] #accession number for the protein
		value = names[0:5]
		value = RemoveRedundant(value)
		if Acc in AccDict:
			x = AccDict[Acc]
			x = RemoveRedundant(x)
			x =x.split(',')
			x = x[4]
			x = RemoveRedundant(x)			
			x = float(x)
			value=value.split(',')
			Score = value[4]
			Score = RemoveRedundant(Score)
			Score = float(Score)
			if x > Score:
				pass
			else:
				AccDict[Acc]=value
		else:
			AccDict[Acc]=value#Builds the dictionary with protein name as the key and line as the value
InFile.seek(0)
for line in InFile:
	names = ChangeSpaceTab(line)
	words=names.split('\t')
	if '#' in line:# these line contain descriptors and other info but not the matches to models
		OutFile.write('%s' % line)
	else:
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
			
