#!/usr/bin/python
'''

'''
import sys
ff = sys.argv[1]
nn = sys.argv[2]

def RemoveRedundant(List):
	List=str(List)
	List=List.replace('[','')
	List=List.replace(']','')
	List=List.replace("'","")
	return List#remove_extra_characters_from_list_function

II = open(ff) # hmmsearch output file
OO = open(nn, 'a')

for line in II:
	line=line.rstrip()
	if 'Target file:' in line:
		words=line.split('#')
		names=words[-1]
		names=RemoveRedundant(names)
		OO.write('\t%s\n' % names)
	elif '#' in line:
		pass
	else:
		words=line.split(' ')
		names=words[0]
		names=RemoveRedundant(names)
		OO.write('%s,' % names)
				


