#!/usr/bin/env python
import sys, os, re




XfwmThings = {
	
	'menu'             : [ 'active', 'inactive', 'prelight', 'pressed' ],
	'hide'             : [ 'active', 'inactive', 'prelight', 'pressed' ],
	'shade'            : [ 'active', 'inactive', 'prelight', 'pressed' ],
	'shade-toggled'    : [ 'active', 'inactive', 'prelight', 'pressed' ],
	'stick'            : [ 'active', 'inactive', 'prelight', 'pressed' ],
	'stick-toggled'    : [ 'active', 'inactive', 'prelight', 'pressed' ],
	'maximize'         : [ 'active', 'inactive', 'prelight', 'pressed' ],
	'maximize-toggled' : [ 'active', 'inactive', 'prelight', 'pressed' ],
	'close'            : [ 'active', 'inactive', 'prelight', 'pressed' ],
	
	'top-left'     : [ 'active', 'inactive' ],
	'title-1'      : [ 'active', 'inactive' ],
	'title-2'      : [ 'active', 'inactive' ],
	'title-3'      : [ 'active', 'inactive' ],
	'title-4'      : [ 'active', 'inactive' ],
	'title-5'      : [ 'active', 'inactive' ],
	'top-right'    : [ 'active', 'inactive' ],
	'right'        : [ 'active', 'inactive' ],
	'bottom-right' : [ 'active', 'inactive' ],
	'bottom'       : [ 'active', 'inactive' ],
	'bottom-left'  : [ 'active', 'inactive' ],
	'left'         : [ 'active', 'inactive' ],
}

XfwmTypes = {
	"frame-active"    : ( 'frame'  , ['active', 'prelight', 'pressed'] ),
	"frame-inactive"  : ( 'frame'  , ['inactive']                      ),
	"bottom-active"   : ( 'bottom' , ['active']                        ),
	"bottom-inactive" : ( 'bottom' , ['inactive']                      ),
	"border-active"   : ( 'border' , ['active', 'prelight', 'pressed'] ),
	"border-inactive" : ( 'border' , ['inactive']                      ),
	"icon-active"     : ( 'icon'   , ['active']                        ),
	"button-active"   : ( 'button' , ['active']                        ),
	"icon-lit"        : ( 'icon'   , ['prelight']                      ),
	"button-lit"      : ( 'button' , ['prelight']                      ),
	"icon-pressed"    : ( 'icon'   , ['pressed']                       ),
	"button-pressed"  : ( 'button' , ['pressed']                       ),
	"icon-inactive"   : ( 'icon'   , ['inactive']                      ),
	"button-inactive" : ( 'button' , ['inactive']                      ),
}


AssPath = sys.argv[1]
DefPath = sys.argv[2]
OutPath = sys.argv[3]


InF = open(DefPath)
InLines = [l.split() for l in InF.read().split("\n") if len(l)]
InF.close()

try: os.makedirs(OutPath)
except: pass

TrcF = open(OutPath + "/themerc", 'w')
TrcF.write('show_app_icon=true\n');

for l in InLines:
	if l[0] == 'themerc':
		TrcF.write(l[1] + '\n')

inames = [f for f in os.listdir(AssPath) if f.endswith('.xpm')]

for iname in inames:
	
	inf = open(AssPath + "/" + iname)
	instr = inf.read()
	inf.close()
	
	pref = iname.split('-?')[0]
	states = XfwmThings[pref]
	
	for state in states:
		
		oname = pref + "-" + state + ".xpm"
		ostr = instr.replace('{name}', oname.replace('-', '_').replace('.', '_'))
		
		for row in InLines:
			
			if row[0] == 'themerc': continue
			cid, states = XfwmTypes[row[0]]
			
			if state in states:
				sym = '' if len(row) is 2 else ' s ' + row[2]
				ostr = re.compile('\#.*\{' + cid + '\}').sub(row[1] + sym, ostr)
		
		ouf = open(OutPath + '/' + oname, 'w')
		ouf.write(ostr)
		ouf.close()

TrcF.close()
