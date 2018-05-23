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
	io.write("lua nano p0.1.0")

	io.write(colours.onblack .. "")
	local time = os.date("%a:%b:%d %I:%M")
	term.cursor.jump(1, xRes/2-string.len(time)/2)
	io.write(time .. colours.reset .. colours.reverse)

	term.cursor.jump(1, xRes-1-string.len(buffer.getName()))
	io.write(buffer.getName())

	io.write(colours.reset .. "")

end

function draw.fullText()

	term.cursor.jump(5, 5)
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
	io.write(buffer.getLines(cursor.y, 10)[1])

	term.cursor.jump(curPos+1, cursor.x)

end

function draw.drawAll()
	xRes, yRes = getRes()
	os.execute("clear")
	draw.topBar()
	draw.fullText()
end

function draw.draw()
	xRes, yRes = getRes()
	draw.topBar()
	draw.currentLine()
end

return draw
