t = {}

-- use colours red, yellow, green, cyan, blue, magenta, white, black and regular. Opptianally add light or dark to the end(with a space).
t.colours = {
	flow = "green light",
	func = "magenta",
	func2 = "magenta light",
	bracket = "yellow dark",
	logic = "yellow",
	math = "yellow light",
	comment = "black light",
	keyword = "green",
	modify = "blue light",
	string = "blue",
	number = "cyan",
	variable = "red",
	regular = "regular",
	bold = "blue dark",
	italic = "red light",
	boldItalic = "magenta",
	link = "cyan light",
	bullet = "black light",
	heading = "yellow",
	topBar = "regular dark reverse",
	status = "regular dark on red reverse",
	lowerBar = "regular dark reverse"
}

t.keys = {
	close = "X",
	save = "O",
	refresh = "R",
	find = "F",
	next = "N",
	replace = "G",
	advFind = "f",
	advReplace = "" -- I'll have to fix this, but currently adcanced replace doesn't work, so just don't use it
}

return t
