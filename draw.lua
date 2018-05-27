local draw = {}
local scroll = 0
local xRes, yRes = getRes()

function draw.topBar()

	term.cursor.jump(1, 1)

	io.write(colours.reset .. colours.dim .. colours.reverse)
	for i = 1, xRes do
		io.write(" ")
	end

	term.cursor.jump(1, 3)
	io.write("lua nano p0.5.1")

	local time = os.date("%a:%b:%d %I:%M")
	term.cursor.jump(1, xRes/2-string.len(time)/2)
	io.write(time)

	term.cursor.jump(1, xRes-1-string.len(buffer.getName()))
	io.write(buffer.getName())

	io.write(colours.reset .. "")

end

function draw.fullText()

	for n, l in ipairs(buffer.getLines(scroll+1, yRes-3)) do
		term.cursor.jump(n+1, 1)
		syntax.write(l)
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
	syntax.write(buffer.getLines(cursor.y)[1])

	term.cursor.jump(curPos+1, cursor.x)

end

function draw.save()

	term.cursor.jump(yRes, 1)
	io.write(colours.reset .. colours.dim .. colours.reverse .. "")
	for i = 1, xRes do
		io.write(" ")
	end
	term.cursor.jump(yRes, 1)
	io.write("File name to write [" .. buffer.getName() .. "]: ")

	os.execute("stty isig icanon iexten ixoff echo")
	local name = io.read()
	os.execute("stty -isig -icanon -iexten -ixoff -echo")

	if name ~= "" and string.lower(name) ~= "cancel" then
		buffer.setName(name)
	end

	draw.drawAll()

	return string.lower(name) == "cancel"

end

function draw.status()

	local statusText = status.get()
	term.cursor.jump(yRes, 1)
	term.cleareol()
	term.cursor.jump(yRes, xRes/2-string.len(statusText)/2)
	io.write(colours.dim .. colours.reverse .. colours.onred .. statusText .. colours.reset)

end

function draw.drawAll()
	xRes, yRes = getRes()
	os.execute("clear")
	term.clear()
	draw.topBar()
	draw.status()
	draw.fullText()
	draw.currentLine()
end

function draw.draw()
	xRes, yRes = getRes()
	draw.topBar()
	draw.status()
	draw.currentLine()
end

return draw
