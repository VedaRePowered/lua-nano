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

	os.execute("stty -a | grep rows | sed \'s/;/\\n/g\' | grep -e rows -e columns > tmp.txt")
	local f = io.open("tmp.txt")
	local xRes, yRes = f:read("*line"), f:read("*line")
	xRes, yRes = string.sub(xRes, 7, string.len(xRes)), string.sub(yRes, 10, string.len(yRes))

	return yRes, xRes

end

-- requirements
term = require "term"
buffer = require "buffer"
cursor = require "cursor"
draw = require "draw"
update = require "update"

-- aleises
colours = term.colors

-- open file
buffer.open("testFile.txt")

-- prepare screen
draw.drawAll()

-- main loop
running = true
while running do

	draw.draw()
	update(getKey())

end

term.clear()
os.execute("clear")
term.cursor.jump(1, 1)

