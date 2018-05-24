buffer = {}
currentBuffer = {
	lines = {
		"Welcome to lua nano!",
		"to start using lua nano do one of the following: ",
		"1:    Erase this then use ^o to save the file with a new name",
		"2:    Use ^X to close this file and open lua nano with a file",
		"3:    Goto github.com/BEN1JEN/lua-nano and read the readme.md"
	},
	name="Untitled.txt"
}

function buffer.open(file)

	currentBuffer.name = file

	currentBuffer.lines = {}
	lines = currentBuffer.lines

	os.execute("touch " .. file)
	local f = io.open(file)
	line = true
	while line do
		line = f:read("*line")
		lines[#lines+1] = line
	end

	if #lines < 1 then
		lines[1] = ""
	end

	status.set("Opened File " .. file)

end

function buffer.getName()
	return currentBuffer.name
end

function buffer.setName(name)
	currentBuffer.name = name
end

function buffer.getLines(start, amount)
	if not amount then
		if not start then
			amount = #currentBuffer.lines
		else
			amount = 1
		end
	end
	if not start then
		start = 1
	end

	local returnLines = {}
	for i = start, start+amount do
		returnLines[#returnLines + 1] = currentBuffer["lines"][i]
	end

	return returnLines

end

function buffer.writeString(write, y, x)
	local lines = currentBuffer.lines

	if not y then y = 1 end
	if not x then
		x = 1
		lines[y] = ""
	end

	lines[y] = string.sub(lines[y], 1, x-1) .. write .. string.sub(lines[y], x-1+string.len(write), string.len(lines[y]))
end

function buffer.getName()

	return currentBuffer.name

end

function buffer.erase(len, y)
	if not len then
		len = 1
	end
	if not y then
		y = cursor.y
	end

	local lines = currentBuffer.lines
	lines[y] = string.sub(lines[y], 1, cursor.x-len-1) .. string.sub(lines[y], cursor.x, string.len(lines[y]))

end

function buffer.write()
	local stringBuffer = ""
	for n, l in ipairs(currentBuffer.lines) do
		stringBuffer = stringBuffer .. l .. "\n"
	end
	local tmp = io.output()
	local f = io.open(currentBuffer.name, "w+")
	io.output(f)
	io.write(stringBuffer)
	io.output(tmp)
	f:close()

	status.set("Saved As " .. currentBuffer.name)

end

return buffer
