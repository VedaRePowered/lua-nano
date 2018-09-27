#!/usr/bin/lua5.3

-- functions
function getVersion() -- get the current version (hardcoded)
	return "p0.6.1"
end

function getKey()
	os.execute("stty cbreak </dev/tty >/dev/tty 2>&1") -- set currect terminal mode for reading one character
	local key = io.read(1) -- read the byte
	os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1") -- reset terminal
	draw.currentLine() -- redraw the current line, just in case the character was drawn to the screen
	return key -- return the key
end

function getRes()

	os.execute("stty -a | grep rows | sed \'s/;/\\n/g\' | grep -e rows -e columns > tmp") -- run a shell command to output the shell resolution the file tmp
	local f = io.open("tmp") -- open the tmp file
	local xRes, yRes = f:read("*line"), f:read("*line") -- read the resolution from the file
	xRes, yRes = string.sub(xRes, 7, string.len(xRes)), string.sub(yRes, 10, string.len(yRes)) -- get just the number for x and y resolution
	os.execute("rm tmp") -- remove the tmp file

	return yRes, xRes -- return the resolution

end

-- log stuff
os.execute("rm log.out && touch log.out") -- re-create the log file
function log(strs, dbt) -- function for logging
	if not dbt then -- debug type either pnt for print, err for error, wrn for warning, dbg for debuging, and log for logging
		dbt = "PNT"
	end
	-- get what to log
	local out = ""
	if type(strs) == "table" then
		for i, s in ipairs(strs) do
			out = out .. s
		end
	else
		out = strs
	end
	os.execute("echo \"[" .. dbt .. "]" .. out .. "\" >> log.out") -- actually log it
end

-- requirements
status = require "libs.status"
term = require "term"
colours = term.colors
conf = require "libs.confLoad"
syntax = require "libs.syntax"
word = require "libs.word"
buffer = require "libs.buffer"
cursor = require "libs.cursor"
draw = require "libs.draw"
update = require "libs.update"
find = require "libs.find"

-- open file
if #arg > 0 then
	buffer.open(arg[1])
end

-- prepare screen
draw.drawAll()
os.execute("stty -isig -icanon -iexten -ixoff -echo")

-- main loop
running = true
while running do

	draw.draw()
	update(getKey())

end

-- clean everything up
os.execute("stty isig icanon iexten ixoff echo")
term.clear()
os.execute("clear")
term.cursor.jump(1, 1)

