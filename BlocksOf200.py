#!/usr/bin/python
import sys
ff=sys.argv[1]
nn=sys.argv[2]
II = open(ff)
OO = open(nn, 'a')
n=0
for line in II:
	line=line.strip()
	n=n+1
	if n == 200:
		n=0
		OO.write('%s\n' % line)
	else:
		OO.write('%s,' % line)
		
