buffer = {} -- buffer namespace
currentBuffer = { -- currently opened file buffer
	lines = { -- content of the file
		"Welcome to lua nano!",
		"to start using lua nano do one of the following:",
		"1:    Erase this then use ^o to save the file with a new name",
		"2:    Use ^X to close this file and open lua nano with a file",
		"3:    Goto github.com/BEN1JEN/lua-nano and read the readme.md"
	},
	name="welcome.txt" -- name of the file
}

function buffer.open(file) -- function for loading a file

	currentBuffer.name = file -- set current buffer file name

	currentBuffer.lines = {} -- reset buffer content
	lines = currentBuffer.lines -- set the lines variable to point to the current buffer content

	os.execute("touch " .. file) -- make sure the file exists
	local f = io.open(file) -- use lua stdio open the file
	line = true -- hack to start the for loop off, could be replaced with a do while loop
	while line do
		line = f:read("*line") -- set line to the current file line
		if line then -- if the line exists, replace hard tabs with soft ones =O
			line = string.gsub(line, "\t", "    ")
		end
		lines[#lines+1] = line -- add the line to the current buffer content
	end

	if #lines < 1 then -- I don't know what this is doing
		lines[1] = ""
	end

	status.set("Opened File " .. file) -- set the status message

end

function buffer.getName() -- get the current buffer file name
	return currentBuffer.name
end

function buffer.setName(name) -- set the current buffer file name
	currentBuffer.name = name
end

function buffer.getLines(start, amount) -- get amount lines from start in the current buffer content
	if not amount then -- default amount value
		if not start then
			amount = #currentBuffer.lines -- if no start value was givin, return every line
		else
			amount = 1 -- otherwise only read one line
		end
	end
	if not start then -- default start value
		start = 1
	end

	local returnLines = {} -- create a new table for output
	for i = start, start+amount do -- go through the current buffer content and add lines to the output table
		returnLines[#returnLines + 1] = currentBuffer["lines"][i]
	end

	return returnLines -- return the output table

end

function buffer.writeString(write, y, x, insert) -- write a string to the current buffer content on line y, starting at x
	local lines = currentBuffer.lines -- set the lines variable to point to the current buffer content

	if not y then y = 1 end -- default to the first line
	if not x then -- overwrite the entire line if no x was specified
		x = 1
		lines[y] = ""
	end

	if insert then
		lines[y] = string.sub(lines[y], 1, x-1) .. write .. string.sub(lines[y], x+string.len(write), string.len(lines[y])) -- insert the string
	else
		lines[y] = string.sub(lines[y], 1, x-1) .. write .. string.sub(lines[y], x, string.len(lines[y])) -- overwrite with the string
	end
end

function buffer.erase(len, y) -- erase from the cursur position
	if not len then -- default length
		len = 1
	end
	if not y then -- default y
		y = cursor.y
	end

	local lines = currentBuffer.lines -- set the lines variable to point to the current buffer content
	lines[y] = string.sub(lines[y], 1, cursor.x-len-1) .. string.sub(lines[y], cursor.x, string.len(lines[y])) -- preform the erasion

end

function buffer.eraseLine() -- erase the line the cursur is on
	local lines = currentBuffer.lines -- set the lines variable to point to the current buffer content
	lines[cursor.y-1] = lines[cursor.y-1] .. table.remove(lines, cursor.y) -- preform the erasion
end

function buffer.write() -- write the current buffer to a file

	-- convert the current buffer content to a string
	local stringBuffer = ""
	for n, l in ipairs(currentBuffer.lines) do
		stringBuffer = stringBuffer .. l .. "\n"
	end

	-- I don't know what this does
	local tmp = io.output()
	local f = io.open(currentBuffer.name, "w+")
	io.output(f)

	local stringBuffer = string.gsub(stringBuffer, "    ", "\t") -- fix soft tabs to hard tabs! XD

	io.write(stringBuffer)
	io.output(tmp)
	f:close()

	status.set("Saved As " .. currentBuffer.name) -- set the status message

end

function buffer.newLine() -- insert a new line like a text editor would

	local lines = currentBuffer.lines -- set the lines variable to point to the current buffer content

	local newLine = string.sub(lines[cursor.y], cursor.x, string.len(lines[cursor.y])) -- set this variable to whatever is in between the cursor and the end of the line
	lines[cursor.y] = string.sub(lines[cursor.y], 1, cursor.x-1) -- erase whatevers between the cursor and the end of the line
	table.insert(lines, cursor.y+1, newLine) -- insert the above variable on a new line

end

return buffer -- return the namespace
