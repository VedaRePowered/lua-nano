#!/usr/bin/lua5.1

-- function
function getch_unix() 
	os.execute("stty cbreak </dev/tty >/dev/tty 2>&1") 
	local key = io.read(1) 
	os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
	return key
end

-- requirements
local term = require "term"

-- aleises
local colours = term.colors

print(colours.red .. "R" .. colours.green .. "G" .. colours.blue .. "B" .. colours.reset)
