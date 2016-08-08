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
	List=List.replace('"','')
	List=List.replace(',','')
	return List#remove_extra_characters_from_list_function

II = open(ff) # hmmsearch output file
OO = open(nn, 'a')

def build_dict_with_inserted_funtction(xx,delim, key_pos, value_pos):
	dd={}
	for line in xx:
		words=line.rstrip()
		names=words.split(delim)
		key=names[key_pos]
		value=names[value_pos]
		if key in dd:
			key=str(key)
			yy = dd[key]
			yy=RemoveRedundant(yy)
			if 'Generic' in yy:
				pass
			elif value in yy:
				pass
			else:		
				value=value.split('\t')
				dd[key].append(value)
		else:
			value=value.split('\t')
			dd[key]=value
	return dd
def output_dict(dd):
	for key,value in dd.items():
		key = RemoveRedundant(key)			
		value = RemoveRedundant(value)			
		if 'CRISPR_Type' in value:
			pass
		else:
			OO.write('%s\t%s\n' % (key,value))
	print 'key and value written to file'

dd = build_dict_with_inserted_funtction(II,'\t',3,2)
output_dict(dd)
