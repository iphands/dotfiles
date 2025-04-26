#!/usr/bin/env python
import gi; gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk
from functools import reduce
import sys, os, re




Colors = {
	'AB' : { 'Name' : 'Accent Back' },
	'AF' : { 'Name' : 'Accent Fore' },
	'NB' : { 'Name' : 'Normal Back' },
	'NF' : { 'Name' : 'Normal Fore' },
}




Dir = os.path.dirname(os.path.realpath(sys.argv[0]))




Src = []
Cur = []




with open(Dir + '/themerc.in') as f: Src = f.readlines()
with open(Dir + '/themerc') as f: Cur = f.readlines()




def LoadColors (ls, keys):
	for l in ls:
		if l.startswith('#'):
			ss = l.strip().split(' ')
			for k in keys:
				Colors[ss[0].lstrip('#')][k] = ss[len(ss) - 1]




LoadColors(Src, ('Color', 'Initial', 'Default'))
LoadColors(Cur, ('Color', 'Initial'))




def Rgb8 (c):
	return [int(c[i:i+2], 16) for i in (1, 3, 5)]

def Hex8FromRgb8 (c):
	return '#%02x%02x%02x' % tuple(c)

def Hex8FromRgb (c):
	return Hex8FromRgb8 (
		map(lambda f: int(f * 0xFF), c)
	)




def Parse (s):
	
	def pone (c):
		if (c.startswith('#')): return Rgb8(c)
		else: return Rgb8(Colors[c]['Color'])
	
	def addc (a, b):
		return map(lambda c0, c1: c0 + c1, a, b)
	
	def divc (c, d):
		return map(lambda c: c / d, c)
	
	cs = [pone(c) for c in s.split(' ')];
	return Hex8FromRgb8(divc(reduce(addc, cs), len(cs)))


def Go ():
	
	out = []
	
	for ck in Colors:
		out.append('#' + ck + ' ' + Colors[ck]['Color'])
	
	for l in Src:
		
		l = l.strip()
		
		if not len(l): continue
		if l.startswith('#'): continue
		elif '{' in l:
			s = re.split('{|}', l)
			out.append(s[0] + Parse(s[1]))
		else: out.append(l)
	
	out = '\n'.join(out)
	with open(Dir + '/themerc', 'w') as of: of.write(out)
	os.system('openbox --reconfigure')


def Reveal ():
	for c in Colors.values():
		c['Button'].set_color(Gdk.color_parse(c['Color']))


def Reset (key):
	for c in Colors.values():
		c['Color'] = c[key]
	Reveal()

def FromGtk ():
	
	m = Gtk.Menu()
	i = Gtk.MenuItem()
	w = Gtk.Window()
	m.add(i)
	
	ms = i.get_style_context()
	ws = w.get_style_context()
	
	def ccc (key, gc):
		Colors[key]['Color'] = Hex8FromRgb([gc.red, gc.green, gc.blue])
	
	ccc('AB', ms.get_background_color(Gtk.StateFlags.PRELIGHT))
	ccc('AF', ms.get_color(Gtk.StateFlags.PRELIGHT))
	ccc('NB', ws.get_background_color(Gtk.StateFlags.NORMAL))
	ccc('NF', ws.get_color(Gtk.StateFlags.NORMAL))
	
	Reveal()




W = Gtk.Window(title = "Lean")
W.connect("destroy", lambda e: Gtk.main_quit())
		
W.set_position(Gtk.WindowPosition.CENTER)
W.set_resizable(False)
W.set_border_width(8)

CList = Gtk.Grid()
CList.set_row_spacing(4)
CList.set_column_spacing(4)
CList.Rows = 0

def SetC (ck, gc):
	Colors[ck]['Color'] = Hex8FromRgb(gc.to_floats())

for ck in sorted(Colors):
	
	c = Colors[ck]
	
	clbl = Gtk.Label(c['Name'] + ':')
	cbtn = c['Button'] = Gtk.ColorButton(color = Gdk.color_parse(c['Color']))
	cbtn.connect('color-set', lambda b, k: SetC(k, b.get_color()), ck)
	
	CList.attach(clbl, 0, CList.Rows, 1, 1)
	CList.attach(cbtn, 1, CList.Rows, 1, 1)
	
	CList.Rows = CList.Rows + 1;

DefBtn = Gtk.Button("Default")
RevertBtn = Gtk.Button("Revert")
GtkBtn = Gtk.Button("From GTK")
GoBtn = Gtk.Button("Apply")

DefBtn.connect('clicked', lambda e: Reset('Default'))
RevertBtn.connect('clicked', lambda e: Reset('Initial'))
GtkBtn.connect('clicked', lambda e: FromGtk())
GoBtn.connect('clicked', lambda e: Go())

RootBox = Gtk.VBox(spacing = 8)
RootBox.pack_start(DefBtn, True, True, 0)
RootBox.pack_start(GtkBtn, True, True, 0)
RootBox.pack_start(CList, True, True, 0)
RootBox.pack_start(RevertBtn, True, True, 0)
RootBox.pack_start(GoBtn, True, True, 0)
W.add(RootBox)
		
W.show_all()
Gtk.main()
