#!/usr/bin/python
'''
Takes the list of paths to CRISPRDetect files from the r output and copies the files to the CRISPRDetect files.
input file example output.genomes_with_single_subtype.txt
output location example is /home/tomn/masters/DB/CRISPRDetect/

'''
import sys
import subprocess
def RemoveRedundant(List):
	List=str(List)
	List=List.replace('[','')
	List=List.replace(']','')
	List=List.replace("'","")
	List=List.replace('"','')
	List=List.replace(',','')
	return List#remove_extra_characters_from_list_function


ff= sys.argv[1]
nn=sys.argv[2]
II=open(ff,'r')
OO=open('%s'%nn,'a')
#OO.write('#!/bin/bash\n')

dd = {}

for line in II:
	if 'CRISPRDetect_path' in line:
		print line
		pass
	else:
		line=line.rstrip()
		words=line.split('\t')
		class_name=words[7]
		file_path=words[6]
		print file_path
		system_name=words[4]
		system_name=system_name.replace(',','')
		system_name=system_name.replace('CAS-','')
		y = '%s_%s' %(class_name,system_name)
		if y in dd:
			pass
		else:
			dd[y]=1		
		x='cat %s >> %s_%s_CRISPRDetect.txt|| echo %s >> Genomes_without_CRISPRDetect_files.txt' %(file_path,class_name,system_name,file_path)
		#print x
		subprocess.call([x], shell=True)	
		
			
for key, value in dd.items():
	words = key.split('_')
	domain=words[0]
	subtypes=words[1]
	print '%s_CRISPRDetect.txt' % key
	try:
		II=open('%s_CRISPRDetect.txt' % key, 'r')
		II.seek(0)
		for line in II:
			line=line.rstrip()
			if '>' in line:
				line=line.replace('>','')
				OO.write('>%s|%s|%s\n' %(domain,subtypes,line))
			else:
				OO.write('%s\n' % line)
	except IOError:
		print 'No arrays in %s' % key