buffer = {}
currentBuffer = {lines = {}, name="Untitled.txt"}

function buffer.open(file)

	currentBuffer.name = file

	lines = currentBuffer.lines
	local f = io.open(file)
	line = true
	while line do
		line = f:read("*line")
		lines[#lines+1] = line
	end

end

function buffer.getName()

	return currentBuffer.name

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

return buffer
