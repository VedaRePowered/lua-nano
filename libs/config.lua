t = {}

-- use colours red, yellow, green, cyan, blue, magenta, white, black and regular.
-- Opptianally add light or dark to change brightness.
-- Third you can use the on keyword to indicate a background color, then specify that colour from the above list
-- Finnally add revrsed onto the end to indicate the fg color should become the bg colour and vice-versa
t.colours = {
	flow = "green light",			-- control flow functions
	func = "magenta",			-- function declirations
	func2 = "magenta light",		-- function calling
	bracket = "yellow dark",		-- (), [], {}
	logic = "yellow",			-- logical opporators
	math = "yellow light",			-- mathimatical opporators
	comment = "black light",		-- comments
	keyword = "green",			-- eg. return, require, #include, using, etc.
	modify = "blue light",			-- concatination opporators etc.
	string = "blue",			-- strings and chars
	number = "cyan",			-- numbers
	variable = "red",			-- variables
	regular = "regular",			-- default colour
	bold = "blue dark",			-- md and html bold
	italic = "red light",			-- md and html italic
	boldItalic = "magenta",			-- md and html bold and italic
	link = "cyan light",			-- md, html and text links
	bullet = "black light",			-- md bullet and numbered lists
	heading = "yellow",			-- md and html heading
	topBar = "regular dark reverse",	-- gui top bar
	status = "regular dark on red reverse",	-- gui status message
	lowerBar = "regular dark reverse",	-- gui user querrys
	invisables = "regular dark"		-- appers when showInvisables is true, currently not respected
}

-- keybindings, uppercase for ctrl plus that letter, lowwercase for alt plus that letter
t.keys = {
	close = "X",		-- close editor
	save = "O",		-- save current buffer
	refresh = "R",		-- reload the whole editor
	find = "F",		-- simple find
	next = "N",		-- goto next instance
	replace = "G",		-- simple replace
	advFind = "f",		-- advanced (regex) find
	advReplace = "g",	-- advanced (regex) replace -- I'll have to fix this, but currently adcanced replace doesn't work, so just don't use it
	editSettings = "s"	-- show these settings in-editor, currently not supported
}

-- other settings, currently not respected
t.other = {
	tabSize =				4,
	tabTypeOnSave =				hard,
	reloadEntireEditorOnCursorMove =	false,
	linesToScrollAtBottomOfScreen =		1,
	invisablesCarageReturn =		"*",
	invisablesUnixNewLine =			"\\",
	invisablesHardTab =			">>",
	invisablesSoftTab =			"|>",
	invisablesSpace =			".",
	showInvisables =			false,
	saveOnClose =				false,
	loadPreviousOnStart =			false,
	exitOnSave =				false
}

return t
