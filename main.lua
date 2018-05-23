#!/usr/bin/lua5.1

-- functions
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

for i = 1, 10 do
	print(colours.white .. "W" .. colours.red .. "R" .. colours.green .. "G" .. colours.blue .. "B" .. colours.reverse)
	print(colours.black .. "K" .. colours.magenta .. "M" .. colours.yellow .. "Y" .. colours.cyan .. "C" .. colours.reset)
end
