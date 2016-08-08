#!/usr/bin/python
'''
Xml file used to produce ii_cdd_comp.txt which contains a column with the cdd numbers and 
the corresponding names beside them. 
'''
import sys

ff = sys.argv[1]
nn = sys.argv[2]
II=open(ff, 'r')
oo=open(nn, 'a')
oo.write('Cdd_ID\tCdd_Name\tCdd_Description\n')
for line in II:
	line=line.rstrip()
	if '<Id>' in line:
		words=line.split('>')
		id=words[1]
		id=id.split('<')
		id=id[0]
		oo.write('%s\t' % id)
	elif 'Accession' in line:
		names=line.split('>')
		name=names[1]
		name=name.split('<')
		name=name[0]
		oo.write('%s\t' % name)
	elif 'Subtitle' in line:
		description=line.split('>')
		if description[1][0]=='<':
			oo.write('-\n')				
		else:
			description=description[1]
			description=description.split('<')
			description=description[0]
			description=description.replace(' ','_')
			oo.write('%s\n' % description)				
	else:
		pass
