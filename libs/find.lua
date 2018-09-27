local find = {} -- find namespace
local found = {} -- variable to contain all matches
local instance = 1 -- current found instance

--[[
a findFunction is a function that is given a line and returns a math for that line.
a replaceFunction is a function that is given the user-defined replace string,
	where to insert it, and the old string that it is replacing
]]

function find.regularFindFunction(line, text, y, x) -- a findFunction for normal searches
	local r = nil -- return variable
	if string.sub(line, 1, string.len(text)) == text then -- go throug the line and test for the string
		r = {x, y, text} -- if found, add it to the return variable
	end
	return r -- return said return variable
end

function find.advancedFindFunction(line, text, y, x) -- a findFunction for regex searches
	local r = nil -- return variable
	local mat = table.pack(string.match(line, "^(" .. text .. ")")) -- match the string
	if mat[1] then -- if a match was found
		r = {x, y, mat[1]} -- set return variable
		table.remove(mat, 1) -- remove it from the list
		table.insert(r, mat) -- add the other values from string.math to the return variable
	end
	return r -- return said return variable
end

function find.regularReplaceFunction(replace, y, x, mat, old) -- a replaceFunction for normal replaces
	buffer.writeString(replace, y, x) -- simply write the string
end

function find.advancedReplaceFunction(replace, y, x, mat) -- a replaceFunction for regex replaces
	local err, func = pcall(load("function a(mat) return " .. replace .. "end return a")) -- make a function to figure out what to replace with
	if err then -- err is true when succesful
		local err, str = pcall(func, mat) -- call the user's function
		if err then -- err is true when succesful
			buffer.writeString(str, y, x) -- write the users function return value
		else
			if not err then err = "nil" end -- default err to the string nil
			status.set("lua RUN error in replace: " .. err) -- error if curring unsuccesful
			draw.status() -- draw status
			getKey() -- get a key to move on
		end
	else
		if not err then err = "nil" end -- default err to the string nil
		status.set("lua LOAD error in replace: " .. err) -- error if creating function unsuccesful
		draw.status() -- get a key to move on
		getKey() -- get a key to move on
	end
end

function find.find(text, findFunction) -- a function that takes some text a findFunction and searches the current buffer contents
	found = {} -- reset found value
	instance = 1 -- reset instance counter
	status.set("Searching...") -- set status to searching
	for n, l in ipairs(buffer.getLines()) do -- go through all lines
		for i = 1, string.len(l) do -- then go through all charecters
			found[#found+1] = findFunction(string.sub(l, i, string.len(l)), text, n, i) -- test if it matches
		end
	end
	find.jump() -- jump to the first instance
	status.set("Found " .. #found .. " occurences") -- set the correct status
	draw.drawAll() -- draw the whole screen
end

function find.replace(text, replace, findFunction, replaceFunction) -- function to replace some text given a replaceFunction, and some other paramaters
	local replaced = {} -- new variable for things to replace
	find.find(text, findFunction) -- find the text to replace
	for i = 1, #found do -- go through all instances and prompt the user is they want to replace it
		draw.currentLine() -- draw the current line
		io.write(colours.reverse .. found[instance][3] .. colours.reset) -- highlight found instance
		status.set("Replace instance #" .. instance .. "? [y/N]") -- prompt the user
		draw.status() -- draw the prompt, in the form of a status message
		if string.lower(getKey()) == "y" then -- if the user presses y, then added to the replaced list
			replaced[#replaced+1] = instance
		end
		find.next() -- goto next instance
	end

	-- some local variables to help with replacing the text
	local xOffset = 0 -- acumulative x offset, used for keeping track of replacing smaller strings with larger ones and vice-versa
	local lastY = -1 -- last y replaced on
	for _, ins in ipairs(replaced) do -- go through all places where we want to replace
		x, y, str = table.unpack(found[ins]) -- get one instance
		if lastY ~= y then -- if on a new line, reset the x offset
			xOffset = 0
		end
		lastY = y -- set the last y to the current y, now that the y comparison is done
		cursor.jump(x+string.len(str)+xOffset, y) -- jump the cursor to the end of the string to replace
		buffer.erase(string.len(str)) -- erase the entire string
		cursor.jump(x+xOffset, y) -- go back to where we want to insert text
		replaceFunction(replace, y, x+xOffset, found[4]) -- insert the new text
		xOffset = xOffset + (string.len(replace)-string.len(str)) -- acumulate the x offset based on the differance in string size between the old and new strings
	end

	status.set("Replaced " .. #replaced .. " occurences") -- set status when done
	draw.drawAll() -- draw everything
end

function find.jump() -- jump to the current instance
	if found[instance] then -- test to see if the instance is real, or not
		cursor.jump(found[instance][1], found[instance][2]) -- goto the instance
	end
end

function find.next() -- goto next instance
	instance = instance + 1 -- increment the instance counter
	if instance > #found then -- loop the increment counter
		instance = 1
	end
	status.set("Went to instance #" .. instance) -- display what instance we're at
	find.jump() -- jump to the instance (will redraw the status message for us)
end

return find -- return namespace
