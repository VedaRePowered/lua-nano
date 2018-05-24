local draw = {}
local scroll = 0
local xRes, yRes = getRes()

function draw.topBar()

	term.cursor.jump(1, 1)

	io.write(colours.reverse .. "")
	for i = 1, xRes do
		io.write(" ")
	end

	term.cursor.jump(1, 3)
	io.write("lua nano p0.2.2")

	io.write(colours.onblack .. "")
	local time = os.date("%a:%b:%d %I:%M")
	term.cursor.jump(1, xRes/2-string.len(time)/2)
	io.write(time .. colours.reset .. colours.reverse)

	term.cursor.jump(1, xRes-1-string.len(buffer.getName()))
	io.write(buffer.getName())

	io.write(colours.reset .. "")

end

function draw.fullText()

	for n, l in ipairs(buffer.getLines(scroll+1, yRes-3)) do
		term.cursor.jump(n+1, 1)
		io.write(l)
	end

end

function draw.currentLine()

	local curPos = cursor.y - scroll
	if curPos < 1 then
		scroll = scroll - 1
		curPos = 1
		draw.drawAll()
	end
	if curPos > yRes-2 then
		scroll = scroll + 1
		curPos = yRes - 2
		draw.drawAll()
	end

	term.cursor.jump(curPos+1, 1)
	term.cleareol()
	io.write(buffer.getLines(cursor.y)[1])

	term.cursor.jump(curPos+1, cursor.x)

end

function draw.save()

	term.cursor.jump(yRes, 1)
	io.write(colours.reverse .. "")
	for i = 1, xRes do
		io.write(" ")
	end
	term.cursor.jump(yRes, 1)
	io.write("File name to write [" .. buffer.getName() .. "]: ")
	local name = io.read()
	if name ~= "" then
		buffer.setName(name)
	end

	draw.drawAll()

end

function draw.status()

	local statusText = status.get()
	term.cursor.jump(yRes, xRes/2-string.len(statusText)/2)
	io.write(colours.red .. colours.onblack .. statusText .. colours.reset)

end

function draw.drawAll()
	xRes, yRes = getRes()
	os.execute("clear")
	draw.topBar()
	draw.status()
	draw.fullText()
end

function draw.draw()
	xRes, yRes = getRes()
	draw.topBar()
	draw.status()
	draw.currentLine()
end

return draw
