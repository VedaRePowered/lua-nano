local draw = {} -- draw namespace
local scroll = 0 -- vertical screen scrool
local xRes, yRes = getRes() -- terminal resolution

function draw.ask(text) -- function for querrying the user

	term.cursor.jump(yRes, 1) -- jump to the bottom of the screen
	io.write(conf.getColours().lowerBar) -- set the correct colour
	for i = 1, xRes do -- fill the bar
		io.write(" ")
	end
	term.cursor.jump(yRes, 1) -- go back to the start of the bar
	io.write(text, ": ") -- write the prompt

	-- get user text input
	os.execute("stty isig icanon iexten ixoff echo")
	local r = io.read()
	os.execute("stty -isig -icanon -iexten -ixoff -echo")

	return r -- return the querryed value

end

function draw.topBar() -- function for drawing the menu bar

	term.cursor.jump(1, 1) -- jump to the top of the screen

	io.write(conf.getColours().topBar) -- set the correct colour

	for i = 1, xRes do -- fill the bar
		io.write(" ")
	end

	term.cursor.jump(1, 3) -- go back to the start of the bar ish
	io.write("lua nano " .. getVersion()) -- write version information

	local time = os.date("%a:%b:%d %I:%M") -- get current time
	term.cursor.jump(1, xRes/2-string.len(time)/2) -- go to the middle
	io.write(time) -- print the time

	term.cursor.jump(1, xRes-1-string.len(buffer.getName())) -- jump to the end
	io.write(buffer.getName()) -- print the name of the current buffer

	io.write(colours.reset .. "") -- reset the colour

end

function draw.fullText() -- draw every visable line to the screen

	for n, l in ipairs(buffer.getLines(scroll+1, yRes-3)) do -- loop through rows
		term.cursor.jump(n+1, 1) -- go to the start of the row
		syntax.write(l) -- print the row
	end

end

function draw.currentLine() -- draw the current line

	-- calculate cursor position on screen
	local curPos = cursor.y - scroll
	if curPos < 1 then -- reset the cursor if its too high
		scroll = scroll - 1
		curPos = 1
		draw.drawAll() -- then redraw everything
	end
	if curPos > yRes-2 then -- or if its too low
		scroll = scroll + 1
		curPos = yRes - 2
		draw.drawAll() -- then redraw everything
	end

	term.cursor.jump(curPos+1, 1) -- goto the start of the line
	term.cleareol() -- clear the line
	syntax.write(buffer.getLines(cursor.y)[1]) -- print the line

	term.cursor.jump(curPos+1, cursor.x) -- goto the correct cursor position

end

function draw.find() -- prompt for find
	local text = draw.ask("Find what?")
	return text
end

function draw.replace() -- prompt for replace
	local text = draw.ask("Find what?")
	local replace = draw.ask("Replace with")
	return text, replace
end

function draw.save() -- prompt for save

	local name = draw.ask("File name to write [" .. buffer.getName() .. "]") -- get the filename

	if name ~= "" and string.lower(name) ~= "cancel" then -- only set name if needed
		buffer.setName(name)
	end

	draw.drawAll() -- redraw the screen after prompt

	return string.lower(name) == "cancel" -- return if the editor should save

end

function draw.status() -- draw the current status text

	local statusText = status.get() -- get the status text
	term.cursor.jump(yRes, 1) -- goto the bottom line
	term.cleareol() -- clear said line
	term.cursor.jump(yRes, math.floor(xRes/2-string.len(statusText)/2)) -- goto the status text position

	io.write(conf.getColours().status) -- set the correct colour
	io.write(statusText .. colours.reset) -- print the status text

end

function draw.drawAll() -- draw EVERYTHING
	xRes, yRes = getRes() -- get resolution
	os.execute("clear") -- clear the screen using command prompt,
	term.clear() -- and then using lua-term
	draw.topBar() -- draw the top bar
	draw.status() -- draw the status
	draw.fullText() -- draw all the text
	draw.currentLine() -- draw the current line
end

function draw.draw() -- draw to get called after every keypress
	xRes, yRes = getRes() -- get resolution
	draw.topBar() -- draw top bar
	draw.status() -- draw status
	draw.currentLine() -- draw currentLine
end

return draw -- return namespace
