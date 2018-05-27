#!/usr/bin/lua5.1

-- functions
function getKey()
	os.execute("stty cbreak </dev/tty >/dev/tty 2>&1") 
	local key = io.read(1) 
	os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
	draw.currentLine()
	return key
end

function getRes()

	os.execute("stty -a | grep rows | sed \'s/;/\\n/g\' | grep -e rows -e columns > tmp")
	local f = io.open("tmp")
	local xRes, yRes = f:read("*line"), f:read("*line")
	xRes, yRes = string.sub(xRes, 7, string.len(xRes)), string.sub(yRes, 10, string.len(yRes))
	os.execute("rm tmp")

	return yRes, xRes

end

-- requirements
status = require "status"
term = require "term"
colours = term.colors
conf = require "confLoad"
syntax = require "syntax"
word = require "word"
buffer = require "buffer"
cursor = require "cursor"
draw = require "draw"
update = require "update"

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
os.execute("stty isig icanon iexten ixoff echo")
term.clear()
os.execute("clear")
term.cursor.jump(1, 1)

