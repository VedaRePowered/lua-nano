local draw = {}
local scroll = 0
local xRes, yRes = getRes()

function draw.ask(text)

	term.cursor.jump(yRes, 1)
	--io.write(colours.reset .. colours.dim .. colours.reverse)
	io.write(conf.getColours().lowerBar)
	for i = 1, xRes do
		io.write(" ")
	end
	term.cursor.jump(yRes, 1)
	io.write(text, ": ")

	os.execute("stty isig icanon iexten ixoff echo")
	local r = io.read()
	os.execute("stty -isig -icanon -iexten -ixoff -echo")

	return r

end

function draw.topBar()

	term.cursor.jump(1, 1)

	io.write(conf.getColours().topBar)

	--io.write(colours.reset .. colours.dim .. colours.reverse)
	
	for i = 1, xRes do
		io.write(" ")
	end

	term.cursor.jump(1, 3)
	io.write("lua nano p0.6.0")

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

function draw.find()
	local text = draw.ask("Find what?")
	return text
end

function draw.replace()
	local text = draw.ask("Find what?")
	local replace = draw.ask("Replace with")
	return text, replace
end

function draw.save()

	local name = draw.ask("File name to write [" .. buffer.getName() .. "]")

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
	term.cursor.jump(yRes, math.floor(xRes/2-string.len(statusText)/2))
	--io.write(colours.dim .. colours.reverse .. colours.onred .. statusText .. colours.reset)
	io.write(conf.getColours().status)
	io.write(statusText .. colours.reset)
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
